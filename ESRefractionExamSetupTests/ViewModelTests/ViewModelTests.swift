//
//  ViewModelTests.swift
//  ESRefractionExamSetupTests
//
//  Created by Elena Slovushch on 01/12/2022.
//

import XCTest
@testable import ESRefractionExamSetup

final class ViewModelTests: XCTestCase {
    
    var sut: ViewModel!
    var motionService: MotionService!
    var motionManager: MockMotionManager!
    var faceDetectionService: FaceDetectionService!
    var viewDelegate: MockViewModelDelegate!
    
    
    override func setUpWithError() throws {
        viewDelegate = MockViewModelDelegate()
        motionManager = MockMotionManager()
        motionService = MotionService(serviceProvider: motionManager)
        
        
    }

    override func tearDownWithError() throws {
        viewDelegate = nil
        motionManager = nil
        motionService = nil
        faceDetectionService = nil
        sut = nil
    }

    func testViewModel_WhenSetupInterruptedWithErorr_CallsCorrespondingMethodOnViewModelDelegate() {
        
        //Arrange
        let expectation = expectation(description: "Expecting didFinishDevicePositionSetup(with error:_) to be called")
        viewDelegate.expectation = expectation
        motionManager.error = MotionServiceError.deviceMotionIsUnavailable
        
        //Act
        sut = ViewModel(motionService: motionService, viewDelegate: viewDelegate)
        //sut.getDevicePosition()
        
        //Assert
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(viewDelegate.failureCounter, 1, "didFinishDevicePositionSetup(with error:_) method should be called once")
        XCTAssertEqual(viewDelegate.completionCounter, 0, "didCompleteDevicePositionSetup() method should not be called")
    }
    
    func testViewModel_WhenDevicePositionedFor3Seconds_CallsCorrespondingMethodOnViewModelDelegate() {
        
        //Arrange
        let expectation = expectation(description: "Expecting didCompleteDevicePositionSetup() method to be called")
        viewDelegate.expectation = expectation
        
        //Act
        sut = ViewModel(motionService: motionService, viewDelegate: viewDelegate)
        //sut.getDevicePosition()
        
        //Assert
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(viewDelegate.failureCounter, 0, "didFinishDevicePositionSetup(with error:_) method should not be called")
        XCTAssertEqual(viewDelegate.completionCounter, 1, "didCompleteDevicePositionSetup() method should be called once")
        
    }
    
    func testViewModel_WhenFaceDetectionCompletesWithSuccess_CallsCorrespondingMethodOnViewModelDelegate() {
        
        //Arrange
        let expectation = expectation(description: "Expecting didCompleteFaceDetection() to be called")
        viewDelegate.expectation = expectation
        let faceDetector = MockFaceDetector()
        faceDetector.result = .detectedFaces(number: 2)
        faceDetectionService = FaceDetectionService(faceDetector: faceDetector)
        sut = ViewModel(motionService: motionService, faceDetectionService: faceDetectionService, viewDelegate: viewDelegate)
        
        //Act
        //sut.detectFace()
        
        //Assert
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(viewDelegate.failureCounter, 0, "didFinishDevicePositionSetup(with error:_) method should not be called")
        XCTAssertEqual(viewDelegate.completionCounter, 1, "didCompleteDevicePositionSetup() method should be called once")
        
    }
    
    func testViewModel_WhenFaceDetectionFinishesWithError_CallsCorrespondingMethodOnViewModelDelegate() {
        
        //Arrange
        let expectation = expectation(description: "Expecting didFinishFaceDetection(with error:_) to be called")
        viewDelegate.expectation = expectation
        let faceDetector = MockFaceDetector()
        faceDetector.error = .detectionRequestFailed
        faceDetectionService = FaceDetectionService(faceDetector: faceDetector)
        sut = ViewModel(motionService: motionService, faceDetectionService: faceDetectionService, viewDelegate: viewDelegate)
        
        //Act
        sut.detectFace()
        
        //Assert
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(viewDelegate.failureCounter, 1, "didFinishDevicePositionSetup(with error:_) method should be called once")
        XCTAssertEqual(viewDelegate.completionCounter, 0, "didCompleteDevicePositionSetup() method should not be called")
        
    }
    
    
}
