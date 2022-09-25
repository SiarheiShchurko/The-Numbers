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
    
    func regOrEnter(name: String, email: String, pass: String, signUp: Bool)
    
    
}

class RegistrationVM: RegistrationVMProtocol {
    
    //MARK: Update if success
    var update: (() -> Void)?
    
    //MARK: Update if error
    var upadateError: (() -> Void)?
    
    //MARK: Service var
    let regService = RegServiceVC()
    
    //MARK: Registration and signIn func
    func regOrEnter(name: String, email: String, pass: String, signUp: Bool) {
        if signUp {
            regService.registration(name: name, email: email, pass: pass) { [ weak self ] ( complition ) in
                self?.checkResult(complition)
            }
        } else {
            regService.signIn(email: email, pass: pass) { [ weak self ] ( complition ) in
                self?.checkResult(complition)
            }
        }
    }
    
    //MARK: Check result for success/enter
    private func checkResult(_ object: RegSignResult) {
        switch object {
        case .success:
            self.update?()
        case .failure:
            self.upadateError?()
        case .none:
            break }
    }
}

    
//    func signIn(email: String, pass: String) {
//        regService.signIn(email: email, pass: pass) { [ weak self ] ( complition ) in
//            switch complition {
//            case .success:
//                self?.update?()
//            case .failure:
//                self?.upadateError?()
//            case .none:
//                break
//            }
//        }
//    }

 

