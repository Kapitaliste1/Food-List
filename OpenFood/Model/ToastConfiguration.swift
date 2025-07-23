//
//  ToastConfiguration.swift
//  OpenFood
//
//  Created by Jonathan Ngabo on 2025-07-23.
//

import Foundation
import Combine

class ToastConfiguration: ObservableObject {
    @Published var message: String
    @Published var isShowing: Bool
    
    init(message: String, isShowing: Bool) {
        self.message = message
        self.isShowing = isShowing
    }
    
    func updateMessage(toast: ToastConfiguration) {
        self.message = toast.message
        self.isShowing = toast.isShowing
    }
}
