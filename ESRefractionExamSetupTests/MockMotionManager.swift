//
//  MockMotionManager.swift
//  ESRefractionExamSetupTests
//
//  Created by Elena Slovushch on 30/11/2022.
//

import Foundation
import CoreMotion
@testable import ESRefractionExamSetup

class MockMotionManager: CMMotionManager {
    
    var error: Error?
    
    override func startDeviceMotionUpdates(to queue: OperationQueue, withHandler handler: @escaping CMDeviceMotionHandler) {
        
        if let error = self.error {
            handler(MockMotion(), error)
        } else {
            handler(MockMotion(), nil)
        }
    }
}

class MockMotion: CMDeviceMotion {
    
    override var attitude: CMAttitude {
        return MockAttitude()
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class MockAttitude: CMAttitude {
    
    override var pitch: Double {
        return 0.0
    }
}
