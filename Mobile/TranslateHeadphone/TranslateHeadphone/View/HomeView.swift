//
//  ContentView.swift
//  TranslateHeadphone
//
//  Created by Tuan Phan on 2023/04/20.
//

import SwiftUI
import AVFoundation

struct AudioPlayerView: View {
    let url: String
    @State private var isPlaying = false
    @State private var player: AVPlayer?
    
    var body: some View {
        Button(action: togglePlay) {
//            Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 50, height: 50)
        }
        .onAppear {
            configureAudioSession()
            togglePlay()
        }
    }
    
    func togglePlay() {
        isPlaying.toggle()
        
        if isPlaying {
            var urlString = url.replacingOccurrences(of: "\"", with: "")
            urlString = urlString.replacingOccurrences(of: "[", with: "")
            urlString = String(urlString.replacingOccurrences(of: "]", with: ""))
            
            guard let url = URL(string: urlString) else {return}
            player = AVPlayer(url: url)
            player?.play()
        } else {
            player?.pause()
        }
    }
    
    func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            print("Error configuring audio session: \(error.localizedDescription)")
        }
    }
}

struct ContentView: View {
    var body: some View {
        AudioPlayerView(url: "https://storage.googleapis.com/translate_headphone/output-files/output0-20230429-204704.mp3")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray)
    }
}


