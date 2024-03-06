# Real-time Translation
This is a demo iOS application for real-time voice translation (Vietnamese 🇻🇳 and Japanese 🇯🇵) using GCP.

<img src="https://github.com/phanquoctuan20081998/SmartHeadphone/assets/32617517/135b2a39-5023-40c1-a2ce-440dd68ed74c" alt="IMG_6436" width="300">

### 1. Features
Translate Vietnamese to Japanese and Japanese to Vietnamese speaking voice in realtime

### 2. How does it work?
Step 1: We convert audio to text using Google's speech-to-text API. [Google Speech-to-Text](https://cloud.google.com/speech-to-text?hl=en)

Step 2: We translate text to the desired language using Google's translate API. [Google Translate](https://cloud.google.com/translate?hl=en)

Step 3: We convert back the translated text to audio using Google's text-to-speech API. [Google Text-to-Speech](https://cloud.google.com/text-to-speech?hl=en)

### 3. Google Cloud Requirements
**IMPORTANT:** To deploy and run this example, you'll need:

* **Google Cloud account:** If you're new to Google, create a Google account for free, and you'll receive some free Google credits to get started.

* **Google Cloud subscription:** You need access to speech-to-text, translation, and text-to-speech services on GCP.
  
### 4. Project Setup

**Backend Setup:**

1. Install the required tools: 
    * Python 3.9, 3.10, or 3.11
        * Important: Python and the pip package manager must be in the path in Windows for the setup scripts to work.
        * Important: Ensure you can run `python --version` from the console. On Ubuntu, you might need to run `sudo apt install python-is-python3` to link python to python3.
    * Git
    * Run `pip install -r requirements.txt`

2. Declare your GCP environment in `Credentials/*.json`
   
4. Run `export GOOGLE_APPLICATION_CREDENTIALS="path/to/credentials/file.json"`

5. Run `python Server/APIServer.py`

**Frontend Note:**

Before running, make sure you change your IP address and port in `Service/SendAudioRequest.swift` to match your backend server.
