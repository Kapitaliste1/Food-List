//
//  OpenFoodApp.swift
//  OpenFood
//
//  Created by Jonathan Ngabo on 2025-07-16.
//

import SwiftUI

@main
struct OpenFoodApp: App {

    var body: some Scene {
        WindowGroup {
            let netwokManager: NetworkManager = .init(session: .shared)
            let useCase: ListFoodUseCase = .init(networkManager: netwokManager)
            FoodListView(viewModel: .init(useCase: useCase))
        }
    }
}
