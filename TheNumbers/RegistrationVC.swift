//
//  RegistrationVC.swift
//  TheNumbers
//
//  Created by Alinser Shchurko on 1.09.22.
//

import Foundation
import UIKit

final class RegistrationVC: UIViewController {
    
    @IBOutlet private weak var enterEmail: UITextField! {
        didSet { enterEmail.borderStyle = .line }
    }
    
    @IBOutlet private weak var enterPassword: UITextField!
    
    @IBOutlet private weak var signButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    @IBAction private func SignInAction() {
        
        
    }
    
    
}
