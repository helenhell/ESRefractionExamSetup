//
//  ViewModel.swift
//  ESRefractionExamSetup
//
//  Created by Elena Slovushch on 01/12/2022.
//

import Foundation
import Combine

class ViewModel {
    
    var motionService: MotionServiceBase!
    var faceDetectionService: FaceDetectionService!
    var subscriptions: Set<AnyCancellable> = []
    
    var delegate: ViewModelDelegateProtocol?
    var state: ViewModelState = .setupStart
    
    init(motionService: MotionServiceBase! = MotionService(), faceDetectionService: FaceDetectionService! = FaceDetectionService(faceDetector: FaceDetector()), viewDelegate: ViewModelDelegateProtocol) {
        self.delegate = viewDelegate
        self.motionService = motionService
        self.motionService.positionPublisher
            .sink { completion in
                print(completion)
                if case .failure(let error) = completion {
                    self.delegate?.didFinishDevicePositionSetup(with: error)
                }
            } receiveValue: { value in
                print(value)
                self.delegate?.didCompleteDevicePositionSetup()
                self.state = .devicePositioned
            }
            .store(in: &subscriptions)
        
        self.faceDetectionService = faceDetectionService
        self.faceDetectionService.detectionPublisher
            .sink { completion in
                if case .failure(let error) = completion {
                    self.delegate?.didFinishFaceDetection(with: error)
                }
            } receiveValue: { result in
                print(result)
                self.delegate?.didCompleteFaceDetection()
                self.state = .faceDetected
            }
            .store(in: &subscriptions)

    }
    
    deinit {
        self.subscriptions.forEach {
            $0.cancel()
        }
    }
    
    func getDevicePosition() {
        self.motionService.getDevicePosition()
    }
    
    func detectFace() {
        self.faceDetectionService.detectFace()
    }
    
}


enum ViewModelState {
    
    
    case setupStart
    case devicePositioned
    case faceDetected
}
