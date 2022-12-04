//
//  MotionServiceError.swift
//  ESRefractionExamSetup
//
//  Created by Elena Slovushch on 30/11/2022.
//

import Foundation

protocol SetupError: Error {
    
}

enum MotionServiceError: SetupError {
    
    
    case deviceMotionIsUnavailable
    case incorrectUpdateInterval
    case motionUpdateFailed
    case generalError
}
