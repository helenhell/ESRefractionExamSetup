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
            self.updateView(for: self.state)
        }
    }
    var angleUpdates: [Double] = []
    
    init(motionService: MotionServiceBase! = MotionService(), faceDetectionService: FaceDetectionService! = FaceDetectionService(faceDetector: FaceDetector()), viewDelegate: ViewModelDelegateProtocol) {
        
        self.delegate = viewDelegate
        self.updateView(for: self.state)
        self.motionService = motionService
        self.motionService.positionPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print(completion)
                if case .failure(let error) = completion {
                    self.delegate?.didFinishDevicePositionSetup(with: error)
                }
            } receiveValue: { value in
                print("**********POSITION RECEIVED = \(value)")
                // TODO: check range
                if self.isDevicePositionStable(with: value) {
                    self.state = self.state.next
                    self.motionService.stopMotionUpdates()
                    self.angleUpdates = []
//                    if self.state == .devicePositioned {
//                        self.detectFace()
//                    }
                    self.delegate?.didCompleteDevicePositionSetup()
                }
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
                self.motionService.startMotionUpdates()
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
        self.state = self.state.next
        self.motionService.getDevicePosition()
    }
    
    func detectFace() {
        self.faceDetectionService.detectFace()
    }
    
    func updateView(for state: ViewModelState) {
        print("STATE = \(self.state), ISTRUCTION = \(state.instructionText), BUTTON = \(state.buttonTitle), BUTTON ENABLED = \(state.buttonEnabled)")
        self.delegate?.handleViewUpdate(labelText: state.instructionText, buttonTitle: state.buttonTitle, buttonEnabled: state.buttonEnabled)
    }
    
    func handleButtonTap() {
        if self.state == .setupStart {
            self.getDevicePosition()
        } else if self.state == .devicePositioned {
            self.detectFace()
        }
    }
    
    func isDevicePositionStable(with angle: Double) -> Bool {
        
        self.angleUpdates.append(angle)
        let lastUpdates = self.angleUpdates.suffix(MotionSettings.stablePositionUpdatesCount)
        guard lastUpdates.count == MotionSettings.stablePositionUpdatesCount else {
            return false
        }
        var stablePositionCounter = 0
        lastUpdates.forEach {
            if MotionSettings.requiredAngleRange.contains($0) {
                stablePositionCounter += 1
            }
        }
        return stablePositionCounter == MotionSettings.stablePositionUpdatesCount
    }
    
}



