//
//  FoodListView.swift
//  OpenFood
//
//  Created by Jonathan Ngabo on 2025-07-16.
//

import SwiftUI

struct FoodListView: View {
    @StateObject var viewModel: FoodListViewModel
    
    var body: some View {
        NavigationView {
            switch viewModel.state {
            case .loading:
                VStack(alignment: .center) {
                    Text("Loading...")
                    ProgressView()
                }
                
            case .loaded:
                VStack {
                    List(viewModel.foodList) { food in
                        NavigationLink(destination: FoodDetailsView(viewModel: .init(food: food, useCase: self.viewModel.produceLikeFoodUseCase()))) {
                            FoodRowView(food: food)
                                .onAppear {
                                    if food.id == viewModel.foodList.last?.id {
                                        Task {
                                            await viewModel.loadNextPage()
                                        }
                                    }
                                }
                                .frame(height: 100)
                        }
                    }
                    .navigationBarTitle("Food List")
                    
                    if self.viewModel.isLoadingMore {
                        ProgressView()
                    }
                }
                
                
            case .error(let error):
                if self.viewModel.foodList.isEmpty {
                    VStack {
                        if let networkError = error as? NetworkError {
                           Text(networkError.localizedDescription)
                        }
                        
                        ErrorView
                            .padding(20)
                    }
                }
                
            }
        }
        
    }
    
    
    var ErrorView: some View {
        VStack(alignment: .center) {

            Button {
                self.viewModel.loadFood()
            } label: {
                Text("Reload")
                    
            }
        }
    }
}

#Preview {
    let networkManager = NetworkManager(session: URLSession(configuration: .ephemeral))
    let useCase = ListFoodUseCase(networkManager: networkManager)
    
    FoodListView(viewModel: .init(useCase: useCase))
}
