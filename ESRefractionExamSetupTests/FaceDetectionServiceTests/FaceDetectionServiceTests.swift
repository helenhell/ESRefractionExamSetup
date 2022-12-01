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

    override func setUpWithError() throws {
        subscriptions = []
    }

    override func tearDownWithError() throws {
        subscriptions = nil
    }
    
    func testFaceDetectionService_WhenFaceNotDetected_ReturnsFalse() throws {
        //Arrange
        let sut = FaceDetectionService()
        var error: FaceDetectionServiceError?
        let expectation = expectation(description: "Expecting face detection error")
        //Act
        sut.detectionPublisher
            .sink { completion in
                guard case .failure(let receivedError) = completion else {
                    return
                }
                error = receivedError
                expectation.fulfill()
            } receiveValue: { value in
                XCTFail("When FaceDetectionService's detectFace() method sends completion with error, no value shoud be received")
            }
            .store(in: &subscriptions)
        sut.detectFace()
        wait(for: [expectation], timeout: 2)
        //Assert
        let unwrappedError = try XCTUnwrap(error)
        XCTAssertEqual(unwrappedError, FaceDetectionServiceError.faceNotDetected, "When FaceDetectionService's detectFace() method sends completion with error, FaceDetectionServiceError.faceNotDetected should be received")
    }

}
