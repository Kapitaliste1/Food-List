//
//  LikeFoodUseCase.swift
//  OpenFood
//
//  Created by Jonathan Ngabo on 2025-07-16.
//
import Foundation
import Combine

// Response wrapper for API calls
struct FoodLikeResponse: Codable {
    let success: Bool?
    
    var isLiked: Bool {
        return success ?? false
    }
}


protocol LikeFoodUseCaseProtocol {
    func execute(foodId: Int, isLiked: Bool) -> AnyPublisher<Bool, NetworkError>
}

class LikeFoodUseCase: LikeFoodUseCaseProtocol{
    
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func execute(foodId: Int, isLiked: Bool)  -> AnyPublisher<Bool, NetworkError> {
        let path: Path = .likeFood(id: foodId, isLiked: isLiked)
        let networkConfig = NetworkConfiguration(path: path)
        
      return networkManager.request(configuration: networkConfig, type: FoodLikeResponse.self)
            .map{ response in
                return response.isLiked
            }
            .eraseToAnyPublisher()
    }
}
