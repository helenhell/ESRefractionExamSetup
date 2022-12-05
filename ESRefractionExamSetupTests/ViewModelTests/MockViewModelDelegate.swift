//
//  MockViewModelDelegate.swift
//  ESRefractionExamSetupTests
//
//  Created by Elena Slovushch on 03/12/2022.
//

import Foundation
import AVFoundation
import XCTest
@testable import ESRefractionExamSetup

class MockViewModelDelegate: ViewModelDelegateProtocol {
    
    
    var errorExpectation: XCTestExpectation?
    var valueExpectation: XCTestExpectation?
    var completionCounter = 0
    var failureCounter = 0
    
    func displayErrorALert(with message: String) {
        failureCounter += 1
        errorExpectation?.fulfill()
    }
    
    func handleViewUpdate(with viewDetails: ESRefractionExamSetup.ViewDetails) {
        completionCounter += 1
        valueExpectation?.fulfill()
    }
    
    func displayCameraView(with layer: AVCaptureVideoPreviewLayer) {
        //
    }
}
