import ffmpeg
from pydub import AudioSegment as convert
import os

def convertm4awav(input, output):
    os.system(f"ffmpeg -i {input} {output}")