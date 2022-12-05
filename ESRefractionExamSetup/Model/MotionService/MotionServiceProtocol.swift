//
//  MotionServiceProtocol.swift
//  ESRefractionExamSetup
//
//  Created by Elena Slovushch on 30/11/2022.
//

import Foundation
import CoreMotion
import Combine

protocol MotionServiceProtocol: SetupServiceProtocol where T == MotionServiceError, ServiceProvider == CMMotionManager, ReturnValue == Double  {
    
    var isDeviceMotionAvailable: Bool { get set }
    
    func isMotionUpdateIntervalSet() -> (Bool, T?)
    func convertToDegrees(pitch: Double) -> Double
}



extension MotionServiceProtocol {
    
    
    func performService() {
        guard self.isDeviceMotionAvailable else {
            self.resultPublisher.send(completion: .failure(MotionServiceError.deviceMotionIsUnavailable))
            return
        }
        
        guard self.isMotionUpdateIntervalSet().0 else {
            self.resultPublisher.send(completion: .failure(.incorrectUpdateInterval))
            return
        }
        
        self.startMotionUpdates()
    }
    
    func isMotionUpdateIntervalSet() -> (Bool, T?) {
        guard self.serviceProvider.deviceMotionUpdateInterval == MotionSettings.motionUpdateInterval else {
            return (false, MotionServiceError.incorrectUpdateInterval)
        }
        return (true, nil)
    }
    
    func convertToDegrees(pitch: Double) -> Double {
        return pitch * 180.0/Double.pi
    }
    
    func stopPerforming() {
        self.serviceProvider.stopDeviceMotionUpdates()
    }
    
    func startMotionUpdates() {
        let queue = OperationQueue()
        self.serviceProvider.startDeviceMotionUpdates(to: queue) { motion, error in
            
            guard error == nil, let attitude = motion?.attitude else {
                self.resultPublisher.send(completion: .failure(.motionUpdateFailed))
                return
            }
            
            let degrees = self.convertToDegrees(pitch: attitude.pitch)
            self.resultPublisher.send(degrees)
            print("**********POSITION SENT = \(degrees)")
        }
    }
}
