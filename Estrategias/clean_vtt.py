import re
import os

def clean_vtt():
    input_file = [f for f in os.listdir('.') if f.endswith('.vtt')][0]
    output_file = 'transcript.txt'
    with open(input_file, 'r', encoding='utf-8') as f:
        lines = f.readlines()
        
    cleaned_lines = []
    seen = set()
    
    for line in lines:
        line = line.strip()
        if not line or '-->' in line or line.startswith('WEBVTT') or line.startswith('Kind:') or line.startswith('Language:'):
            continue
            
        # Remove tags like <c> etc.
        line = re.sub(r'<[^>]*>', '', line)
        line = re.sub(r'align:start position:\d+%', '', line)
        
        if line and line not in seen:
            seen.add(line)
            cleaned_lines.append(line)
            
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(' '.join(cleaned_lines))

if __name__ == "__main__":
    clean_vtt()
