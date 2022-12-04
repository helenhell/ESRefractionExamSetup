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
    
    func updateView(labelText: String, buttonTitle: String, buttonEnabled: Bool) {
        self.instructionLabel.text = labelText
        self.setupButton.setTitle(buttonTitle, for: .normal)
        self.setupButton.isEnabled = buttonEnabled
    }
}

extension ViewController: ViewModelDelegateProtocol {
    
    func didCompleteDevicePositionSetup() {
        print("DEVICE SET UP")
    }
    
    func didFinishDevicePositionSetup(with error: MotionServiceError) {
        print(error)
    }
    
    func didCompleteFaceDetection() {
        print("FACE DETECTED")
    }
    
    func didFinishFaceDetection(with error: FaceDetectionServiceError) {
        print(error)
    }
    
    func handleViewUpdate(labelText: String, buttonTitle: String, buttonEnabled: Bool) {
        self.updateView(labelText: labelText, buttonTitle: buttonTitle, buttonEnabled: buttonEnabled)
    }
}
