//
//  ListFoodUseCase.swift
//  OpenFood
//
//  Created by Jonathan Ngabo on 2025-07-16.
//

import Foundation
import Combine

// Response wrapper for API calls
struct FoodListResponse: Codable {
    let foods: [Food]?
    let totalCount: Int?
 
    var foodList: [Food] {
        return foods ?? []
    }
    
    var count: Int {
        return totalCount ?? 0
    }
}


protocol ListFoodUseCaseProtocol {
    func execute(currentPage: Int) -> AnyPublisher<FoodListResponse, NetworkError>
}

class ListFoodUseCase: ListFoodUseCaseProtocol {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func execute(currentPage: Int) -> AnyPublisher<FoodListResponse, NetworkError> {
        let path: Path = .foodList(currentPage: currentPage)
        let networkConfiguration: NetworkConfiguration = .init(path: path)
        
        return networkManager.request(configuration: networkConfiguration, type: FoodListResponse.self)
            .eraseToAnyPublisher()
    }
}


