//
//  FaceDetectionService.swift
//  ESRefractionExamSetup
//
//  Created by Elena Slovushch on 01/12/2022.
//

import Foundation
import Combine

class FaceDetectionService {
    
    var detectionPublisher: PassthroughSubject<Bool, FaceDetectionServiceError>!
    var faceDetector: FaceDetectorProtocol!
    
    init(detectionPublisher: PassthroughSubject<Bool, FaceDetectionServiceError>! = PassthroughSubject<Bool, FaceDetectionServiceError>(), faceDetector: FaceDetectorProtocol! = FaceDetector()) {
        self.detectionPublisher = detectionPublisher
        self.faceDetector = faceDetector
    }
    
    
    func detectFace() {
        self.faceDetector.performFaceDetection()
        self.detectionPublisher.send(completion: .failure(.faceNotDetected))
//
//        let detected = self.faceDetector.performFaceDetection()
//        guard detected else {
//            self.detectionPublisher.send(completion: .failure(.faceNotDetected))
//            return
//        }
//        self.detectionPublisher.send(detected)
    }
    
}


