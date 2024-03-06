# Realtime transaltion
This is a demo iOS application of realtime voice translation (Vietnamese 🇻🇳 and Japanese 🇯🇵) application using GCP.

<img src="https://github.com/phanquoctuan20081998/SmartHeadphone/assets/32617517/135b2a39-5023-40c1-a2ce-440dd68ed74c" alt="IMG_6436" width="300">

### 1. Feature
Translate Vietnamese to Japanese and backward

### 2. How does it work?
Step 1: We convert audio to text using Google's speech-to-text API. https://cloud.google.com/speech-to-text?hl=en
Step 2: We translate text to desire language by using Google's translate API. https://cloud.google.com/translate?hl=en
Step 3: We convert back the translated text to audio using Google's text-to-speech API. https://cloud.google.com/text-to-speech?hl=en

### 3. Google cloud requirements

**IMPORTANT:** In order to deploy and run this example, you'll need:

* **Google cloud account:** If you're new to Google, get an Google account for free and you'll get some free Google credits to get started.

* **Google cloud subscription:** You need to be able to access speech-to-text, translation and text-to-speech services on GCP.
  
### 4. Project setup

BACKEND SETUP:

1. Install the required tools: 
    * Python 3.9, 3.10, or 3.11
        * Important: Python and the pip package manager must be in the path in Windows for the setup scripts to work.
        * Important: Ensure you can run `python --version` from console. On Ubuntu, you might need to run `sudo apt install python-is-python3` to link python to python3.
    * Git
    * run `pip install -r requirements.txt`

2. Declare your GCP environment into `Credentials/*.json`
   
4. run `export GOOGLE_APPLICATION_CREDENTIALS="path/to/credentials/file.json"`

5. Run `python Server/APIServer.py`

FRONTEND NOTE:

Before running, make sure you change your IP adress and port in `Service/SendAudioRequest.swift` match with your backend server.



