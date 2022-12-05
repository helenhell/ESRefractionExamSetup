//
//  ViewController.swift
//  ESRefractionExamSetup
//
//  Created by Elena Slovushch on 29/11/2022.
//

import UIKit
import CoreMotion
import Vision
import AVFoundation
import Combine

class ViewController: UIViewController {
    
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var setupButton: UIButton!
    
    var viewModel: ViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      
        self.viewModel = ViewModel(viewDelegate: self)
    }
    
    
    @IBAction func setupButtonTapped(_ sender: UIButton) {
        self.viewModel.handleButtonTap()
    }
    
    func updateView(with viewDetails: ViewDetails) {
        self.instructionLabel.text = viewDetails.inctructionTest
        self.setupButton.setTitle(viewDetails.buttonTitle, for: .normal)
        self.setupButton.isEnabled = viewDetails.buttonEnabled
    }
}

extension ViewController: ViewModelDelegateProtocol {
    
    func displayErrorALert(with message: String) {
        DispatchQueue.main.async {
            let alert = AlertService.create(with: message)
            self.present(alert, animated: true)
        }
    }
    
    func handleViewUpdate(with viewDetails: ViewDetails) {
        DispatchQueue.main.async {
            self.updateView(with: viewDetails)
        }
    }
   
}
