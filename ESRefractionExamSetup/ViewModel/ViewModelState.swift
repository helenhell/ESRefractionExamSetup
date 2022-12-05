//
//  ViewModelState.swift
//  ESRefractionExamSetup
//
//  Created by Elena Slovushch on 04/12/2022.
//

import Foundation

enum ViewModelState {
    
    case setupStart
    case positioningDevice
    case devicePositioned
    case detectingFace
    case faceDetected
    case checkingPosition
    case repositioningDevice
    case devicePositionedFaceDetected
    case setupComplete
    case errorOccured
    
    var next: ViewModelState {
        var next: ViewModelState!
        switch self {
        case .setupStart:
            next = .positioningDevice
        case .positioningDevice:
            next = .devicePositioned
        case .devicePositioned:
            next = .detectingFace
        case .detectingFace:
            return .faceDetected
        case .faceDetected:
            next = .checkingPosition
        case .checkingPosition:
            next = .repositioningDevice
        case .repositioningDevice:
            next = .devicePositionedFaceDetected
        case .devicePositionedFaceDetected:
            next = .setupComplete
        case .setupComplete:
            next = .setupComplete
        case .errorOccured:
            next = .setupStart
        }
        return next
    }
    
    
    var instructionText: String {
        switch self {
        case .setupStart:
            return SetupStrings.SETUP_START_INSTRUCTION.localized
        case .positioningDevice:
            return SetupStrings.POSITIONING_INSTRUCTION.localized
        case .devicePositioned:
            return SetupStrings.POSITION_COMPLETE_INSTRUCTION.localized
        case .detectingFace:
            return SetupStrings.FACE_DETECTION_INSTRUCTION.localized
        case .faceDetected:
            return SetupStrings.FACE_DETECTED_INSTRUCTION.localized
        case .checkingPosition:
            return SetupStrings.FACE_DETECTED_INSTRUCTION.localized
        case .repositioningDevice:
            return SetupStrings.POSITIONING_INSTRUCTION.localized
        case .devicePositionedFaceDetected:
            return SetupStrings.SETUP_COMPLETE_INSTRUCTION.localized
        case .setupComplete:
            return SetupStrings.SETUP_COMPLETE_INSTRUCTION.localized
        case .errorOccured:
            return SetupStrings.SETUP_START_INSTRUCTION.localized
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .setupStart:
            return SetupStrings.SETUP_START_BUTTON_TITLE.localized
        case .positioningDevice:
            return SetupStrings.POSITIONING_BUTTON_TITLE.localized
        case .devicePositioned:
            return SetupStrings.POSITION_COMPLETE_BUTTON_TITLE.localized
        case .detectingFace:
            return SetupStrings.FACE_DETECTION_BUTTON_TITLE.localized
        case .faceDetected:
            return SetupStrings.FACE_DETECTED_BUTTON_TITLE.localized
        case .checkingPosition:
            return SetupStrings.CHECKING_POSITION_BUTTON_TITLE.localized
        case .repositioningDevice:
            return SetupStrings.CHECKING_POSITION_BUTTON_TITLE.localized
        case .devicePositionedFaceDetected:
            return SetupStrings.SETUP_COMPLETE_BUTTON_TITLE.localized
        case .setupComplete:
            return SetupStrings.SETUP_COMPLETE_BUTTON_TITLE.localized
        case .errorOccured:
            return SetupStrings.SETUP_START_BUTTON_TITLE.localized
        }
    }
    
    var buttonEnabled: Bool {
        switch self {
        case .setupStart:
            return true
        case .positioningDevice:
            return false
        case .devicePositioned:
            return true
        case .detectingFace:
            return false
        case .faceDetected:
            return true
        case .checkingPosition:
            return false
        case.repositioningDevice:
            return false
        case .devicePositionedFaceDetected:
            return true
        case .setupComplete:
            return true
        case .errorOccured:
            return true
        }
    }
    
    var previewContainerHidden: Bool {
        switch self {
        case .devicePositioned, .detectingFace, .faceDetected, .checkingPosition:
            return false
        default:
            return true
        }
    }
   
}
