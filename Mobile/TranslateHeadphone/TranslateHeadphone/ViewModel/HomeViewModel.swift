//
//  HomeViewModel.swift
//  TranslateHeadphone
//
//  Created by Tuan Phan on 2023/04/20.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var audioData = Data()
    @Published var audioName = ""
    @Published var respondedAudio : [String] = []
    @Published var isGetResponse = false
    @Published var lang = ""
    
    private var sendAudioService = SendAudioService()
    
    func loadData(data: Data, name: String) {
        self.audioData = data
        self.audioName = name
    }
    func sendAudio() {
        sendAudioService.uploadAudio(audioData: audioData, parameters: ["lang": self.lang] ) { data, error in
            DispatchQueue.main.async {
                let response = self.dataToStringArray(data: data ?? Data())
                self.respondedAudio = response
                self.isGetResponse = true
                print(self.lang)
            }
        }
    }
    
    func dataToStringArray(data: Data, encoding: String.Encoding = .utf8, delimiter: String = "\n") -> [String] {
        if let stringData = String(data: data, encoding: encoding) {
            let stringArray = stringData.components(separatedBy: delimiter)
            return stringArray
        } else {
            return []
        }
    }

}
