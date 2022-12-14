//
//  RegServiceVC.swift
//  TheNumbers
//
//  Created by Alinser Shchurko on 25.09.22.
//

import UIKit
import Firebase

//MARK: Enum for return complition
enum RegSignResult {
    case success
    case failure
    case none
}
    
final class RegServiceVC: UIViewController {
    
    private var resultt: RegSignResult = .none
    
    func registration(name: String, email: String, pass: String, complition: @escaping (RegSignResult) -> Void) {
        
        //Registration
        Auth.auth().createUser(withEmail: email, password: pass) { result, error in
            if error == nil {
                
                //Give result:
                self.resultt = .success
                complition(self.resultt)
                
                //Enter in account
                self.signIn(email: email, pass: pass) { (complition) in
                    if complition == .success {
                        //Saved user
                        UserDefaults.standard.set(name, forKey: email)
                    }
                }
            } else {
                self.resultt = .failure
                complition(self.resultt)
            }
                }
            }
        
    func signIn(email: String, pass: String, complition: @escaping (RegSignResult) -> Void ) {
        //Enter
            Auth.auth().signIn(withEmail: email, password: pass) { result, error in
                if error == nil {
                    self.resultt = .success
                    complition(self.resultt)
                } else {
                    self.resultt = .failure
                    complition(self.resultt)
                }
            }
        }
}
