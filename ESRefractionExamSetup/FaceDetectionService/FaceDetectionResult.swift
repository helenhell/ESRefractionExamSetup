//
//  FaceDetectionResult.swift
//  ESRefractionExamSetup
//
//  Created by Elena Slovushch on 03/12/2022.
//

import Foundation


enum FaceDetectionResult: Equatable {
    
    case noFaceDetected
    case detectedFaces(number: Int)
    
}
