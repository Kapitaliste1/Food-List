//
//  NetworkConfiguration.swift
//  OpenFood
//
//  Created by Jonathan Ngabo on 2025-07-16.
//
import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
}

enum Path {
    case foodList(currentPage: Int)
    case likeFood(id: Int, isLiked: Bool)
}


struct NetworkConfiguration {
    let baseURL: String = "https://opentable-dex-ios-test-d645a49e3287.herokuapp.com/api/v1/jngabo/"
    let url: String
    let httpMethod: HTTPMethod
    let headers: [String: String] = ["Content-Type" : "application/json"]
    let timeoutInterval: TimeInterval = 30.0
    
    init(path: Path) {
        
        switch path {
        case .foodList(currentPage: let currentPage):
            self.url = self.baseURL + "food/\(currentPage)"
            self.httpMethod = .get
            
        case .likeFood(id: let id, isLiked: let isLiked):
            let suffix: String = isLiked ? "like" : "unlike"
            self.url = self.baseURL + "food/\(id)/\(suffix)"
            self.httpMethod = .put
        }
    }
}


//
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case encodingError(Error)
    case serverError(Int)
    case networkError(Error)
    case invalidResponse
    case timeout
    case unauthorized
    case forbidden
    case notFound
    case tooManyRequests
    case internalServerError
    case badGateway
    case serviceUnavailable
    case gatewayTimeout
    case noInternetConnection
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .encodingError(let error):
            return "Encoding error: \(error.localizedDescription)"
        case .serverError(let code):
            return "Server error with code: \(code)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response"
        case .timeout:
            return "Request timeout"
        case .unauthorized:
            return "Unauthorized access"
        case .forbidden:
            return "Forbidden access"
        case .notFound:
            return "Resource not found"
        case .tooManyRequests:
            return "Too many requests"
        case .internalServerError:
            return "Internal server error"
        case .badGateway:
            return "Bad gateway"
        case .serviceUnavailable:
            return "Service unavailable"
        case .gatewayTimeout:
            return "Gateway timeout"
        case .noInternetConnection:
            return "No internet connection"
        }
    }
}
