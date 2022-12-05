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
    
    private(set) var captureSession:AVCaptureSession!
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
    let resultPublisher: FaceDetectionSubject!
    
    init(captureSession: AVCaptureSession! = AVCaptureSession(), resultPublisher: FaceDetectionSubject! = FaceDetectionSubject()) {
        self.captureSession = captureSession
        self.resultPublisher = resultPublisher
    }
    
    func cameraFeedPreviewLayer() -> AVCaptureVideoPreviewLayer {
        return self.cameraFeedPreviewLayer(for: self.captureSession)
    }
    
    func performFaceDetection() {
        if let input = self.captureSession.inputs.last {
            self.captureSession.removeInput(input)
        }
        self.captureSession.addInput(self.cameraInput())
        self.captureSession.addOutput(self.cameraOutput())
        DispatchQueue.global().async {
            self.captureSession.startRunning()
        }
    }
    
    func stopFaceDetection() {
        self.captureSession.stopRunning()
    }
    
    private func cameraInput() -> AVCaptureDeviceInput {
        guard let device = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera, .builtInTrueDepthCamera],
            mediaType: .video,
            position: .front).devices.first else {
            self.resultPublisher.send(completion: .failure(.noCameraFound))
            fatalError("No back camera found")
        }
        let cameraInput = try! AVCaptureDeviceInput(device: device)
        return cameraInput
    }
    
    private func cameraFeedPreviewLayer(for captureSession: AVCaptureSession) -> AVCaptureVideoPreviewLayer {
        self.previewLayer.videoGravity = .resizeAspectFill
        return self.previewLayer
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
                    self.resultPublisher.send(completion: .failure(.detectionRequestFailed))
                    return
                }
                if let results = request.results as? [VNFaceObservation], results.count > 0 {
                    self.resultPublisher.send(.detectedFaces(number: results.count))
                } else {
                    self.resultPublisher.send(.noFaceDetected)
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
            self.resultPublisher.send(completion: .failure(.capturingOutputFailed))
            return
        }
        self.performDetectionRequest(in: frame)
    }
}
