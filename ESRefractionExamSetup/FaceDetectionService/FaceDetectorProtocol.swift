//
//  FaceDetectorProtocol.swift
//  ESRefractionExamSetup
//
//  Created by Elena Slovushch on 01/12/2022.
//

import Foundation
import AVFoundation
import Combine

typealias FaceDetectionSubject = PassthroughSubject<FaceDetectionResult, FaceDetectionServiceError>

protocol FaceDetectorProtocol: NSObject {
    var captureSession: AVCaptureSession! { get }
    var resultPublisher: FaceDetectionSubject! { get }
    func performFaceDetection()
}
