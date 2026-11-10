"""One dream run, step by step (plan "One run"), and the `dream` command line."""
import sys

from . import extract, paths


def main(argv, doc=""):
    env = paths.Env()
    cmd = argv[0] if argv else "help"
    if cmd == "extract" and len(argv) == 2:
        try:
            r = extract.read_session(argv[1])
            extract.scrub_entries(r.entries, env)
        except extract.UnknownShape as e:
            print("dream: %s" % e, file=sys.stderr)
            return 4
        text, _ = extract.render_digest(r.session, "?", r.entries)
        sys.stdout.write(text)
        return 0
    print(doc.strip())
    return 0 if cmd in ("help", "-h", "--help") else 2
