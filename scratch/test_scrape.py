import scrapetube
import sys

try:
    videos = scrapetube.get_channel(channel_url="https://www.youtube.com/@AlexRuiiz")
    for i, video in enumerate(videos):
        if i >= 3:
            break
        print(video.get('videoId'))
        print(video.get('title', {}).get('runs', [{}])[0].get('text'))
        print("---")
except Exception as e:
    print("Error:", e)
