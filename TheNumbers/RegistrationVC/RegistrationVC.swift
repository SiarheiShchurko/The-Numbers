//
//  RegistrationVC.swift
//  TheNumbers
//
//  Created by Alinser Shchurko on 1.09.22.
//

import Foundation
import UIKit
//import Firebase

//MARK: Delegate protocol
protocol UserLabelDelegate: AnyObject {
    
    func getInf(_ inf: User)
    
}

final class RegistrationVC: UIViewController {
    
    private var registrationVM: RegistrationVMProtocol = RegistrationVM()
    
    weak var delegate: UserLabelDelegate?
    
    //MARK: Registr or sign?
    private var signUp: Bool = true {
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
        registerButton.setTitle("REGISTR", for: .disabled)
        enterName.isHidden = false
        UIView.animate(withDuration: 0.20, delay: 0.00, usingSpringWithDamping: 1.00, initialSpringVelocity: 1.0, options: .allowAnimatedContent) {
            self.stackView.frame.origin.y = self.enterName.frame.maxY + 20 }
    }
    
    //MARK: LogIn screen
    private func loginInScreen() {
        
        titleLabel.text = "Log In"
        signButton.setTitle("Register", for: .normal)
        registerButton.setTitle("ENTER", for: .normal)
        registerButton.setTitle("ENTER", for: .disabled)
        enterName.isHidden = true
        UIView.animate(withDuration: 0.2, delay: 0.00, usingSpringWithDamping: 1.00, initialSpringVelocity: 1.0, options: .allowAnimatedContent) {
            self.view.translatesAutoresizingMaskIntoConstraints = true
            self.stackView.frame.origin.y = self.titleLabel.frame.maxY + 20 }
    }
    
    //MARK: CheckTF for enabled registration button
    private func checkTextField() {
        if signUp {
            let isEmpty = (enterName.text?.isEmpty ?? true || enterEmail.text?.isEmpty ?? true || enterPassword.text?.isEmpty ?? true || charCountForPass())
            registerButton.isEnabled = !isEmpty
        
        } else {
            let isEmpty = (enterEmail.text?.isEmpty ?? true || charCountForPass())
            registerButton.isEnabled = !isEmpty
        }
    }

    
    //MARK: Limit char for password
    private func charCountForPass() -> Bool {
                if let pass = enterPassword.text  {
                if pass.count <= 5 {
                    return true
                }
            }
        return false
            }
                           
    //MARK: TF Action
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
       
        }
    
    //MARK: Reg disp or sign disp
    @IBAction private func SignInAction() {
        signUp = !signUp
        checkTextField()
    }
    
    //MARK: Registrated or enter in account func
    @IBAction private func registrationOrEnter() {
        
        
        //signUp ? registration() : signIn()
        guard let name = enterName.text else { return }
        guard let email = enterEmail.text?.replacingOccurrences(of: " ", with: "") else { return }
        guard let pass = enterPassword.text?.replacingOccurrences(of: " ", with: "") else { return }
        
        registrationVM.regOrEnter(name: name, email: email, pass: pass, signUp: signUp)
        
        //If result reg/sign succes - reg disp hide, in profile delegate actual user information
        registrationVM.update = {
            self.delegate?.getInf(User(email: email, name: name))
            self.dismiss(animated: true)
        }
        
        //Else self.disp called miss alert
        registrationVM.upadateError = { 
            self.alert()
        }
    }
    
    //MARK: Miss allert
    private func alert() {
        let alert = UIAlertController(title: "Email or password do not conform rules", message: "1. Check email(??heck available symbal @)\n2. Check entered password" , preferredStyle: .alert)
        let button = UIAlertAction(title: "Ok", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(button)
        present(alert, animated: true)
    }
}

//MARK: Delegate for all TF
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



