//
//  FoodDetailsViewModel.swift
//  OpenFood
//
//  Created by Jonathan Ngabo on 2025-07-17.
//
import Foundation
import Combine


@MainActor
class FoodDetailsViewModel: ObservableObject {
    @Published var food: Food
    private var useCase: LikeFoodUseCaseProtocol
    @Published var errorMessage: String?
    @Published var showErrorToastMessage: Bool = false
    private var cancellables: Set<AnyCancellable> = []
    
    init(food: Food, useCase: LikeFoodUseCaseProtocol) {
        self.food = food
        self.useCase = useCase
        self.showErrorToastMessage = false
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    func evaluateFood() {
        Task {
            guard let foodId = food.id, let like = food.isLiked else { return }
            
            self.useCase.execute(foodId: foodId, isLiked: !like )
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        self.errorMessage = nil
                        self.showErrorToastMessage = false
                        
                    case .failure(_):
                        self.errorMessage = "An error occured, the operation could not be completed"
                        self.showErrorToastMessage = true
                    }
                    
                } receiveValue: { isLiked in
                    self.food.isLiked  = isLiked
                }
                .store(in: &cancellables)
        }
    }
    
}
