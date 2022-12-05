//
//  ViewModel.swift
//  ESRefractionExamSetup
//
//  Created by Elena Slovushch on 01/12/2022.
//

import Foundation
import Combine

class ViewModel {
    
    private var motionService: any MotionServiceProtocol
    var faceDetectionService: FaceDetectionService
    private var subscriptions: Set<AnyCancellable> = []
    
    private var delegate: ViewModelDelegateProtocol?
    
    var state: ViewModelState = .setupStart {
        didSet {
            self.updateView(for: self.state)
        }
    }
    private var angleUpdates: [Double] = []
    
    init(motionService: any MotionServiceProtocol = MotionService(), faceDetectionService: FaceDetectionService = FaceDetectionService(), viewDelegate: ViewModelDelegateProtocol) {
        
        self.delegate = viewDelegate
        self.motionService = motionService
        self.faceDetectionService = faceDetectionService
        
        self.updateView(for: self.state)
        
        self.motionService.resultPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print(completion)
                if case .failure(let error) = completion {
                    self.handleError(error)
                }
            } receiveValue: { value in
                if self.isDevicePositionStable(with: value) {
                    self.state = self.state == .checkingPosition ? .devicePositionedFaceDetected : self.state.next
                    self.motionService.stopPerforming()
                    self.angleUpdates = []
                } else if self.state == .checkingPosition && !MotionSettings.requiredAngleRange.contains(value){
                    self.state = .repositioningDevice
                }
            }
            .store(in: &subscriptions)
        
        self.faceDetectionService.resultPublisher
            .sink { completion in
                if case .failure(let error) = completion {
                    self.handleError(error)
                }
            } receiveValue: { result in
                print(result)
                switch result {
                case .detectedFaces(number: _):
                    // TODO: Handle use case when more than one case detected
                    self.state = self.state == .detectingFace ? self.state.next : self.state
                    self.faceDetectionService.stopPerforming()
                case .noFaceDetected:
                    break
                }
            }
            .store(in: &subscriptions)
    }
    
    deinit {
        self.subscriptions.forEach {
            $0.cancel()
        }
    }
    
    func handleButtonTap() {
        guard self.state.buttonEnabled else {
            return
        }
        if self.state == .setupStart {
            self.state = self.state.next
            self.getDevicePosition()
        } else if self.state == .devicePositioned {
            self.state = self.state.next
            self.delegate?.displayCameraView(with: self.faceDetectionService.serviceProvider.cameraFeedPreviewLayer())
            self.detectFace()
        } else if self.state == .faceDetected {
            self.state = self.state.next
            self.getDevicePosition()
        } else if self.state == .devicePositionedFaceDetected || self.state == .setupComplete {
            self.state = .setupStart
        }
    }
    
    private func getDevicePosition() {
        self.motionService.performService()
    }
    
    private func detectFace() {
        self.faceDetectionService.performService()
        
    }
    
    private func handleError(_ error: SetupError) {
        self.state = .errorOccured
        self.delegate?.displayErrorALert(with: error.message)
    }
    
    private func updateView(for state: ViewModelState) {
        let viewDetais = ViewDetails(inctructionTest: state.instructionText, buttonTitle: state.buttonTitle, buttonEnabled: state.buttonEnabled, previewContainerIsHidden: state.previewContainerHidden)
        self.delegate?.handleViewUpdate(with: viewDetais)
    }
    
    private func isDevicePositionStable(with angle: Double) -> Bool {
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



