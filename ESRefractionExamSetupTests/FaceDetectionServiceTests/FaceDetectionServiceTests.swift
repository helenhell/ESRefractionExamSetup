//
//  FaceDetectionServiceTests.swift
//  ESRefractionExamSetupTests
//
//  Created by Elena Slovushch on 01/12/2022.
//

import XCTest
import Combine
@testable import ESRefractionExamSetup

final class FaceDetectionServiceTests: XCTestCase {
    
    var subscriptions: Set<AnyCancellable>!
    var sut: FaceDetectionService!
    var faceDetector: MockFaceDetector!
    
    override func setUpWithError() throws {
        subscriptions = []
        faceDetector = MockFaceDetector()
        sut = FaceDetectionService(serviceProvider: faceDetector)
    }

    override func tearDownWithError() throws {
        subscriptions = nil
        faceDetector = nil
        sut = nil
    }
    
    func testFaceDetectionService_WhenNoFaceWasDetected_ReturnsNoFaceDetected() throws {
        //Arrange
        faceDetector.result = .noFaceDetected
        let expectation = expectation(description: "Expecting face detection result")
        var result: FaceDetectionResult?
        
        //Act
        sut.resultPublisher
            .sink { completion in
                guard case .finished = completion else {
                    XCTFail("When FaceDetectionService's detectFace() method succeeded with 0 result, no error should be send")
                    return
                }
            } receiveValue: { value in
                result = value
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        sut.performService()
        
        wait(for: [expectation], timeout: 1)
        
        //Assert
        let unwrappedResult = try XCTUnwrap(result)
        XCTAssertEqual(unwrappedResult, FaceDetectionResult.noFaceDetected, "When FaceDetectionService's detectFace() method sends completion with error, FaceDetectionServiceError.faceNotDetected should be received")
    }
    
    
    func testFaceDetectionService_WhenFaceWasDetected_ReturnsNumberOfFacesDetected() {
        //Arrange
        faceDetector.result = .detectedFaces(number: 2)
        let expectation = expectation(description: "Expecting face detection result")
        var result: Int = 0
        
        //Act
        sut.resultPublisher
            .sink { completion in
                guard case .finished = completion else {
                    XCTFail("When FaceDetectionService's detectFace() method succeeded with 0 result, no error should be send")
                    return
                }
            } receiveValue: { value in
                switch value {
                case .detectedFaces(number: let number):
                    result = number
                default:
                    XCTFail("When FaceDetectionService's detectFace() method succeeded, should return number of faced detected")
                }
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        sut.performService()
        
        wait(for: [expectation], timeout: 1)
        
        //Assert
        XCTAssertGreaterThan(result, 0, "When FaceDetectionService's detectFace() method sends completion with error, FaceDetectionServiceError.faceNotDetected should be received")
    }
    
    func testFaceDetectionService_WhenDetectionRequestFailed_ReturnsSpecificError() throws {
        //Arrange
        faceDetector.error = .detectionRequestFailed
        let expectation = expectation(description: "Expecting face detection error")
        var error: FaceDetectionServiceError?
        
        //Act
        sut.resultPublisher
            .sink { completion in
                guard case .failure(let receivedError) = completion else {
                    XCTFail("When FaceDetectionService's detectFace() method faileds should send completion with error")
                    return
                }
                error = receivedError
                expectation.fulfill()
            } receiveValue: { value in
                XCTFail("When FaceDetectionService's detectFace() method failes, no value should be sent")
            }
            .store(in: &subscriptions)
        sut.performService()
        
        wait(for: [expectation], timeout: 1)
        
        //Assert
        let unwrappedError = try XCTUnwrap(error)
        XCTAssertEqual(unwrappedError, .detectionRequestFailed, "When FaceDetectionService's detectFace() method sends completion with error, FaceDetectionServiceError.detectionRequestFaiiled should be received")
    }
    

}
