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

class MockMotionService: MotionServiceBase {
    
    typealias T = MotionServiceError
    
    var motionIntervalSetExpectation: XCTestExpectation?
    var motionIntervalSetCallCounter = 0
    
    override init(motionManager: CMMotionManager! = CMMotionManager(), positionPublisher: PassthroughSubject<Double, MotionServiceBase.T>! = PassthroughSubject<Double,T>(), isDeviceMotionAvailable: Bool = true, motionUpdateInterval: Double = MotionSettings.motionUpdateInterval) {
        super.init(motionManager: motionManager, motionUpdateInterval: motionUpdateInterval)
    }
    
    override func isMotionUpdateIntervalSet() -> (Bool, T?) {
        self.motionIntervalSetCallCounter += 1
        self.motionIntervalSetExpectation?.fulfill()
        
        return super.isMotionUpdateIntervalSet()
    }
    
}
