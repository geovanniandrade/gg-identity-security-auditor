#!/usr/bin/env python3
"""Static regression checks. Standard library only; requires Node.js for JS syntax."""
import csv
import json
import re
import subprocess
import tempfile
from html.parser import HTMLParser
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

class Inspector(HTMLParser):
    def __init__(self):
        super().__init__()
        self.scripts = []
        self.links = []
        self.in_script = False
    def handle_starttag(self, tag, attrs):
        a = dict(attrs)
        if tag == "script" and not a.get("src"):
            self.in_script = True
        if tag == "a" and a.get("href"):
            self.links.append(a["href"])
    def handle_endtag(self, tag):
        if tag == "script":
            self.in_script = False
    def handle_data(self, data):
        if self.in_script:
            self.scripts.append(data)

pages = sorted(ROOT.glob("*.html"))
assert {"index.html","studies.html","exam.html","report.html"}.issubset({p.name for p in pages})
for page in pages:
    parsed = Inspector()
    parsed.feed(page.read_text(encoding="utf-8"))
    for link in parsed.links:
        if link.startswith(("#","https:","http:","mailto:")):
            continue
        relative = link.split("?")[0].split("#")[0]
        if relative:
            assert (ROOT / relative).exists(), f"{page.name}: broken link {link}"
    src = "\n".join(parsed.scripts)
    if src.strip():
        with tempfile.NamedTemporaryFile(mode="w",suffix=".js",encoding="utf-8") as tmp:
            tmp.write(src)
            tmp.flush()
            subprocess.run(["node", "--check", tmp.name], check=True)
    print("OK",page.name)
for example in (ROOT/"examples").glob("*"):
    if example.suffix == ".json":
        json.loads(example.read_text(encoding="utf-8"))
    elif example.suffix == ".csv":
        with example.open(encoding="utf-8-sig",newline="") as f:
            rows=list(csv.DictReader(f))
            assert rows and all(rows[0].keys()), f"Invalid CSV {example}"
    print("OK example",example.name)
exam = (ROOT/"exam.html").read_text(encoding="utf-8")
match = re.search(r'const questions=(\[.*?\]);const form=',exam,re.S)
assert match, "Exam bank not found"
bank=json.loads(match.group(1))
assert len(bank)==10, "Expected exactly 10 questions"
assert all(len(q)==4 and len(q[1])==3 and 0<=q[2]<3 for q in bank)
print("OK exam: 10 well-formed questions")
