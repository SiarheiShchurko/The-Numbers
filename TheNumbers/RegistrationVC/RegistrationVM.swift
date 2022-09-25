//
//  RegistrationVM.swift
//  TheNumbers
//
//  Created by Alinser Shchurko on 25.09.22.
//

import UIKit

protocol RegistrationVMProtocol: AnyObject {
    
    var update: (() -> Void)? { get set }
    
    var upadateError: (() -> Void)? { get set }
    
    func registration(name: String, email: String, pass: String)
    
    func signIn(email: String, pass: String)
    
}

class RegistrationVM: RegistrationVMProtocol {
    
    //MARK: Update if success
    var update: (() -> Void)?
    
    //MARK: Update if error
    var upadateError: (() -> Void)?
    
    //MARK: Service var
    let regService = RegServiceVC()
    
    func registration(name: String, email: String, pass: String) {
        regService.registration(name: name, email: email, pass: pass) { [ weak self ] ( complition ) in
            switch complition {
            case .success:
                self?.update?()
            case .failure:
                self?.upadateError?()
            case .none:
                break
            }
        }
    }
    
    func signIn(email: String, pass: String) {
        regService.signIn(email: email, pass: pass) { [ weak self ] ( complition ) in
            switch complition {
            case .success:
                self?.update?()
            case .failure:
                self?.upadateError?()
            case .none:
                break
            }
        }
    }
}
 

