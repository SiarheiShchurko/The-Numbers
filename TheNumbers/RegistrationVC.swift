//
//  RegistrationVC.swift
//  TheNumbers
//
//  Created by Alinser Shchurko on 1.09.22.
//

import Foundation
import UIKit
import Firebase

final class RegistrationVC: UIViewController {
    
    //private var registrationVM: RegistrationProtocol = RegistrationVM()
    
    private var signUp: Bool = true {
        willSet { newValue ? registrationScreen() : loginInScreen() }
    }
    
    private var isSelected: Bool = false
    
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
        didSet { cornerRadius(registerButton)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkTextField()
    }
    
    //MARK: KeyboardHide
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    
    
    //MARK: Registration screen
    private func registrationScreen() {
        
        titleLabel.text = "Registration"
        signButton.setTitle("Sign In", for: .normal)
        registerButton.setTitle("REGISTR", for: .normal)
        registerButton.setTitle("REGISTR", for: .selected)
        enterName.isHidden = false
        UIView.animate(withDuration: 0.20, delay: 0.00, usingSpringWithDamping: 1.00, initialSpringVelocity: 1.0, options: .allowAnimatedContent) {
            self.stackView.frame.origin.y = self.enterName.frame.maxY + 20 }
    }
    
    //MARK: LogIn screen
    private func loginInScreen() {
        
        titleLabel.text = "Log In"
        signButton.setTitle("Register", for: .normal)
        registerButton.setTitle("ENTER", for: .normal)
        registerButton.setTitle("ENTER", for: .selected)
        enterName.isHidden = true
        UIView.animate(withDuration: 0.2, delay: 0.00, usingSpringWithDamping: 1.00, initialSpringVelocity: 1.0, options: .allowAnimatedContent) {
            self.view.translatesAutoresizingMaskIntoConstraints = true
            self.stackView.frame.origin.y = self.titleLabel.frame.maxY + 20 }
    }
    
    private func checkTextField() {
        if signUp {
        let isEmpty = (enterName.text?.isEmpty ?? true || enterEmail.text?.isEmpty ?? true || enterPassword.text?.isEmpty ?? true)
            registerButton.isSelected = isEmpty
            //registerButton.isEnabled = !isEmpty
            
            
        } else {
            let isEmpty = (enterEmail.text?.isEmpty ?? true || enterPassword.text?.isEmpty ?? true)
            registerButton.isSelected = isEmpty
               // registerButton.isEnabled = !isEmpty
        }
    }
    
    //MARK: registration func
    func registration(_ email: String?, _ pass: String?) {
        //Optional delete
        guard let email = email else { return }
        guard let pass = pass else { return }
        
        //Registration
        Auth.auth().createUser(withEmail: email, password: pass) { result, error in
            if error == nil {
                self.dismiss(animated: true)
            }
            guard let result = result else { return }
            print(result.user.uid)
            
        }
    }
    
    //MARK: SignIn func
    func signIn(_ email: String?, _ pass: String?) {
        //Optional delete
        guard let email = email else { return }
        guard let pass = pass else { return }
        
        //Enter
        Auth.auth().signIn(withEmail: email, password: pass) { result, error in
            if error == nil {
                self.dismiss(animated: true)
            }
           
        }
    }
    
    @IBAction private func textFieldActon(_ sender: UITextField) {
        
            switch sender {
            case enterName:
                enterName.text = sender.text
            case enterEmail:
                enterEmail.text = sender.text
            case enterPassword:
                enterPassword.text = sender.text
            default: break
            }
            
        checkTextField()
        print(enterName ?? "nil")
        }
    
  
    
    @IBAction private func SignInAction() {
        signUp = !signUp
        checkTextField()
    }
    
    //MARK:
    @IBAction private func registrationOrEnter() {
        
        let eMail = enterEmail.text
        let pass = enterPassword.text
        
        signUp ? registration(eMail, pass) : signIn(eMail, pass)
    }
}


extension RegistrationVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //FirstResponder
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
