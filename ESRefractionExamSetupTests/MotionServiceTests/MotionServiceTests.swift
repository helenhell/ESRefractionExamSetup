//
//  MotionServiceTests.swift
//  ESRefractionExamSetupTests
//
//  Created by Elena Slovushch on 30/11/2022.
//

import XCTest
import Combine
@testable import ESRefractionExamSetup

final class MotionServiceTests: XCTestCase {
    
    var sut: MockMotionService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        sut = MockMotionService()
        cancellables = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        cancellables = []
        sut = nil
    }

    func testMotionService_WhenDeviceMotionUnavailable_ReturnSpecificError() {
        // Arrange
        sut = MockMotionService(isDeviceMotionAvailable: false)
        
        //Act
        sut.positionPublisher
            // Assert
            .sink { completion in
                switch completion {
                case .failure(let error):
                    XCTAssertEqual(error, MotionServiceError.deviceMotionIsUnavailable, "When device motion is unavailable, MotionService's getDevicePosition() method should return MotionServiceError.deviceMotionIsUnavailable error")
                case .finished:
                    XCTFail("When device motion is unavailable should finish with error")
                }
            } receiveValue: { value in
                XCTFail("When device motion is unavailable should receive no value")
            }
            .store(in: &cancellables)
        sut.getDevicePosition()
    }

    func testMotionService_BeforeMotionUpdatesStarted_updateIntervalIsSetCheckIsPerformed() {
        // Arrange
        let expectation = expectation(description: "Expecting isMotionUpdateIntervalSet() method to be called")
        sut.motionIntervalSetExpectation = expectation
        
        // Act
        let _ = sut.getDevicePosition()
        wait(for: [expectation], timeout: 0.5)
        
        // Assert
        XCTAssertEqual(sut.motionIntervalSetCallCounter, 1, "isMotionUpdateIntervalSet() method is not called or called more than once")
        
    }
    
    func testMotionService_WhenUpdateIntervalCheckIsSetToSettingsValue_ReturnsTrue() {
        
        //Arrange
        sut = MockMotionService(motionUpdateInterval: MotionSettings.motionUpdateInterval)
        //Act
        let result = sut.isMotionUpdateIntervalSet()
        
        //Assert
        XCTAssertTrue(result.0, "When motion update interval is set to Settings value isMotionUpdateIntervalSet() method should return true")
        XCTAssertNil(result.1, "When motion update interval is set to Settings value isMotionUpdateIntervalSet() method should return error == nil")
    }
    
    func testMotionService_WhenUpdateIntervalCheckIsSetToIncorrectValue_ReturnsSpecificError() {
        
        //Arrange
        sut = MockMotionService(motionUpdateInterval: 5)
        //Act
        let result = sut.isMotionUpdateIntervalSet()
        
        //Assert
        XCTAssertEqual(result.1, MotionServiceError.incorrectUpdateInterval, "When motion update interval is set to incorrect value isMotionUpdateIntervalSet() method should return MotionServiceError.incorrectUpdateInterval error")
        XCTAssertFalse(result.0, "When motion update interval is set to incorrect value isMotionUpdateIntervalSet() method should return false")
        
    }
    
    func testMotionService_WhenMotionUpdateFails_ReturnsSpecificError() {
        
        //Arrange
        let motionManager = MockMotionManager()
        motionManager.error = MotionServiceError.motionUpdateFailed
        sut = MockMotionService(motionManager: motionManager)
        
        //Act
        sut.positionPublisher
            //Assert
            .sink { completion in
                switch completion {
                case .failure(let error):
                    XCTAssertEqual(error, MotionServiceError.motionUpdateFailed, "When motion update fails, MotionService's getDevicePosition() method should send completion with MotionServiceError.motionUpdateFailed error")
                case .finished:
                    XCTFail("When motion update fails MotionService's getDevicePosition() method should send completion with error")
                }
            } receiveValue: { value in
                XCTFail("When motion update fails MotionService's getDevicePosition() method should send no value")
            }
            .store(in: &cancellables)
        sut.getDevicePosition()
    }
    
    func testMotionService_WhenMotionUpdateSucceeds_ReturnsValuesAccordingToUpdateInterval() {
        
        //Arrange
        let motionManager = MockMotionManager()
        sut = MockMotionService(motionManager: motionManager)
        let expectation = expectation(description: "waiting for values")
        
        //Act
        var receivedValues: [Double] = []
        sut.positionPublisher
            .sink { completion in
                guard case .finished = completion else {
                    return
                }
                expectation.fulfill()
            } receiveValue: { value in
                receivedValues.append(value)
            }
            .store(in: &cancellables)
        
        sut.getDevicePosition()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+5) { [weak self] in
            self?.sut.positionPublisher.send(completion: .finished)
        }
        wait(for: [expectation], timeout: 5.1)
        
        //Assert
        XCTAssertGreaterThanOrEqual(receivedValues.count, 5, "should receive values")
    }
}