//
//  MotionServiceError.swift
//  ESRefractionExamSetup
//
//  Created by Elena Slovushch on 30/11/2022.
//

import Foundation

enum MotionServiceError: Error {
    
    case deviceMotionIsUnavailable
    case incorrectUpdateInterval
    case motionUpdateFailed
    case generalError
}
