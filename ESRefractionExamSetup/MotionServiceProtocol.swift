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
    
    
    func getDevicePosition() -> AnyPublisher<Double, T>
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
        self.positionPublisher.subscribe(AngleSubscriber())
        self.isDeviceMotionAvailable = isDeviceMotionAvailable
        self.motionManager.deviceMotionUpdateInterval = motionUpdateInterval
    }
    
    func getDevicePosition() -> AnyPublisher<Double, T> {
        guard self.isDeviceMotionAvailable else {
            self.positionPublisher.send(completion: .failure(.deviceMotionIsUnavailable))
            return self.positionPublisher.eraseToAnyPublisher()
        }
        
        guard self.isMotionUpdateIntervalSet().0 else {
            self.positionPublisher.send(completion: .failure(.incorrectUpdateInterval))
            return self.positionPublisher.eraseToAnyPublisher()
        }
        
        let queue = OperationQueue()
        self.motionManager.startDeviceMotionUpdates(to: queue) { motion, error in
            
            guard error == nil, let attitude = motion?.attitude else {
                self.positionPublisher.send(completion: .failure(.motionUpdateFailed))
                return
            }
            
            let degrees = self.convertToDegrees(pitch: attitude.pitch)
            self.positionPublisher.send(degrees)
            //self.positionPublisher.send(completion: .finished)
        }
        return self.positionPublisher.eraseToAnyPublisher()
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


class AngleSubscriber: Subscriber {
    
    typealias Input = Double
    typealias Failure = MotionServiceError
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(_ input: Double) -> Subscribers.Demand {
        return .unlimited
    }
    
    func receive(completion: Subscribers.Completion<MotionServiceError>) {
        //
    }
     
}
