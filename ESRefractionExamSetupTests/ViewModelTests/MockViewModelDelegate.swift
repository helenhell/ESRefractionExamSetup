//
//  MockViewModelDelegate.swift
//  ESRefractionExamSetupTests
//
//  Created by Elena Slovushch on 03/12/2022.
//

import Foundation
import XCTest
@testable import ESRefractionExamSetup

class MockViewModelDelegate: ViewModelDelegateProtocol {
    
    var positionExpectation: XCTestExpectation?
    var faceDetectionExpectation: XCTestExpectation?
    var completionCounter = 0
    var failureCounter = 0
    var motionUpdatesCounter = 0
    
    func didCompleteDevicePositionSetup() {
        if motionUpdatesCounter == MotionSettings.stablePositionUpdatesCount {
            completionCounter += 1
            positionExpectation?.fulfill()
        }
    }
    
    func didFinishDevicePositionSetup(with error: ESRefractionExamSetup.MotionServiceError) {
        failureCounter += 1
        positionExpectation?.fulfill()
    }
    
    func didCompleteFaceDetection() {
        completionCounter += 1
        faceDetectionExpectation?.fulfill()
    }
    
    func didFinishFaceDetection(with error: FaceDetectionServiceError) {
        failureCounter += 1
        faceDetectionExpectation?.fulfill()
    }
}
