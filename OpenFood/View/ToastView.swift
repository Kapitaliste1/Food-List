//
//  ToastView.swift
//  OpenFood
//
//  Created by Jonathan Ngabo on 2025-07-17.
//

import Foundation
import SwiftUI

struct ToastView: View {
    let message: String
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack {
            Spacer()
            
            if isShowing {
                Text(message)
                    .font(.body)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.bottom, 50)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isShowing)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                isShowing = false
            }
        }
    }
}
