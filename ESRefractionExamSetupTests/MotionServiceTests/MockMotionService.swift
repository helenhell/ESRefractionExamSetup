//
//  MockMotionService.swift
//  ESRefractionExamSetupTests
//
//  Created by Elena Slovushch on 30/11/2022.
//

import Foundation
import CoreMotion
import Combine
import XCTest
@testable import ESRefractionExamSetup

//class MockMotionService: MotionServiceProtocol {
//
//    typealias T = MotionServiceError
//
//    var motionIntervalSetExpectation: XCTestExpectation?
//    var motionIntervalSetCallCounter = 0
//
//    init(isDeviceMotionAvailable: Bool, resultPublisher: PassthroughSubject<Double, MotionServiceError>, serviceProvider: CMMotionManager, motionUpdateInterval: Double = MotionSettings.motionUpdateInterval) {
//        self.isDeviceMotionAvailable = isDeviceMotionAvailable
//        self.resultPublisher = resultPublisher
//        self.serviceProvider = serviceProvider
//        self.serviceProvider.deviceMotionUpdateInterval = motionUpdateInterval
//    }
//
//    override func isMotionUpdateIntervalSet() -> (Bool, T?) {
//        self.motionIntervalSetCallCounter += 1
//        self.motionIntervalSetExpectation?.fulfill()
//        
//        return super.isMotionUpdateIntervalSet()
//    }
//
//
//}
