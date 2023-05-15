//
//  SendAudioRequest.swift
//  TranslateHeadphone
//
//  Created by Tuan Phan on 2023/04/22.
//

import Foundation
import AVKit
import SwiftUI

class SendAudioService {
    func uploadAudio(audioData: Data, name: String, completionHandler: @escaping (Data?, Error?) -> Void) {
        let url = URL(string: "http://10.192.42.248:4038/upload")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = audioData
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completionHandler(nil, error)
            } else if let response = response as? HTTPURLResponse {
                print("Status code: \(response.statusCode)")
                completionHandler(data, nil)
            }
        }
        
        task.resume()
    }
}
