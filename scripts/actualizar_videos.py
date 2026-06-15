import yt_dlp
import os

URLS = ['https://www.youtube.com/@AlexRuiiz/videos']

ydl_opts = {
    'extract_flat': True,
    'quiet': True
}

def main():
    print("Obteniendo lista de videos (esto puede tardar unos segundos)...")
    try:
        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            info = ydl.extract_info(URLS[0], download=False)
            
        docs_dir = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "docs")
        os.makedirs(docs_dir, exist_ok=True)
        file_path = os.path.join(docs_dir, "Lista_Videos_Alex_Ruiz.md")
        
        with open(file_path, "w", encoding="utf-8") as f:
            f.write("# Lista de Videos de Alex Ruiz\n\n")
            f.write("Esta lista se genera automáticamente. Puedes actualizarla ejecutando el script `python scripts/actualizar_videos.py`.\n\n")
            
            if 'entries' in info:
                videos = info['entries']
                print(f"Se encontraron {len(videos)} videos.")
                for entry in videos:
                    title = entry.get('title')
                    url = entry.get('url')
                    if url and not url.startswith('http'):
                        url = "https://www.youtube.com/watch?v=" + url.split('v=')[-1] if 'v=' in url else url
                    f.write(f"- [{title}]({url})\n")
                print(f"Lista guardada exitosamente en: {file_path}")
            else:
                print("No se encontraron videos.")
                f.write("No se encontraron videos.\n")
    except Exception as e:
        print(f"Error al obtener los videos: {e}")

if __name__ == "__main__":
    main()
