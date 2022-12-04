//
//  FaceDetectionService.swift
//  ESRefractionExamSetup
//
//  Created by Elena Slovushch on 01/12/2022.
//

import Foundation
import Combine

class FaceDetectionService {
    
    var detectionPublisher: FaceDetectionSubject!
    private(set) var faceDetector: FaceDetectorProtocol!
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init(detectionPublisher: FaceDetectionSubject = FaceDetectionSubject(), faceDetector: FaceDetectorProtocol!) {
        self.detectionPublisher = detectionPublisher
        self.faceDetector = faceDetector
        
    }
    
    deinit {
        self.subscriptions.forEach {
            $0.cancel()
        }
    }
    
    func detectFace() {
        self.faceDetector.resultPublisher.sink { completion in
            switch completion {
            case .failure(let error):
                self.detectionPublisher.send(completion: .failure(error))
            case .finished:
                self.detectionPublisher.send(completion: .finished)
            }
        } receiveValue: { result in
            self.detectionPublisher.send(result)
        }
        .store(in: &subscriptions)

        self.faceDetector.performFaceDetection()
    }
    
    func stopFaceDetection() {
        self.faceDetector.stopFaceDetection()
    }
    
}


