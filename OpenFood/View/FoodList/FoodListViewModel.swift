//
//  FoodListViewModel.swift
//  OpenFood
//
//  Created by Jonathan Ngabo on 2025-07-16.
//
import Foundation
import Combine

enum FoodListViewModelState{
    case loading
    case loaded
    case error(Error)
}

@MainActor
class FoodListViewModel: ObservableObject{
    @Published var state : FoodListViewModelState
    @Published var foodList: [Food] = []
    
    
    private var useCase: ListFoodUseCaseProtocol
    private var currentPage: Int = 0
    private var totalCount: Int = 0
    @Published var isLoadingMore: Bool = false
    private var cancellables: Set<AnyCancellable> = []
    
    init(useCase: ListFoodUseCaseProtocol) {
        self.state = .loading
        self.useCase = useCase
        self.loadFood()
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    func loadFood(){
        Task {
            self.isLoadingMore = true
            self.useCase.execute(currentPage: currentPage)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.state = .error(error)
                    }
                } receiveValue: { foodListData in
                    self.totalCount = foodListData.count
                    self.foodList.append(contentsOf: foodListData.foodList)
                    self.state = .loaded
                    self.isLoadingMore = false
                }
                .store(in: &self.cancellables)
            
        }
    }
    
    func loadNextPage() async {
        if self.foodList.count < self.totalCount {
            switch state {
            case .loaded:
                currentPage += 1
                self.isLoadingMore = true
                loadFood()
            default:
                break
            }
        }
    }
    
    func produceLikeFoodUseCase() -> LikeFoodUseCaseProtocol {
        let networkManager = NetworkManager(session: URLSession.shared)
        return LikeFoodUseCase(networkManager: networkManager)
    }
}
