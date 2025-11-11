//
//  NavigationButton.swift
//  PPMacapp
//
//  Created by liupenghui on 2025/11/11.
//

import SwiftUI

/// 可复用导航按钮组件
struct NavigationButton<Destination: View, Label: View>: View {
    let destination: Destination
    let action: (() -> Void)?
    let label: () -> Label
    
    @State private var isActive = false
    
    init(destination: Destination, action: (() -> Void)? = nil, @ViewBuilder label: @escaping () -> Label) {
        self.destination = destination
        self.action = action
        self.label = label
    }
    
    var body: some View {
        NavigationStack {
            Button(action: {
                isActive = true
                action?()
            }) {
                label()
            }
            .navigationDestination(isPresented: $isActive) {
                destination
            }
        }
    }
}
