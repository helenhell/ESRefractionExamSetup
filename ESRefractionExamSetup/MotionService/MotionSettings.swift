//
//  MotionSettings.swift
//  ESRefractionExamSetup
//
//  Created by Elena Slovushch on 30/11/2022.
//

import Foundation

struct MotionSettings {
    
    static let motionUpdateInterval: Double = 1
    static let stablePositionUpdatesCount: Int = 3
    static let requiredAngleRange: ClosedRange<Double> = (70...90)
}
