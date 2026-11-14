#!/usr/bin/env python3
"""Re-apply the Universal Workspace rebrand after each upstream sync (idempotent).

Protected anchors (kept intact on every run):
- LICENSE (AGPL, untouched)
- External build dependencies (functional, upstream-owned):
  AppFlowy-IO/AppFlowy-Cloud, AppFlowy-IO/AppFlowy-Collab (cargo git),
  appflowy-editor, appflowy-board, appflowy-plugins (pub git), and the
  appflowy_editor / appflowy_board / AppFlowyEditor / AppFlowyBoard names
- .github/ and scripts/ are excluded from the sweep entirely
"""
from pathlib import Path
import re, shutil

SKIP_EXT = {".png",".jpg",".jpeg",".ico",".webp",".woff",".woff2",".ttf",".eot",".otf",".gif",".pdf",".gz",".zip",".mp4"}
KEEP = {"LICENSE", "migrate.py"}
DELETE = ["CHANGELOG.md", "CODE_OF_CONDUCT.md", "ROADMAP.md", "doc", "commitlint.config.js",
          "codemagic.yaml", "install.sh", ".github/FUNDING.yml",
          ".github/ISSUE_TEMPLATE", ".github/PULL_REQUEST_TEMPLATE"]
URL_FIX = [("yashhasan570/UniversalWorkspace-Cloud", "AppFlowy-IO/AppFlowy-Cloud"),
           ("yashhasan570/UniversalWorkspace-Collab", "AppFlowy-IO/AppFlowy-Collab"),
           ("yashhasan570/appflowy-board", "AppFlowy-IO/appflowy-board"),
           ("yashhasan570/appflowy-editor", "AppFlowy-IO/appflowy-editor"),
           ("yashhasan570/UniversalWorkspace-plugins", "AppFlowy-IO/appflowy-plugins")]


def sweep(t):
    t = re.sub(r"appflowy_editor(?![a-z])", "__AED__", t)
    t = re.sub(r"appflowy_board(?![a-z])", "__ABD__", t)
    t = re.sub(r"appflowy-editor(?![a-z])", "__AED2__", t)
    t = re.sub(r"appflowy-board(?![a-z])", "__ABD2__", t)
    t = re.sub(r"AppFlowyEditor", "__AECD__", t)
    t = re.sub(r"AppFlowyBoard", "__ABCD__", t)
    t = re.sub(r"AppFlowy", "UniversalWorkspace", t)
    t = re.sub(r"Appflowy", "UniversalWorkspace", t)
    t = re.sub(r"APPFLOWY", "UNIVERSALWORKSPACE", t)
    t = re.sub(r"appflowy", "universalworkspace", t)
    t = re.sub(r"Flowy", "Uniflow", t)
    t = re.sub(r"flowy", "uniflow", t)
    t = re.sub(r"FLOWY", "UNIFLOW", t)
    t = t.replace("__AECD__", "AppFlowyEditor").replace("__ABCD__", "AppFlowyBoard")
    t = t.replace("__AED__", "appflowy_editor").replace("__ABD__", "appflowy_board")
    t = t.replace("__AED2__", "appflowy-editor").replace("__ABD2__", "appflowy-board")
    for a, b in URL_FIX:
        t = t.replace(a, b)
    return t


def main():
    for d in DELETE:
        p = Path(d)
        if p.is_dir():
            shutil.rmtree(p, ignore_errors=True)
        elif p.exists():
            p.unlink()
    for p in Path(".").rglob("*"):
        if ".git" in p.parts or not p.is_file() or p.name in KEEP or p.suffix in SKIP_EXT:
            continue
        if str(p).startswith((".github/", "scripts/")):
            continue
        try:
            t = p.read_text()
        except Exception:
            continue
        nt = sweep(t)
        if p.suffix == ".md":
            nt = nt.replace("UniversalWorkspace", "Universal Workspace")
        if nt != t:
            p.write_text(nt)
    for p in list(Path(".").rglob("*appflowy*")) + list(Path(".").rglob("*AppFlowy*")) + list(Path(".").rglob("*flowy*")) + list(Path(".").rglob("*Flowy*")):
        if ".git" in p.parts or p.is_dir() or "appflowy_editor" in p.name or "appflowy_board" in p.name:
            continue
        nb = re.sub(r"appflowy", "universalworkspace", p.name)
        nb = re.sub(r"AppFlowy", "UniversalWorkspace", nb)
        nb = re.sub(r"flowy", "uniflow", nb)
        nb = re.sub(r"Flowy", "Uniflow", nb)
        if nb != p.name:
            p.rename(p.with_name(nb))
    for p in sorted(Path(".").rglob("*"), key=lambda x: len(x.parts), reverse=True):
        if ".git" in p.parts or not p.is_dir():
            continue
        nb = (p.name.replace("appflowy", "universalworkspace").replace("AppFlowy", "UniversalWorkspace")
                    .replace("flowy", "uniflow").replace("Flowy", "Uniflow"))
        if nb != p.name:
            try:
                p.rename(p.with_name(nb))
            except Exception:
                pass
    readme = Path("README.md")
    if readme.exists() and not readme.read_text().startswith("# Universal Workspace"):
        print("README drifted - rewrite needed")
    print("migrate done")


if __name__ == "__main__":
    main()
