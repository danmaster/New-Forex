import sys
import json
from youtube_transcript_api import YouTubeTranscriptApi

video_id = "xTTDH5iRhJc"
try:
    api = YouTubeTranscriptApi()
    transcript = api.fetch(video_id, languages=['es', 'en'])
    with open("Transcripcion_This_Simple_Scalping.md", "w", encoding="utf-8") as f:
        for t in transcript:
            f.write(t.text + "\n")
    print("Transcript downloaded successfully")
except Exception as e:
    print(f"Error: {e}")
