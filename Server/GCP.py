# Store audio to GCP Storege
def upload_blob(bucket_name, source_file_name, destination_blob_name):
    """Uploads a file to the bucket."""
    # The ID of your GCS bucket
    # bucket_name = "your-bucket-name"
    # The path to your file to upload
    # source_file_name = "local/path/to/file"
    # The ID of your GCS object
    # destination_blob_name = "storage-object-name"

    from google.cloud import storage

    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(destination_blob_name)

    # Optional: set a generation-match precondition to avoid potential race conditions
    # and data corruptions. The request to upload is aborted if the object's
    # generation number does not match your precondition. For a destination
    # object that does not yet exist, set the if_generation_match precondition to 0.
    # If the destination object already exists in your bucket, set instead a
    # generation-match precondition using its generation number.
    generation_match_precondition = 0

    blob.upload_from_filename(source_file_name, if_generation_match=generation_match_precondition)

    print(
        f"File {source_file_name} uploaded to {destination_blob_name}."
    )



# Translate text-to-text
def translate_text(text="YOUR_TEXT_TO_TRANSLATE", project_id="smartheadphone", lang="vn"):
    """Translating Text."""
    from google.cloud import translate

    source_language_code = "vi-VN" if lang == "vn" else "ja-JP"
    target_language_code = "ja" if lang == "vn" else "vi"

    rs = []

    client = translate.TranslationServiceClient()

    location = "global"

    parent = f"projects/{project_id}/locations/{location}"

    # Translate text from English to French
    # Detail on supported types can be found here:
    # https://cloud.google.com/translate/docs/supported-formats
    response = client.translate_text(
        request={
            "parent": parent,
            "contents": [text],
            "mime_type": "text/plain",  # mime types: text/plain, text/html
            "source_language_code": source_language_code,
            "target_language_code": target_language_code,
        }
    )

    # Display the translation for each input text provided
    for translation in response.translations:
        translated = translation.translated_text
        print("Translated text: {}".format(translated))

        if translated:
            rs.append(translated)

    return rs



# Generate Text-to-Speech
def synthesize_text(text, output, lang):
    """Synthesizes speech from the input string of text."""
    from google.cloud import texttospeech

    lang_code = "ja-JP" if lang == "vn" else "vi-VN"
    name = "ja-JP-Neural2-B" if lang == "vn" else "vi-VN-Standard-C"

    client = texttospeech.TextToSpeechClient()

    input_text = texttospeech.SynthesisInput(text=text)

    # Note: the voice can also be specified by name.
    # Names of voices can be retrieved with client.list_voices().
    voice = texttospeech.VoiceSelectionParams(
        language_code=lang_code,
        name=name,
        ssml_gender=texttospeech.SsmlVoiceGender.FEMALE,
    )

    audio_config = texttospeech.AudioConfig(
        audio_encoding=texttospeech.AudioEncoding.MP3
    )

    response = client.synthesize_speech(
        request={"input": input_text, "voice": voice, "audio_config": audio_config}
    )

    # The response's audio_content is binary.
    with open(output, "wb") as out:
        out.write(response.audio_content)
        print(f'Audio content written to file "{output}"')



# Generate Speech-to-Text
def transcribe_file(speech_file, lang):
    """Transcribe the given audio file asynchronously."""
    from google.cloud import speech

    lang_code = lang_code_convert(lang)

    rs = []

    client = speech.SpeechClient()

    with open(speech_file, "rb") as audio_file:
        content = audio_file.read()

    """
     Note that transcription is limited to a 60 seconds audio file.
     Use a GCS file for audio longer than 1 minute.
    """
    audio = speech.RecognitionAudio(content=content)

    config = speech.RecognitionConfig(
        encoding=speech.RecognitionConfig.AudioEncoding.LINEAR16,
        sample_rate_hertz=12000,
        language_code=lang_code,
    )


    operation = client.long_running_recognize(config=config, audio=audio)

    print("Waiting for operation to complete...")
    response = operation.result(timeout=90)

    # Each result is for a consecutive portion of the audio. Iterate through
    # them to get the transcripts for the entire audio file.
    for result in response.results:
        # The first alternative is the most likely one for this portion.
        print("Transcript: {}".format(result.alternatives[0].transcript))

        rs.append(result.alternatives[0].transcript)



def transcribe_file_from_gs(gcs_uri, lang):

    """Asynchronously transcribes the audio file specified by the gcs_uri."""
    from google.cloud import speech

    lang_code = lang_code_convert(lang)

    rs = []
    client = speech.SpeechClient()

    audio = speech.RecognitionAudio(uri=gcs_uri)
    config = speech.RecognitionConfig(
        encoding=speech.RecognitionConfig.AudioEncoding.LINEAR16,
        sample_rate_hertz=12000,
        language_code=lang_code,
    )

    operation = client.long_running_recognize(config=config, audio=audio)

    print("Waiting for operation to complete...")
    response = operation.result(timeout=90)

    # Each result is for a consecutive portion of the audio. Iterate through
    # them to get the transcripts for the entire audio file.
    for result in response.results:
        # The first alternative is the most likely one for this portion.
        transcript = result.alternatives[0].transcript
        print("Transcript: {}".format(transcript))
        print("Confidence: {}".format(transcript))
        
        if transcript:
            rs.append(transcript)

    return rs

# List down the available voices in text-to-speech.
def list_voices():
    """Lists the available voices."""
    from google.cloud import texttospeech

    client = texttospeech.TextToSpeechClient()

    # Performs the list voices request
    voices = client.list_voices()

    for voice in voices.voices:
        # Display the voice's name. Example: tpc-vocoded
        print(f"Name: {voice.name}")

        # Display the supported language codes for this voice. Example: "en-US"
        for language_code in voice.language_codes:
            print(f"Supported language: {language_code}")

        ssml_gender = texttospeech.SsmlVoiceGender(voice.ssml_gender)

        # Display the SSML Voice Gender
        print(f"SSML Voice Gender: {ssml_gender.name}")

        # Display the natural sample rate hertz for this voice. Example: 24000
        print(f"Natural Sample Rate Hertz: {voice.natural_sample_rate_hertz}\n")

def lang_code_convert(lang):
    if lang == "vn":
        lang_code = "vi-VN"
    else:
        lang_code = "ja-JP"

    return lang_code

list_voices()

