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
        return "Face Detection Service Error"
    }
}
