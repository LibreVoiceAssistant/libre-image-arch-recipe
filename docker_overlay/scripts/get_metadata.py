

import json
import pytz
import requests
from subprocess import check_output
from datetime import datetime


def get_commit_and_time(repo, branch="dev"):
    last_commit = requests.get(f"https://api.github.com/repos/OpenVoiceOS/{repo}/commits?sha={branch}").json()[0]
    # pprint(last_commit)
    commit_sha = last_commit.get("sha")
    commit_time = datetime.strptime(last_commit.get("commit").get("committer").get("date"),
                                    '%Y-%m-%dT%H:%M:%SZ').replace(tzinfo=pytz.UTC).timestamp()
    return commit_sha, commit_time


def get_project_meta(core_branch="dev"):
    try:
        image_sha = check_output(["git", "rev-parse",
                                  "HEAD"]).decode("utf-8").rstrip('\n')
        image_time = datetime.utcnow().timestamp()
    except Exception as e:
        print(e)
        image_sha, image_time = get_commit_and_time("ovos-image-recipe")

    core_sha, core_time = get_commit_and_time("ovos-core", "dev")

    core_version = "unknown"
    core_version_file = requests.get(f"https://raw.githubusercontent.com/OpenVoiceOS/ovos-core/{core_branch}/mycroft/version.py").content.decode('utf-8')
    if "OVOS_VERSION" in core_version_file:
        major, minor, build, alpha = 0, 0, 0, 0
        for line in core_version_file.split('\n'):
            if line.startswith("OVOS_VERSION_MAJOR"):
                major = int(line.split("=")[1].strip())
            if line.startswith("OVOS_VERSION_MINOR"):
                minor = int(line.split("=")[1].strip())
            if line.startswith("OVOS_VERSION_BUILD"):
                build = int(line.split("=")[1].strip())
            if line.startswith("OVOS_VERSION_ALPHA"):
                alpha = int(line.split("=")[1].strip())
        core_version = f"{major}.{minor}.{build}a{alpha}"

    meta = {"image": {
        "sha": image_sha,
        "time": image_time
    },
        "core": {
            "sha": core_sha,
            "time": core_time,
            "version": core_version
        }}
    return meta


if __name__ == "__main__":
    print(json.dumps(get_project_meta()))
