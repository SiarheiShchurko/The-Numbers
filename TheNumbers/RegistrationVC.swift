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
        willSet { newValue ? registrationScreen() : loginInScreen() }
    }
    
    @IBOutlet private weak var stackView: UIStackView!
    
    @IBOutlet private weak var titleLabel: UITextField!
    
    @IBOutlet private weak var enterName: UITextField!{
        didSet { enterName.delegate = self }
    }
        
    @IBOutlet private weak var enterEmail: UITextField! {
        didSet { enterEmail.backgroundColor = .white
                 enterEmail.delegate = self }
    }
    
    @IBOutlet private weak var enterPassword: UITextField! {
        didSet { enterPassword.backgroundColor = .white
                 enterPassword.delegate = self }
    }
    
    @IBOutlet private weak var signButton: UIButton!
    
    @IBOutlet private weak var registerButton: UIButton! {
        didSet { cornerRadius(registerButton) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: KeyboardHide
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    @IBAction private func SignInAction() {
        signUp = !signUp
    }
    
    //MARK: Registration screen
    private func registrationScreen() {
        
        titleLabel.text = "Registration"
        signButton.setTitle("Sign In", for: .normal)
        registerButton.setTitle("REGISTR", for: .normal)
        enterName.isHidden = false
        UIView.animate(withDuration: 0.20, delay: 0.00, usingSpringWithDamping: 1.00, initialSpringVelocity: 1.0, options: .allowAnimatedContent) {
            self.stackView.frame.origin.y = self.enterName.frame.maxY + 20 }
    }
    
    //MARK: LogIn screen
    private func loginInScreen() {
        
        titleLabel.text = "Log In"
        signButton.setTitle("Register", for: .normal)
        registerButton.setTitle("ENTER", for: .normal)
        enterName.isHidden = true
        UIView.animate(withDuration: 0.2, delay: 0.00, usingSpringWithDamping: 1.00, initialSpringVelocity: 1.0, options: .allowAnimatedContent) {
            self.view.translatesAutoresizingMaskIntoConstraints = true
            self.stackView.frame.origin.y = self.titleLabel.frame.maxY + 20 }
    }
}

extension RegistrationVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if enterName == textField {
            enterEmail.becomeFirstResponder()
        } else if enterEmail == textField {
            enterPassword.becomeFirstResponder()
        } else {
            enterPassword.resignFirstResponder()
        }
        return true
    }
    
    
}
