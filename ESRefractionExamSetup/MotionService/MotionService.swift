//
//  MotionService.swift
//  ESRefractionExamSetup
//
//  Created by Elena Slovushch on 30/11/2022.
//

import Foundation
import CoreMotion
import Combine

protocol MotionServiceDelegate: AnyObject {
    
    func didFinishWithError(_ error: MotionServiceError)
    func didRecieve(value: Double)
}


class MotionService: MotionServiceBase {
    
    weak var delegate: MotionServiceDelegate?
    
    override init(motionManager: CMMotionManager! = CMMotionManager(), positionPublisher: PassthroughSubject<Double, MotionServiceBase.T>! = PassthroughSubject<Double,T>(), isDeviceMotionAvailable: Bool = true, motionUpdateInterval: Double = MotionSettings.motionUpdateInterval) {
        super.init()
        self.isDeviceMotionAvailable = self.motionManager.isDeviceMotionAvailable
    }
    
    
}
