import yt_dlp

URLS = ['https://www.youtube.com/@AlexRuiiz']

ydl_opts = {
    'extract_flat': True,
    'quiet': True
}

try:
    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        info = ydl.extract_info(URLS[0], download=False)
        count = 0
        if 'entries' in info:
            for entry in info['entries']:
                print(entry.get('title'), entry.get('url'))
                count += 1
                if count >= 3:
                    break
except Exception as e:
    print("Error:", e)
