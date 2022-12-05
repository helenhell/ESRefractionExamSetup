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
    @IBOutlet weak var previewContainer: UIView!
    
    var viewModel: ViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = ViewModel(viewDelegate: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupView()
    }
    
    @IBAction func setupButtonTapped(_ sender: UIButton) {
        self.viewModel.handleButtonTap()
    }
    
    func setupView() {
        self.previewContainer.layer.cornerRadius =  self.previewContainer.bounds.width/2
        self.previewContainer.layer.borderWidth = 15
        self.previewContainer.layer.borderColor =  UIColor(red: 32/255, green: 43/255, blue: 115/255, alpha: 1).cgColor
    }
    
    func updateView(with viewDetails: ViewDetails) {
        UIView.animate(withDuration: 0.5) {
            self.instructionLabel.text = viewDetails.inctructionTest
            self.setupButton.setTitle(viewDetails.buttonTitle, for: .normal)
            self.setupButton.isEnabled = viewDetails.buttonEnabled
            self.previewContainer.isHidden = viewDetails.previewContainerIsHidden
        }
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
    
    func displayCameraView(with layer: AVCaptureVideoPreviewLayer) {
        DispatchQueue.main.async {
            layer.frame = self.previewContainer.bounds
            self.previewContainer.layer.addSublayer(layer)
        }
    }
    
   
}
