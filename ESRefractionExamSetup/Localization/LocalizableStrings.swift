//
//  LocalizableStrings.swift
//  ESRefractionExamSetup
//
//  Created by Elena Slovushch on 04/12/2022.
//

import Foundation

enum SetupStrings: String {
    
    case SETUP_START_INSTRUCTION
    case SETUP_START_BUTTON_TITLE
    case POSITIONING_INSTRUCTION
    case POSITIONING_BUTTON_TITLE
    case POSITION_COMPLETE_INSTRUCTION
    case POSITION_COMPLETE_BUTTON_TITLE
    case FACE_DETECTION_INSTRUCTION
    case FACE_DETECTION_BUTTON_TITLE
    case FACE_DETECTED_INSTRUCTION
    case FACE_DETECTED_BUTTON_TITLE
    case CHECKING_POSITION_BUTTON_TITLE
    case SETUP_COMPLETE_INSTRUCTION
    case SETUP_COMPLETE_BUTTON_TITLE
    
    var localized: String {
        return NSLocalizedString(rawValue, comment: "\(self.rawValue)")
    }
}
