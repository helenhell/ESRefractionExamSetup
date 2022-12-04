//
//  ViewModelDelegateProtocol.swift
//  ESRefractionExamSetup
//
//  Created by Elena Slovushch on 03/12/2022.
//

import Foundation

protocol ViewModelDelegateProtocol {
    
    func didCompleteDevicePositionSetup()
    func didFinishDevicePositionSetup(with error: MotionServiceError)
    func didCompleteFaceDetection()
    func didFinishFaceDetection(with error: FaceDetectionServiceError)
    func handleViewUpdate(labelText: String, buttonTitle: String, buttonEnabled: Bool)
    
}
