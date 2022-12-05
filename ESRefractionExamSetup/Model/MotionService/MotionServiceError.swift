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
    
    
    var message: String {
        switch self {
        case .deviceMotionIsUnavailable:
            return SetupStrings.DEVICE_MOTION_UNAVAILABLE.localized
        case .incorrectUpdateInterval:
            return SetupStrings.INCORRECT_UPDATE_INTERVAL.localized
        case .motionUpdateFailed:
            return SetupStrings.MOTION_UPDATE_FAILED.localized
        }
    }
    
}
