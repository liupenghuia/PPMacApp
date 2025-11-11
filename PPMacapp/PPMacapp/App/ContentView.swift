//
//  ContentView.swift
//  PPMacapp
//
//  Created by liupenghui on 2025/11/11.
//

import SwiftUI
import AppKit
import PPCameraCore
import PPUIComponetCore

struct ContentView: View {
    @State private var goToDetail: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {
        NavigationStack {
            VStack {
                
                NavigationButton(destination: PPUIComponentView()) {
                    Text("Go to UIComponent")
                }
                
                NavigationButton(destination: PPCameraPage()) {
                    Text("Go to CorePage")
                }
                
                Button("测试module") {
                    print("按钮被点击了！")
                    PPCameraPage.hello()
                }
                
                
                
            }
            .padding()
            .frame(width: 300, height: 200)
            .navigationTitle("Home")
        }
    }
}
