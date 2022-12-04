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
    var state: ViewModelState = .setupStart {
        didSet {
            self.updateView()
        }
    }
    
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
                // TODO: check range
                self.delegate?.didCompleteDevicePositionSetup()
                self.state = self.state.next
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
                self.state = self.state.next
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
    
    func updateView() {
        
    }
    
}


enum ViewModelState {
    
    case setupStart
    case positioningDevice
    case devicePositionedDetectingFace
    case faceDetectedCheckingPosition
    case devicePositionedFaceDetected
    case setupComplete
    case errorOccured
    
    var next: ViewModelState {
        switch self {
        case .setupStart:
            return .positioningDevice
        case .positioningDevice:
            return .devicePositionedDetectingFace
        case .devicePositionedDetectingFace:
            return .faceDetectedCheckingPosition
        case .faceDetectedCheckingPosition:
            return .devicePositionedFaceDetected
        case .devicePositionedFaceDetected:
            return .setupComplete
        case .setupComplete:
            return .setupComplete
        case .errorOccured:
            return .setupStart
        }
    }
    
    
}
