//
//  APIRequest.swift
//  Picturama
//
//  Created by Duong Dinh on 6/2/19.
//  Copyright © 2019 DuongDH. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

struct HTTPHeader {
    let field: String
    let value: String
}

enum APIError: Error {
    case invalidURL
    case requestFailed
}

class APIRequest {
    let method: HTTPMethod
    let path: String
    var queryItems: [URLQueryItem]?
    var headers: [HTTPHeader]?
    var body: Data?
    
    init(method: HTTPMethod, path: String) {
        self.method = method
        self.path = path
    }
}

struct APIClient {
    typealias APIClientCompletion = (HTTPURLResponse?, Data?, APIError?) -> Void
    
    private let session = URLSession.shared
    private let baseURL = URL(string: "https://pixabay.com/api")
    private let accessKey = "12655795-1503a77817e6b536569a13860"
    
    func request(_ request: APIRequest, _ completion: @escaping APIClientCompletion) {
        guard let baseURL = self.baseURL else {
            completion(nil, nil, .invalidURL)
            return
        }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = baseURL.scheme
        urlComponents.host = baseURL.host
        urlComponents.path = baseURL.path
        urlComponents.queryItems = request.queryItems
        
        guard var url = urlComponents.url else {
            completion(nil, nil, .invalidURL)
            return
        }
        
        url.appendPathComponent(request.path)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        
        request.headers?.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.field) }
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, nil, .requestFailed)
                return
            }
            completion(httpResponse, data, nil)
        }
        task.resume()
    }
}
