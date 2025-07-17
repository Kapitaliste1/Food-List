//
//  FoodDetailsView.swift
//  OpenFood
//
//  Created by Jonathan Ngabo on 2025-07-17.
//

import SwiftUI
import Combine

struct FoodDetailsView: View {
    @ObservedObject var viewModel: FoodDetailsViewModel
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    if let url = self.viewModel.food.url {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .failure:
                                Image(systemName: "photo")
                                    .font(.largeTitle)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                            default:
                                ProgressView()
                            }
                        }
                        
                    }
                    
                    VStack(alignment: .center) {
                        Text(self.viewModel.food.foodName)
                            .font(.title)
                        
                        HStack {
                            Text(self.viewModel.food.countryName)
                                .font(.title3)
                            
                            Spacer()
                            
                            Button {
                                self.viewModel.evaluateFood()
                            } label: {
                                if self.viewModel.food.isLiked ?? false {
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.red)
                                }else {
                                    Image(systemName: "heart")
                                        .foregroundColor(.red)
                                }
                            }
                            
                        }
                        .padding([.top, .bottom], 5)
                        
                       
                        
                        Text(self.viewModel.food.foodDescription)
                            .font(.system(size: 13))
                            .lineLimit(nil)
                            .lineSpacing(5)
                        
                        HStack {
                            Text("Last Updated: ")
                            Text(self.viewModel.food.lastUpdated)
                        }
                        .padding(10)
                        
                    }
                }
                .padding(10)
            }
            
            if let errorMessage = viewModel.errorMessage {
                ToastView(message: errorMessage, isShowing: $viewModel.showErrorToastMessage)
            }
        }
    }
    
 
    
}

#Preview {
    let food = Food(id: 1, name: "Test", isLiked: true, photoURL: "https://opentable-dex-ios-test-d645a49e3287.herokuapp.com/images/pasta.jpeg", foodDetails: "Test", countryOfOrigin: "USA", lastUpdatedDate: "12/12/12")
    let networkManager: NetworkManager = .init(session: URLSession(configuration: .ephemeral))
    let useCase: LikeFoodUseCase = .init(networkManager: networkManager)
    FoodDetailsView(viewModel: .init(food: food, useCase: useCase))
}
