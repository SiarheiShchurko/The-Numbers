//
//  RegistrationVC.swift
//  TheNumbers
//
//  Created by Alinser Shchurko on 1.09.22.
//

import Foundation
import UIKit

final class RegistrationVC: UIViewController {
    
    
    
    var signUp: Bool = true {
        willSet {
            if newValue == true {
                titleLabel.text = "Registration"
                enterName.isHidden = false
                UIView.animate(withDuration: 0.20, delay: 1.00, usingSpringWithDamping: 1.00, initialSpringVelocity: 1.0, options: .allowAnimatedContent) {
                    self.stackView.frame.origin.y = self.enterName.frame.maxY + 20 }
            } else {
                titleLabel.text = "Enter"
                enterName.isHidden = true
                UIView.animate(withDuration: 0.20, delay: 1.00, usingSpringWithDamping: 1.00, initialSpringVelocity: 1.0, options: .allowAnimatedContent) {
                    self.view.translatesAutoresizingMaskIntoConstraints = true
                    self.stackView.frame.origin.y = self.titleLabel.frame.maxY + 20 }
            }
    }
    }
    
    @IBOutlet private weak var stackView: UIStackView!
    
    @IBOutlet private weak var titleLabel: UITextField!
    
    @IBOutlet private weak var enterName: UITextField!
        
    @IBOutlet private weak var enterEmail: UITextField! {
        didSet { enterEmail.backgroundColor = .white }
    }
    
    @IBOutlet private weak var enterPassword: UITextField! {
        didSet { enterPassword.backgroundColor = .white }
    }
    
    @IBOutlet private weak var signButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton! {
        didSet { cornerRadius(registerButton) }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        }

    
    
    @IBAction private func SignInAction() {
        signUp = !signUp
    }
    
}
