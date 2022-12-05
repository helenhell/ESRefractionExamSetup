//
//  FaceDetectionServiceError.swift
//  ESRefractionExamSetup
//
//  Created by Elena Slovushch on 01/12/2022.
//

import Foundation

enum FaceDetectionServiceError: SetupError {
    
    case noCameraFound
    case detectionRequestFailed
    case capturingOutputFailed
    
    var message: String {
        switch self {
        case .noCameraFound:
            return SetupStrings.NO_CAMERA_FOUND.localized
        case .detectionRequestFailed:
            return SetupStrings.DETECTION_REQUEST_FAILED.localized
        case .capturingOutputFailed:
            return SetupStrings.CAPTURING_OUTPUT_FAILED.localized
        }
    }
}
