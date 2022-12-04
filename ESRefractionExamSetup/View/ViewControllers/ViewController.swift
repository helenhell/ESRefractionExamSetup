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
        self.present(AlertService.create(with: ""), animated: true)
        self.viewModel.handleButtonTap()
    }
    
    func updateView(with viewDetails: ViewDetails) {
        self.instructionLabel.text = viewDetails.inctructionTest
        self.setupButton.setTitle(viewDetails.buttonTitle, for: .normal)
        self.setupButton.isEnabled = viewDetails.buttonEnabled
        self.setupButton.draw(self.setupButton.frame)
        self.instructionLabel.draw(self.instructionLabel.frame)
    }
}

extension ViewController: ViewModelDelegateProtocol {
    
    func displayErrorALert(with message: String) {
        //
    }
    
    func handleViewUpdate(with viewDetails: ViewDetails) {
        DispatchQueue.main.async {
            self.updateView(with: viewDetails)
        }
    }
   
}
