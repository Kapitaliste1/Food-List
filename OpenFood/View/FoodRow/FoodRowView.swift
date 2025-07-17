//
//  FoodRowView.swift
//  OpenFood
//
//  Created by Jonathan Ngabo on 2025-07-16.
//

import SwiftUI
import Combine

struct FoodRowView: View {
    var food: Food
    
    var body: some View {
        GeometryReader { geometry in
            LazyHStack(alignment: .top, spacing: 12) {
                if let url = self.food.url {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .failure:
                            Image(systemName: "photo")
                                .font(.largeTitle)
                        case .success(let image):
                            image
                                .resizable()
                        default:
                            ProgressView()
                        }
                    }
                    .frame(width: 120, height: 90)
                    .clipShape(.rect(cornerRadius: 25))
                }
                
                VStack(alignment: .leading) {
                    
                    Text(self.food.foodName)
                        .font(.system(size: 15))
                        .frame(maxWidth: (geometry.size.width * 0.4))
                        .lineLimit(3)
                    
                    Text(self.food.countryName)
                        .font(.system(size: 11))
                    
                }
            }
             .padding(.top, 8)
        }
    }
}

#Preview {
    let food = Food(id: 1, name: "Test", isLiked: true, photoURL: "https://opentable-dex-ios-test-d645a49e3287.herokuapp.com/images/pasta.jpeg", foodDetails: "Test", countryOfOrigin: "USA", lastUpdatedDate: "12/12/12")
    FoodRowView(food: food)
}
