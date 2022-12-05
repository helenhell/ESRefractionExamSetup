//
//  MotionService.swift
//  ESRefractionExamSetup
//
//  Created by Elena Slovushch on 30/11/2022.
//

import Foundation
import CoreMotion
import Combine

class MotionService: MotionServiceProtocol {
    
    var isDeviceMotionAvailable: Bool
    var resultPublisher: PassthroughSubject<Double, MotionServiceError>
    var serviceProvider: CMMotionManager
    
    init(isDeviceMotionAvailable: Bool = true, resultPublisher: PassthroughSubject<Double, MotionServiceError> = PassthroughSubject<Double, MotionServiceError>(), serviceProvider: CMMotionManager = CMMotionManager(), motionUpdateInterval: Double = MotionSettings.motionUpdateInterval) {
        self.resultPublisher = resultPublisher
        self.serviceProvider = serviceProvider
        self.serviceProvider.deviceMotionUpdateInterval = motionUpdateInterval
        self.isDeviceMotionAvailable = self.serviceProvider.isDeviceMotionAvailable
        
    }
}
