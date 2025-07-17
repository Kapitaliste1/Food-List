//
//  MockNetworkManager.swift
//  OpenFood
//
//  Created by Jonathan Ngabo on 2025-07-17.
//
import XCTest
import Combine
@testable import OpenFood


// MARK: - Mock Network Manager

class MockNetworkManager: NetworkManagerProtocol {
    var mockResult: Result<Any, NetworkError>?
    var capturedConfiguration: NetworkConfiguration?
    var capturedType: Any.Type?
    
    func request<T: Decodable>(configuration: NetworkConfiguration, type: T.Type) -> AnyPublisher<T, NetworkError> {
        capturedConfiguration = configuration
        capturedType = type
        
        guard let result = mockResult else {
            return Fail(error: NetworkError.noData).eraseToAnyPublisher()
        }
        
        switch result {
        case .success(let response):
            if let typedResponse = response as? T {
                return Just(typedResponse)
                    .setFailureType(to: NetworkError.self)
                    .eraseToAnyPublisher()
            } else {
                return Fail(error: NetworkError.decodingError(NSError(domain: "TestError", code: 0)))
                    .eraseToAnyPublisher()
            }
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}

