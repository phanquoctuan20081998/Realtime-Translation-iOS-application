//
//  TranslateHeadphoneApp.swift
//  TranslateHeadphone
//
//  Created by Tuan Phan on 2023/04/20.
//

import SwiftUI

@main
struct TranslateHeadphoneApp: App {
    var body: some Scene {
        WindowGroup {
            VoiceMemoView(audioRecorder: AudioRecorder())
//            ContentView()
        }
    }
}
