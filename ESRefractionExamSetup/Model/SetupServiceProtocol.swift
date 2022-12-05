//
//  SetupService.swift
//  ESRefractionExamSetup
//
//  Created by Elena Slovushch on 05/12/2022.
//

import Foundation
import Combine

protocol SetupServiceProtocol {
    
    associatedtype T where T: SetupError
    associatedtype ReturnValue where ReturnValue: Any
    associatedtype ServiceProvider where ServiceProvider: Any
    
//    typealias SetupResultable = Any
//    typealias SetupServiceProvidable = Any
    
    var resultPublisher: PassthroughSubject<ReturnValue, T> { get set }
    var serviceProvider: ServiceProvider { get set}
    
    func performService()
    func stopPerforming()
    
}

//protocol SetupResultable {
//
//}
//
//protocol SetupServiceProvidable {
//
//}

