import yt_dlp
import os

CHANNELS = {
    "Alex Ruiz": "https://www.youtube.com/@AlexRuiiz/videos",
    "Yuri Rabassa": "https://www.youtube.com/@YuriRabassa/videos"
}

ydl_opts = {
    'extract_flat': True,
    'quiet': True,
    'extractor_args': {'youtube': ['lang=es-ES,es']},
    'http_headers': {'Accept-Language': 'es-ES,es;q=0.9'}
}

def main():
    print("Obteniendo listas de videos (esto puede tardar unos minutos en total)...")
    docs_dir = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "docs")
    os.makedirs(docs_dir, exist_ok=True)
    
    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        for name, url in CHANNELS.items():
            print(f"\nProcesando canal: {name}...")
            try:
                info = ydl.extract_info(url, download=False)
                
                safe_name = name.replace(" ", "_")
                file_path = os.path.join(docs_dir, f"Lista_Videos_{safe_name}.md")
                
                with open(file_path, "w", encoding="utf-8") as f:
                    f.write(f"# Lista de Videos de {name}\n\n")
                    f.write("Esta lista se genera automáticamente. Puedes actualizarla ejecutando el script `python scripts/actualizar_videos.py`.\n\n")
                    
                    if 'entries' in info:
                        videos = info['entries']
                        print(f"Se encontraron {len(videos)} videos en {name}.")
                        for entry in videos:
                            title = entry.get('title')
                            v_url = entry.get('url')
                            if v_url and not v_url.startswith('http'):
                                v_url = "https://www.youtube.com/watch?v=" + v_url.split('v=')[-1] if 'v=' in v_url else v_url
                            f.write(f"- [{title}]({v_url})\n")
                        print(f"Lista guardada exitosamente en: {file_path}")
                    else:
                        print(f"No se encontraron videos para {name}.")
                        f.write("No se encontraron videos.\n")
            except Exception as e:
                print(f"Error al obtener los videos de {name}: {e}")

if __name__ == "__main__":
    main()
