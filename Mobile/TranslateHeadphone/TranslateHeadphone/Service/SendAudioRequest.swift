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
    func uploadAudio(audioData: Data, parameters: [String: String], completionHandler: @escaping (Data?, Error?) -> Void) {
//        let url = URL(string: "http://10.192.42.248:4038/upload")!
        var components = URLComponents(string: "http://192.168.11.4:4048/upload")!
        components.queryItems = parameters.map { (key, value) in
                URLQueryItem(name: key, value: value)
            }
        
        var request = URLRequest(url: components.url!)
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
