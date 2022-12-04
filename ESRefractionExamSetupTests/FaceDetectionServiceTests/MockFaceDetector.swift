//
//  MockFaceDetector.swift
//  ESRefractionExamSetupTests
//
//  Created by Elena Slovushch on 01/12/2022.
//

import Foundation
import AVFoundation
import Combine
@testable import ESRefractionExamSetup

class MockFaceDetector: NSObject, FaceDetectorProtocol {
    
    var captureSession: AVCaptureSession!
    var resultPublisher: FaceDetectionSubject!
    
    var error: FaceDetectionServiceError?
    var result: FaceDetectionResult?
    
    init(captureSession: AVCaptureSession! = AVCaptureSession(), resultPublisher: FaceDetectionSubject! = FaceDetectionSubject()) {
        self.captureSession = captureSession
        self.resultPublisher = resultPublisher
    }
    
    func performFaceDetection() {
       
        if let error = self.error {
            self.resultPublisher.send(completion: .failure(error))
        }
        
        if let result = self.result {
            self.resultPublisher.send(result)
        }
    }
    
    func stopFaceDetection() {
        //
    }
}
