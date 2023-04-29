//
//  SpeechRecognizer.swift
//  TranslateHeadphone
//
//  Created by Tuan Phan on 2023/04/25.
//

import Foundation
import AVFAudio

class VoiceMemoViewModel: ObservableObject {
    @Published var isRecording = false
    private let audioEngine = AVAudioEngine()
    
    func startOrEndListening() {
        guard !audioEngine.isRunning else {
            audioEngine.stop()
            DispatchQueue.main.async {
                self.isRecording = false
            }
            return
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        
        audioSession.requestRecordPermission { granted in
            guard granted else { return }
            try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            let inputNode = self.audioEngine.inputNode
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0,
                                 bufferSize: 1024,
                                 format: recordingFormat) { (buffer: AVAudioPCMBuffer,
                                                             when: AVAudioTime) in
            }
            self.audioEngine.prepare()
            do {
                try self.audioEngine.start()
            } catch (let error) {
                assertionFailure(error.localizedDescription)
            }
            
            
            DispatchQueue.main.async {
                self.isRecording = true
            }
        }
    }
}
