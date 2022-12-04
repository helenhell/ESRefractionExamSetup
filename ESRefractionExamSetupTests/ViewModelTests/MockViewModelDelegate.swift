//
//  MockViewModelDelegate.swift
//  ESRefractionExamSetupTests
//
//  Created by Elena Slovushch on 03/12/2022.
//

import Foundation
import XCTest
@testable import ESRefractionExamSetup

class MockViewModelDelegate: ViewModelDelegateProtocol {
    
    var expectation: XCTestExpectation?
    var completionCounter = 0
    var failureCounter = 0
    
    func displayErrorALert(with message: String) {
        failureCounter += 1
        expectation?.fulfill()
    }
    
    func handleViewUpdate(with viewDetails: ESRefractionExamSetup.ViewDetails) {
        completionCounter += 1
        expectation?.fulfill()
    }
}
