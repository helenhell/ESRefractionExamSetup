//
//  ViewController.swift
//  ESRefractionExamSetup
//
//  Created by Elena Slovushch on 29/11/2022.
//

import UIKit
import CoreMotion
import Vision
import AVFoundation
import Combine

class ViewController: UIViewController {
    
    var motionManager: CMMotionManager?
    
    private let captureSession = AVCaptureSession()
    private lazy var previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
    private let videoDataOutput = AVCaptureVideoDataOutput()
    
    var positionObserver = PassthroughSubject<Double, Never>()
    
    var cancellables: [AnyCancellable] = []
    
    var viewModel: ViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.setupPosition()
//        self.addCameraInput()
//        self.showCameraFeed()
//        self.getCameraFrames()
//        DispatchQueue.global().async {
//            self.captureSession.startRunning()
//        }
        
        positionObserver.filter { value in
            (70.0...90.0).contains(value)
        }
        .sink { value in
            print("ANGLE IS WITHIN LIMITS, ANGLE = \(value)")
        }
        .store(in: &cancellables)
        
        self.viewModel = ViewModel(viewDelegate: self)
        self.viewModel.getDevicePosition()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.previewLayer.frame = self.view.frame
    }
    
    deinit {
        self.cancellables.forEach { value in
            value.cancel()
        }
    }
    
//    func setupPosition() {
//
//        self.motionManager = CMMotionManager()
//
//        if motionManager?.isDeviceMotionAvailable == true {
//
//            motionManager?.deviceMotionUpdateInterval = 1
//
//            let queue = OperationQueue()
//            motionManager?.startDeviceMotionUpdates(to: queue, withHandler: { [weak self] motion, error in
//
//                // Get the attitude of the device
//                if let attitude = motion?.attitude {
//                    // Get the pitch (in radians) and convert to degrees.
//                    //print(attitude.pitch * 180.0/Double.pi)
//                    let degrees = attitude.pitch * 180.0/Double.pi
//                    self?.positionObserver.send(degrees)
//                    DispatchQueue.main.async {
//                        // Update some UI
//                    }
//                }
//
//            })
//
//            print("Device motion started")
//        }else {
//            print("Device motion unavailable")
//        }
//    }
    
    
    private func addCameraInput() {
        guard let device = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera, .builtInTrueDepthCamera],
            mediaType: .video,
            position: .front).devices.first else {
               fatalError("No back camera device found, please make sure to run SimpleLaneDetection in an iOS device and not a simulator")
        }
        let cameraInput = try! AVCaptureDeviceInput(device: device)
        self.captureSession.addInput(cameraInput)
    }
    
    private func showCameraFeed() {
        self.previewLayer.videoGravity = .resizeAspectFill
        self.previewLayer.frame = self.view.frame
        self.view.layer.addSublayer(self.previewLayer)
        
    }
    
    private func getCameraFrames() {
        self.videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
        self.videoDataOutput.alwaysDiscardsLateVideoFrames = true
        self.videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
        self.captureSession.addOutput(self.videoDataOutput)
        guard let connection = self.videoDataOutput.connection(with: AVMediaType.video),
            connection.isVideoOrientationSupported else { return }
        connection.videoOrientation = .portrait
    }
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            debugPrint("unable to get image from sample buffer")
            return
        }
        self.detectFace(in: frame)
    }
    
    private func detectFace(in image: CVPixelBuffer) {
        let faceDetectionRequest = VNDetectFaceLandmarksRequest(completionHandler: { (request: VNRequest, error: Error?) in
            DispatchQueue.main.async {
                if let results = request.results as? [VNFaceObservation], results.count > 0 {
                    print("did detect \(results.count) face(s)")
                } else {
                    print("did not detect any face")
                }
            }
        })
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: image, orientation: .leftMirrored, options: [:])
        try? imageRequestHandler.perform([faceDetectionRequest])
    }

}

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    
}

extension ViewController: ViewModelDelegateProtocol {
    
    func didCompleteDevicePositionSetup() {
        print("DEVICE SET UP")
        if self.viewModel.state == .devicePositioned {
            self.viewModel.detectFace()
        }
    }
    
    func didFinishDevicePositionSetup(with error: MotionServiceError) {
        print(error)
    }
    
    func didCompleteFaceDetection() {
        print("FACE DETECTED")
    }
    
    func didFinishFaceDetection(with error: FaceDetectionServiceError) {
        print(error)
    }
    
    
}
