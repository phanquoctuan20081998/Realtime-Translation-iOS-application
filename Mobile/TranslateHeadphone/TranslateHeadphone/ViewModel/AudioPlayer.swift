//
//  AudioPlayer.swift
//  TranslateHeadphone
//
//  Created by Tuan Phan on 2023/04/26.
//

import Foundation

import SwiftUI
import Combine
import AVFoundation

class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    let objectWillChange = PassthroughSubject<AudioPlayer, Never>()
    
    var isPlaying = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    var audioPlayer: AVAudioPlayer!
    var player: AVPlayer! // For streaming
    
    func startPlayback(audio: URL) {
        let playbackSession = AVAudioSession.sharedInstance()
        
        do {
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Playing over the device's speakers failed")
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audio)
            audioPlayer.delegate = self
            audioPlayer.play()
            isPlaying = true
        } catch {
            print("Playback failed.")
        }
    }
    
    func startPlaybackFromUrl(urlString: String) {
        
        var urlString = urlString.replacingOccurrences(of: "\"", with: "")
        urlString = urlString.replacingOccurrences(of: "[", with: "")
        urlString = urlString.replacingOccurrences(of: "]", with: "")
        print(urlString)
        
        guard let url = URL(string: urlString) else {return}
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .default)
            try session.setActive(true)
        } catch {
            print(error.localizedDescription)
        }
        
        let item = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: item)
        player.play()
        isPlaying = true
    }
    
    func stopPlayback() {
        audioPlayer.stop()
        isPlaying = false
    }
    
    func stopPlaybackFromUrl() {
        player.pause()
        isPlaying = false
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
        }
    }
    
    
}
