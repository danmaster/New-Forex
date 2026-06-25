import os

folder = r'c:\Users\rhood\Desktop\New-Forex\docs'
files = ['Entorno.md', 'Lista_Videos_Alex_Ruiz.md', 'Lista_Videos_Yuri_Rabassa.md']

replacements = {
    'Ã¡': 'á',
    'Ã©': 'é',
    'Ã\xad': 'í',
    'Ã³': 'ó',
    'Ãº': 'ú',
    'Ã±': 'ñ',
    'Ã ': 'Á',
    'Ã‰': 'É',
    'Ã\x8d': 'Í',
    'Ã“': 'Ó',
    'Ãš': 'Ú',
    'Ã‘': 'Ñ',
    'Â¿': '¿',
    'Â¡': '¡',
    'Ã¼': 'ü',
    'Ã¢': 'â',
    'Ãª': 'ê',
    'Ã®': 'î',
    'Ã´': 'ô',
    'Ã»': 'û'
}

for filename in files:
    filepath = os.path.join(folder, filename)
    with open(filepath, 'r', encoding='utf-8-sig') as f:
        content = f.read()
    
    for old, new in replacements.items():
        content = content.replace(old, new)
        
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)
    print(f'Fixed {filename}')
