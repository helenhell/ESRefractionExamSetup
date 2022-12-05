//
//  AlertService.swift
//  ESRefractionExamSetup
//
//  Created by Elena Slovushch on 04/12/2022.
//

import Foundation
import UIKit

struct AlertService {
    
    static func create(with message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: SetupStrings.ALERT_TITLE.localized, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        return alert
    }
}
