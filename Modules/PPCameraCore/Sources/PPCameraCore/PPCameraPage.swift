//
//  SwiftUIView.swift
//  PPCameraCore
//
//  Created by liupenghui on 2025/11/11.
//

import SwiftUI
import AVFoundation

public struct PPCameraPage: View {
    
    
    @State private var isRecording = false
    @StateObject private var coordinator = CameraPreviewView.Coordinator()
    
    
    public static func hello() {
        print("✅ PPCameraCore module loaded successfully!")
    }
    
    public init() {}
    
    
    public var body: some View {
        
        VStack(spacing: 20) {
            Text("摄像头预览").font(.headline)
            CameraPreviewView(co: coordinator)
                .frame(width: 400, height: 300)
                .cornerRadius(12)
                .shadow(radius: 4)
            
            Button(isRecording ? "停止录制" : "开始录制") {
                            if isRecording {
                                coordinator.stopRecording()
                            } else {
                                coordinator.startRecording()
                            }
                            isRecording.toggle()
                        }
                        .padding()
        }
        
    }
    
}
