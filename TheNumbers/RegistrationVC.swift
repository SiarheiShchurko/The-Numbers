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
            } else {
                titleLabel.text = "Enter"
                enterName.isHidden = true
            }
    }
    }
    
    @IBOutlet private weak var titleLabel: UITextField!
    
    @IBOutlet private weak var enterName: UITextField!
        
    
    @IBOutlet private weak var enterEmail: UITextField! {
        didSet { enterEmail.backgroundColor = .white
        }
    }
    
    @IBOutlet private weak var enterPassword: UITextField! {
        didSet { enterPassword.backgroundColor = .white
        }
    }
    
    @IBOutlet private weak var signButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    @IBAction private func SignInAction() {
        signUp = !signUp
        
    }
    
    
}
