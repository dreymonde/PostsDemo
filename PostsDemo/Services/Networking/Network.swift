//
//  Network.swift
//  PostsDemo
//
//  Created by Oleg Dreyman on 02.08.2021.
//

import Foundation
import Combine

final class Network {
    
    let urlSession: URLSession
    let baseURL: URL
    
    static let jsonEncoder = JSONEncoder()
    static let jsonDecoder = JSONDecoder()
    
    init(urlSession: URLSession, baseURL: URL) {
        self.urlSession = urlSession
        self.baseURL = baseURL
    }
    
    func httpPost<Request: Encodable, Response: Decodable>(_ responseType: Response.Type, path: String, requestBody: Request) -> AnyPublisher<Response, Swift.Error> {
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try? Network.jsonEncoder.encode(requestBody)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return httpRequest(responseType, urlRequest: urlRequest)
    }
    
    func httpGet<Response: Decodable>(_ responseType: Response.Type, path: String) -> AnyPublisher<Response, Swift.Error> {
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))
        urlRequest.httpMethod = "GET"
        
        return httpRequest(responseType, urlRequest: urlRequest)
    }
    
    enum Error: Swift.Error {
        case noDataNoError(URLResponse?)
        case cantConvert(Data, URLResponse?)
    }
    
    private func httpRequest<Response: Decodable>(_ responseType: Response.Type, urlRequest: URLRequest) -> AnyPublisher<Response, Swift.Error> {
        urlSession
            .dataTaskPublisher(for: urlRequest)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: Response.self, decoder: Self.jsonDecoder)
            // delay here is simply so that it's easier
            // to see how caching / db layer works
            .delay(for: 2.0, scheduler: DispatchQueue.main)
            .timeout(10.0, scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
