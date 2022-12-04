//
//  ViewModelDelegateProtocol.swift
//  ESRefractionExamSetup
//
//  Created by Elena Slovushch on 03/12/2022.
//

import Foundation

protocol ViewModelDelegateProtocol {
    
    func displayErrorALert(with message: String)
    func handleViewUpdate(with viewDetails: ViewDetails)
    
}
