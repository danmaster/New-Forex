import re
import os

docs_dir = r"c:\Users\rhood\Desktop\New-Forex\docs"

# 1. Fix Lista_Videos_*.md
for filename in ["Lista_Videos_Alex_Ruiz.md", "Lista_Videos_Yuri_Rabassa.md"]:
    filepath = os.path.join(docs_dir, filename)
    try:
        with open(filepath, "r", encoding="utf-8") as f:
            content = f.read()
    except UnicodeDecodeError:
        with open(filepath, "r", encoding="latin-1") as f:
            content = f.read()
            
    # Change "- [Title] (Date) (URL)" to "- [Title](URL) (Date)"
    new_content = re.sub(r"- \[(.*?)\] \((.*?)\) \((https?://.*?)\)", r"- [\1](\3) (\2)", content)
    
    with open(filepath, "w", encoding="utf-8") as f:
        f.write(new_content)

# 2. Fix asian_breakout_V1.02_Manual.md
filepath = os.path.join(docs_dir, "asian_breakout_V1.02_Manual.md")
with open(filepath, "r", encoding="utf-8") as f:
    lines = f.readlines()

new_lines = []
for line in lines:
    line = re.sub(r"^(\d+\.)\s{2,}", r"\1 ", line)
    line = re.sub(r"^(\s*[*+-])\s{2,}", r"\1 ", line)
    line = line.rstrip()
    if line.startswith("    *"):
        line = line.replace("    *", "  *")
    new_lines.append(line)

new_content = "\n".join(new_lines)

final_lines = []
lines = new_content.split('\n')
for i, line in enumerate(lines):
    final_lines.append(line)
    if line.startswith("### "):
        if i + 1 < len(lines) and lines[i+1].strip() != "":
            final_lines.append("")

with open(filepath, "w", encoding="utf-8") as f:
    f.write("\n".join(final_lines))

print("Markdown formatting fixed.")
