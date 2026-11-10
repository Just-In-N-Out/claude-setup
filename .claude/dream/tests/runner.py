"""Test runner for run.sh: unittest discovery, numbered TAP output by test method name.

Each test prints `ok N - <name>` or `not ok N - <name>` (followed by `# ` detail lines), so a log
can be checked by the test's own name. The live test (test_live_*) runs only with --live.
"""
import io
import os
import sys
import time
import traceback
import unittest
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent / "lib"))
sys.path.insert(0, str(HERE))
sys.dont_write_bytecode = True
os.environ.setdefault("DREAM_TEST_ROOT", str(Path(os.environ["HOME"]) / ".cache/dream-tests"))


def flatten(suite):
    for t in suite:
        if isinstance(t, unittest.TestSuite):
            yield from flatten(t)
        else:
            yield t


def main(argv):
    live = "--live" in argv
    names = [a for a in argv if a != "--live"]
    loader = unittest.TestLoader()
    tests = list(flatten(loader.discover(str(HERE), pattern="test_*.py", top_level_dir=str(HERE))))
    broken = [t for t in tests if t.__class__.__name__ == "_FailedTest"]
    tests = [t for t in tests if t.__class__.__name__ != "_FailedTest"]
    by_name = {}
    for t in tests:
        by_name.setdefault(t._testMethodName, []).append(t)
    if names:
        missing = [n for n in names if n not in by_name]
        if missing:
            for t in broken:  # an import failure explains a missing name: show it
                print(t._exception if hasattr(t, "_exception") else t)
            print("Bail out! no test named " + ", ".join(missing))
            return 1
        tests = [t for n in names for t in by_name[n]]
    elif not live:
        tests = [t for t in tests if not t._testMethodName.startswith("test_live_")]
    for t in broken:
        print("not ok 0 - import of " + t._testMethodName)
        try:
            t.debug()
        except Exception:  # the module's own import error, e.g. ModuleNotFoundError
            for ln in traceback.format_exc().splitlines():
                print("# " + ln)
    print("1..%d" % len(tests))
    failed = len(broken)
    for n, t in enumerate(tests, 1):
        result = unittest.TestResult()
        start = time.time()
        buf = io.StringIO()
        old_out = sys.stdout
        sys.stdout = buf
        try:
            t.run(result)
        finally:
            sys.stdout = old_out
        secs = time.time() - start
        name = t._testMethodName
        problems = result.errors + result.failures
        if result.skipped:
            print("ok %d - %s # SKIP %s" % (n, name, result.skipped[0][1]))
        elif problems or result.unexpectedSuccesses:
            failed += 1
            print("not ok %d - %s" % (n, name))
            for _, tb in problems:
                for ln in tb.rstrip().splitlines():
                    print("#  " + ln)
        else:
            print("ok %d - %s" % (n, name))
        for ln in buf.getvalue().rstrip().splitlines():
            print("#  " + ln)
        print("#  (%s.%s, %.1f s)" % (t.__class__.__module__, t.__class__.__name__, secs))
    print("# passed %d, failed %d" % (len(tests) - failed + len(broken), failed))
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
