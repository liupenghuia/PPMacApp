//
//  File.swift
//  PPCameraCore
//
//  Created by liupenghui on 2025/11/12.
//

import SwiftUI
import AVFoundation

struct CameraPreviewView: NSViewRepresentable {
    
    // ✅ 1. 声明一个 Coordinator 类
    class Coordinator: NSObject,ObservableObject, AVCaptureFileOutputRecordingDelegate {
        var session: AVCaptureSession?
        var movieOutput: AVCaptureMovieFileOutput?
        
        // 开始录制
        func startRecording() {
            guard let output = movieOutput else { return }
            let fileURL = URL(fileURLWithPath: NSTemporaryDirectory() + "output.mov")
            output.startRecording(to: fileURL, recordingDelegate: self)
        }
        
        // 停止录制
        func stopRecording() {
            movieOutput?.stopRecording()
        }
        
        // ✅ 代理回调：录制完成后
        func fileOutput(_ output: AVCaptureFileOutput,
                        didFinishRecordingTo outputFileURL: URL,
                        from connections: [AVCaptureConnection],
                        error: Error?) {
            print("录制完成: \(outputFileURL.path)")
        }
    }
    
    // ✅ 2. SwiftUI 在创建 view 时会调用此方法
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    private let session = AVCaptureSession()
    private let videoLayer = AVCaptureVideoPreviewLayer()
    private let dataOutPut = AVCaptureVideoDataOutput()
    private let movieOutput = AVCaptureMovieFileOutput()
    private var context: Context? = nil
    public  var co: Coordinator? = nil
    
    init(co: Coordinator? ) {
        self.co = co
    }

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        setupSession(in: view, coordinator: context.coordinator)
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}

    private func setupSession(in view: NSView, coordinator: Coordinator) {
    
        // 配置 Session
        session.sessionPreset = .high
        
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input) else {
            print("无法添加摄像头输入")
            return
        }

        session.addInput(input)

        // 配置输出（可选）
        if session.canAddOutput(dataOutPut) {
            session.addOutput(dataOutPut)
        }
        // （可选）
        if session.canAddOutput(movieOutput) {
            session.addOutput(movieOutput)
        }

        // 配置预览图层
        videoLayer.session = session
        videoLayer.videoGravity = .resizeAspectFill
        videoLayer.frame = view.bounds
        videoLayer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]

        view.wantsLayer = true
        view.layer?.addSublayer(videoLayer)

        // 开始运行
        session.startRunning()
        
        self.co?.session = session
        self.co?.movieOutput = movieOutput
        
        print("")
    }
}
