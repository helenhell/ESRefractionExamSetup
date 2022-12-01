//
//  ViewModel.swift
//  ESRefractionExamSetup
//
//  Created by Elena Slovushch on 01/12/2022.
//

import Foundation
import Combine

class ViewModel {
    
    var motionService: MotionServiceBase!
    var subscriptions: Set<AnyCancellable> = []
    
    init() {
        self.motionService = MotionService()
        self.motionService.positionPublisher
            .sink { completion in
                print(completion)
            } receiveValue: { value in
                print(value)
            }
            .store(in: &subscriptions)
        //self.motionService.getDevicePosition()

    }
    
    deinit {
        self.subscriptions.forEach {
            $0.cancel()
        }
    }
    
}
