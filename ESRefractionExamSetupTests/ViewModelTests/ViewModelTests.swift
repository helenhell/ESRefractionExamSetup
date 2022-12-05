//
//  ViewModelTests.swift
//  ESRefractionExamSetupTests
//
//  Created by Elena Slovushch on 01/12/2022.
//

import XCTest
@testable import ESRefractionExamSetup

final class ViewModelTests: XCTestCase {
    
    var sut: MockViewModel!
    var motionManager: MockMotionManager!
    var faceDetector: MockFaceDetector!
    var viewDelegate: MockViewModelDelegate!
    
    
    override func setUpWithError() throws {
        viewDelegate = MockViewModelDelegate()
        motionManager = MockMotionManager()
        faceDetector = MockFaceDetector()
        let motionService = MotionService(serviceProvider: motionManager)
        let faceDetectionService = FaceDetectionService(serviceProvider: faceDetector)
        sut = MockViewModel(motionService: motionService, faceDetectionService: faceDetectionService, viewDelegate: viewDelegate)
    }

    override func tearDownWithError() throws {
        viewDelegate = nil
        motionManager = nil
        faceDetector = nil
        sut = nil
    }

    //func testViewModel_WhenSetupInterruptedWithErorr_CallsErrorHandlerOnViewModelDelegate() {}
    
    //func testViewModel_WhenServiceReceivedValue_CallsViewUpdateOnViewModelDelegate() {}
    
    //func testViewModel_WhenMotionServiceIsPerforming_DevicePositionIsSetAccordingToMotionSettings {}
    
    
}
