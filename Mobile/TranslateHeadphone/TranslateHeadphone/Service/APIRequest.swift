//
//  APIRequest.swift
//  PrettyWidget (iOS)
//
//  Created by Tuan Phan Quoc on 12/03/2022.
//

import Foundation
import Alamofire
import Combine

class APIRequest {
    private var cancellation: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    
    func request<T: APIResponseProtocol>(url: String, method: HTTPMethod = .post, headers: HTTPHeaders? = nil, httpBody: APIModelProtocol? = nil, parameters: Parameters? = nil, type: T.Type, customError: String = "", debugPrint: Bool = false, baseURL: String = Config.baseURL, completion: @escaping ((Result<T, AppError>) -> Void)) {
        cancellation?.cancel()
        let publisher: AnyPublisher<Result<T, AFError>, Never>
        let jsonHeader = HTTPHeader.init(name: "Content-Type", value: "application/json; charset=utf-8")
        var newHeaders: HTTPHeaders
        if let headers = headers {
            newHeaders = headers
            newHeaders.add(jsonHeader)
        } else {
            newHeaders = HTTPHeaders.init([jsonHeader])
        }
        publisher = AF.request(baseURL + url, method: method, parameters: parameters, headers: newHeaders) { urlRequest in
            urlRequest.httpBody = httpBody?.data
            urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
            
        }.validate(statusCode: 200..<300).responseString(completionHandler: { response in
            if debugPrint {
                print(response.value ?? "")
            }
        }).publishDecodable(type: T.self).result()
        cancellation = publisher.sink { response in
            let result = self.convertAppError(response, customMess: customError)
            completion(result)
        }
    }
    
    func cancel() {
        cancellation?.cancel()
    }
    
    private func convertAppError<T: APIResponseProtocol>(_ result: Result<T, AFError>, customMess: String = "") -> Result<T, AppError> {
        switch result {
        case .success(let value):
            if value.status != nil {
                if value.status == 200 {
                    return .success(value)
                } else {
                    if customMess.isEmpty {
                        if let messages = value.messages {
                            let text = messages.map { m in
                                return m == m ? AppError.unkown.text : m
                            }
                            return .failure(AppError.custom(text: text.joined(separator: "\n")))
                        }
                        return .failure(AppError.unkown)
                    } else {
                        return .failure(AppError.custom(text: customMess))
                    }
                }
            } else {
                return .success(value)
            }
        case .failure(let afError):
            if afError.responseCode == 401 {
                return .failure(AppError.session)
            }
            if let error = afError.underlyingError as? URLError {
                if error.code == .timedOut
                    || error.code == .notConnectedToInternet
                    || error.code == .cannotFindHost
                    || error.code == .networkConnectionLost
                    || error.code == .cannotConnectToHost {
                    return .failure(AppError.connection)
                } else {
                    return .failure(AppError.http)
                }
            }
            
            if afError.underlyingError is DecodingError {
                return .failure(AppError.data)
            }
            
            return .failure(AppError.unkown)
        }
    }
}


protocol APIServiceProtocol {
    var apiRequest: APIRequest { get }
    func cancel()
}

extension APIServiceProtocol {
    func cancel() {
        apiRequest.cancel()
    }
}
