//
//  OpenFoodApp.swift
//  OpenFood
//
//  Created by Jonathan Ngabo on 2025-07-16.
//

import SwiftUI


@main
struct OpenFoodApp: App {
    
    @StateObject var toastConfig: ToastConfiguration = .init(message: "" , isShowing: false)

    var body: some Scene {
        WindowGroup {
            let netwokManager: NetworkManager = .init(session: .shared)
            let useCase: ListFoodUseCase = .init(networkManager: netwokManager)
            ZStack {
                FoodListView(viewModel: .init(useCase: useCase))
                    .environmentObject(toastConfig)
                    
                
                if toastConfig.isShowing {
                    ToastView(message: toastConfig.message, isShowing: $toastConfig.isShowing)
                }
            }
        }
    }
}
