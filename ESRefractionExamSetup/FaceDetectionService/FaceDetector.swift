//
//  FaceDetector.swift
//  ESRefractionExamSetup
//
//  Created by Elena Slovushch on 01/12/2022.
//

import Foundation
import Vision
import AVFoundation
import Combine

class FaceDetector: NSObject, FaceDetectorProtocol {
    
    typealias FaceDetectorResult = (Bool, Int)
    
    private let captureSession:AVCaptureSession!
    let detectionResultPublisher: PassthroughSubject<FaceDetectorResult, FaceDetectionServiceError>
    
    private var subscriptions: Set<AnyCancellable> = []

    init(captureSession: AVCaptureSession! = AVCaptureSession(), resultPublisher: PassthroughSubject<FaceDetectorResult, FaceDetectionServiceError>! = PassthroughSubject<FaceDetectorResult, FaceDetectionServiceError>()) {
        self.captureSession = captureSession
        self.detectionResultPublisher = resultPublisher
        
    }
    
    deinit {
        subscriptions.forEach {
            $0.cancel()
        }
    }
    
    func cameraFeedPreviewLayer() -> AVCaptureVideoPreviewLayer {
        return self.cameraFeedPreviewLayer(for: self.captureSession)
    }
    
    func performFaceDetection () {
        self.captureSession.addInput(self.cameraInput())
        self.captureSession.addOutput(self.cameraOutput())
        self.detectionResultPublisher.sink { completion in
            print("FACE DETECTOR COMPLETION = \(completion)")
        } receiveValue: { value in
            print("FACE DETECTOR VALUE = \(value)")
        }
        .store(in: &subscriptions)
        self.captureSession.startRunning()
    }
    
    
    
    private func cameraInput() -> AVCaptureDeviceInput {
        guard let device = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera, .builtInTrueDepthCamera],
            mediaType: .video,
            position: .front).devices.first else {
               fatalError("No back camera device found, please make sure to run SimpleLaneDetection in an iOS device and not a simulator")
        }
        let cameraInput = try! AVCaptureDeviceInput(device: device)
        return cameraInput
    }
    
    private func cameraFeedPreviewLayer(for captureSession: AVCaptureSession) -> AVCaptureVideoPreviewLayer {
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        return previewLayer
    }
    
    private func cameraOutput() -> AVCaptureVideoDataOutput {
        let videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
        if let connection = videoDataOutput.connection(with: AVMediaType.video), connection.isVideoOrientationSupported {
            connection.videoOrientation = .portrait
        }
        return videoDataOutput
    }
    
    private func performDetectionRequest(in image: CVPixelBuffer) {
        
        let faceDetectionRequest = VNDetectFaceLandmarksRequest(completionHandler: { (request: VNRequest, error: Error?) in
            DispatchQueue.main.async {
                guard error == nil else {
                    self.detectionResultPublisher.send(completion: .failure(.detectionRequestFailed))
                    return
                }
                if let results = request.results as? [VNFaceObservation], results.count > 0 {
                    print("did detect \(results.count) face(s)")
                    self.detectionResultPublisher.send((true, results.count) )
                } else {
                    print("did not detect any face")
                    self.detectionResultPublisher.send((false, 0))
                }
            }
        })
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: image, orientation: .leftMirrored, options: [:])
        try? imageRequestHandler.perform([faceDetectionRequest])
    }
}


extension FaceDetector: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            self.detectionResultPublisher.send(completion: .failure(.capturingOutputFailed))
            return
        }
        self.performDetectionRequest(in: frame)
    }
}
