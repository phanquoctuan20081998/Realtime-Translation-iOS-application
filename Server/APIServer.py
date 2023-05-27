from flask import Flask, request
import flask
import GCP
from Convert import convertm4awav
import time
import os

os.environ["GCLOUD_PROJECT"] = "smartheadphone"

app = Flask(__name__)

@app.route('/upload', methods=['POST'])
def upload_file():
    lang = request.args.get("lang")
    file_data = request.get_data()
    
    # Save audio file to local server
    timestr = time.strftime("%Y%m%d-%H%M%S")

    m4a_file = f'Input/file-{timestr}.m4a'
    wav_file = f'Input/file-{timestr}.wav'

    with open(m4a_file, 'wb') as f:
        f.write(file_data)

    # Convert m4a to wav
    convertm4awav(m4a_file, wav_file)

    # Save audio file to cloud server 
    GCP.upload_blob("translate_headphone_demo", wav_file, f"audio-files/{wav_file}")

    # Speech-to-Text
    texts = GCP.transcribe_file_from_gs(f"gs://translate_headphone_demo/audio-files/{wav_file}", lang)
    
    # Text-to-Text
    translated_texts = []
    for text in texts:
        translated_texts.append(GCP.translate_text(text=text, lang=lang))


    # Text-to-Speech
    speech_name = []
    for i in range(len(translated_texts)):
        speech_name.append(f"https://storage.googleapis.com/translate_headphone_demo/output-files/output{i}-{timestr}.mp3")
        GCP.synthesize_text(translated_texts[i][0], f"Output/output{i}-{timestr}.mp3", lang)
        GCP.upload_blob("translate_headphone_demo", f"Output/output{i}-{timestr}.mp3", f"output-files/output{i}-{timestr}.mp3")

    response = speech_name

    return response

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=4048)

