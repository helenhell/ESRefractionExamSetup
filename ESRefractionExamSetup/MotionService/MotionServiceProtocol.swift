//
//  MotionServiceProtocol.swift
//  ESRefractionExamSetup
//
//  Created by Elena Slovushch on 30/11/2022.
//

import Foundation
import CoreMotion
import Combine

protocol MotionServiceProtocol<T> where T: Error {
    
    associatedtype T
    
    var motionManager: CMMotionManager! { get }
    var positionPublisher: PassthroughSubject<Double, T>! { get }
    var isDeviceMotionAvailable: Bool { get }
    
    
    func getDevicePosition()
    func isMotionUpdateIntervalSet() -> (Bool, T?)
    func convertToDegrees(pitch: Double) -> Double
}



class MotionServiceBase: MotionServiceProtocol {
    
    typealias T = MotionServiceError
    
    private(set) var motionManager: CMMotionManager!
    private(set) var positionPublisher: PassthroughSubject<Double, T>!
    internal var isDeviceMotionAvailable: Bool
    
    
    
    init(motionManager: CMMotionManager! = CMMotionManager(), positionPublisher: PassthroughSubject<Double, T>! = PassthroughSubject<Double,T>(), isDeviceMotionAvailable: Bool = true, motionUpdateInterval: Double = MotionSettings.motionUpdateInterval) {
        self.motionManager = motionManager
        self.positionPublisher = positionPublisher
        self.isDeviceMotionAvailable = isDeviceMotionAvailable
        self.motionManager.deviceMotionUpdateInterval = motionUpdateInterval
    }
    
    func getDevicePosition() {
        guard self.isDeviceMotionAvailable else {
            self.positionPublisher.send(completion: .failure(.deviceMotionIsUnavailable))
            return
        }
        
        guard self.isMotionUpdateIntervalSet().0 else {
            self.positionPublisher.send(completion: .failure(.incorrectUpdateInterval))
            return
        }
        
        let queue = OperationQueue()
        self.motionManager.startDeviceMotionUpdates(to: queue) { [weak self] motion, error in
            
            guard let _self = self, error == nil, let attitude = motion?.attitude else {
                self?.positionPublisher.send(completion: .failure(.motionUpdateFailed))
                return
            }
            
            let degrees = _self.convertToDegrees(pitch: attitude.pitch)
            _self.positionPublisher.send(degrees)
            print("**********POSITION = \(degrees)")
        }
    }
    
    func isMotionUpdateIntervalSet() -> (Bool, T?) {
        guard self.motionManager.deviceMotionUpdateInterval == MotionSettings.motionUpdateInterval else {
            return (false, MotionServiceError.incorrectUpdateInterval)
        }
        return (true, nil)
    }
    
    func convertToDegrees(pitch: Double) -> Double {
        return pitch * 180.0/Double.pi
    }
}


//class AngleSubscriber: Subscriber {
//
//    typealias Input = Double
//    typealias Failure = MotionServiceError
//
//    func receive(subscription: Subscription) {
//        subscription.request(.unlimited)
//    }
//
//    func receive(_ input: Double) -> Subscribers.Demand {
//        return .unlimited
//    }
//
//    func receive(completion: Subscribers.Completion<MotionServiceError>) {
//        //
//    }
//
//}
