import pandas as pd
import sys

file_path = r"c:\Users\rhood\Desktop\New-Forex\operaciones\Asian_V2.80_1.htm"
try:
    tables = pd.read_html(file_path)
    for i, t in enumerate(tables):
        print(f"--- Table {i} ---")
        print(t.to_string())
except Exception as e:
    print("Error:", e)
