import re

file_path = r"c:\Users\rhood\Desktop\New-Forex\operaciones\Asian_V2.80_1.htm"
try:
    with open(file_path, "r", encoding="cp1252", errors="ignore") as f:
        html = f.read()

    # Extract rows
    rows = re.findall(r'<tr.*?>(.*?)</tr>', html, re.IGNORECASE | re.DOTALL)
    for row in rows:
        cells = re.findall(r'<t[dh].*?>(.*?)</t[dh]>', row, re.IGNORECASE | re.DOTALL)
        # strip tags inside cells
        cleaned_cells = [re.sub(r'<[^>]+>', '', c).strip() for c in cells]
        if any(cleaned_cells):
            print(" | ".join(cleaned_cells))
except Exception as e:
    print("Error:", e)
