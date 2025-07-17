//
//  NetworkManager.swift
//  OpenFood
//
//  Created by Jonathan Ngabo on 2025-07-16.
//

import Foundation
import Combine


protocol NetworkManagerProtocol {
    func request<T: Decodable>(configuration: NetworkConfiguration, type: T.Type) -> AnyPublisher<T, NetworkError>
}


class NetworkManager: NetworkManagerProtocol {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func request<T: Decodable>(configuration: NetworkConfiguration, type: T.Type) -> AnyPublisher<T, NetworkError> {
        
        
        guard let url = URL(string: configuration.url) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = configuration.httpMethod.rawValue
        request.cachePolicy = .reloadRevalidatingCacheData
        request.timeoutInterval = configuration.timeoutInterval
        
        for each in configuration.headers {
            request.addValue(each.1, forHTTPHeaderField: each.0)
        }
        
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                if let response = response as? HTTPURLResponse {
                   try self.handleHTTPResponse(response)
                }
                return data
            }
            .decode(type: type, decoder: JSONDecoder())
            .mapError { error in
                if let urlError = error as? URLError {
                    switch urlError.code {
                    case .timedOut:
                        return NetworkError.timeout
                    case .notConnectedToInternet, .networkConnectionLost:
                        return NetworkError.noInternetConnection
                    default:
                        return NetworkError.networkError(urlError)
                    }
                }
                return NetworkError.networkError(error)
            }
            .eraseToAnyPublisher()
    }
    
    
    private func handleHTTPResponse(_ response: HTTPURLResponse) throws {
        switch response.statusCode {
        case 200...299:
            break // Success
        case 400:
            throw NetworkError.serverError(response.statusCode)
        case 401:
            throw NetworkError.unauthorized
        case 403:
            throw NetworkError.forbidden
        case 404:
            throw NetworkError.notFound
        case 429:
            throw NetworkError.tooManyRequests
        case 500:
            throw NetworkError.internalServerError
        case 502:
            throw NetworkError.badGateway
        case 503:
            throw NetworkError.serviceUnavailable
        case 504:
            throw NetworkError.gatewayTimeout
        default:
            throw NetworkError.serverError(response.statusCode)
        }
    }
}
