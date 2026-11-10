"""PLACEHOLDER: built in Task 9."""
import subprocess


def library_local_commits(env):
    if not (env.lib / ".git").exists():
        return 0
    p = subprocess.run(["git", "-C", str(env.lib), "rev-list", "--count", "HEAD", "--not", "--remotes"],
                       capture_output=True, text=True, env=env.environ)
    try:
        return int(p.stdout.strip() or 0)
    except ValueError:
        return 1
