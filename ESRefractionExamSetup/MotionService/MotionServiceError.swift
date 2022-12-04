//
//  MotionServiceError.swift
//  ESRefractionExamSetup
//
//  Created by Elena Slovushch on 30/11/2022.
//

import Foundation

protocol SetupError: Error {
    
    var message: String { get }
}

enum MotionServiceError: SetupError {
    
    case deviceMotionIsUnavailable
    case incorrectUpdateInterval
    case motionUpdateFailed
    case generalError
    
    var message: String {
        return "Motion Service Error"
    }
    
}
