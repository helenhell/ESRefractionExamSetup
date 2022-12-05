//
//  FaceDetectionService.swift
//  ESRefractionExamSetup
//
//  Created by Elena Slovushch on 01/12/2022.
//

import Foundation
import Combine

typealias FaceDetectionSubject = PassthroughSubject<FaceDetectionResult, FaceDetectionServiceError>

class FaceDetectionService: SetupServiceProtocol {
    
    typealias T = FaceDetectionServiceError
    typealias ServiceProvider = FaceDetectorProtocol
    typealias ReturnValue = FaceDetectionResult
    
    var resultPublisher: FaceDetectionSubject
    var serviceProvider: FaceDetectorProtocol
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init(resultPublisher: FaceDetectionSubject = FaceDetectionSubject(), serviceProvider: FaceDetectorProtocol = FaceDetector()) {
        self.resultPublisher = resultPublisher
        self.serviceProvider = serviceProvider
        
    }
    
    deinit {
        self.subscriptions.forEach {
            $0.cancel()
        }
    }
    
    func performService() {
        
        self.serviceProvider.resultPublisher.sink { completion in
            switch completion {
            case .failure(let error):
                self.resultPublisher.send(completion: .failure(error))
            case .finished:
                self.resultPublisher.send(completion: .finished)
            }
        } receiveValue: { result in
            self.resultPublisher.send(result)
        }
        .store(in: &subscriptions)

        self.serviceProvider.performFaceDetection()
    }
    
    
    func stopPerforming() {
        self.serviceProvider.stopFaceDetection()
    }
    
}


