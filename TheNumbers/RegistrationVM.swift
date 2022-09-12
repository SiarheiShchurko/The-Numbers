//
//  RegistrationVM.swift
//  TheNumbers
//
//  Created by Alinser Shchurko on 12.09.22.
//

import UIKit
import Foundation
import Firebase

protocol RegistrationProtocol {
    func registration(_ email: String?, _ pass: String?)
    func signIn(_ email: String?, _ pass: String?)
}

class RegistrationVM: RegistrationProtocol {

    //MARK: Registrtion func
    func registration(_ email: String?, _ pass: String?) {
        //Optional delete
        guard let email = email else { return }
        guard let pass = pass else { return }
        
        //Registration
        Auth.auth().createUser(withEmail: email, password: pass) { result, error in
            if let error = error {
                print(error)
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
            if let error = error {
                print(error)
            }
            guard let result = result else { return }
            print(result.user.uid)
        }
    }
}
