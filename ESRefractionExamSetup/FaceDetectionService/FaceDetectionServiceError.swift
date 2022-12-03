//
//  FaceDetectionServiceError.swift
//  ESRefractionExamSetup
//
//  Created by Elena Slovushch on 01/12/2022.
//

import Foundation

enum FaceDetectionServiceError: Error {
    
    case noCameraFound
    case detectionRequestFailed
    case capturingOutputFailed
}
