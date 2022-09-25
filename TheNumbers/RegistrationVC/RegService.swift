//
//  RegServiceVC.swift
//  TheNumbers
//
//  Created by Alinser Shchurko on 25.09.22.
//

import UIKit
import Firebase

enum RegSignResult {
    case success
    case failure
    case none
}
    
class RegServiceVC: UIViewController {
    
    private var resultt: RegSignResult = .none
    
    func registration(name: String, email: String, pass: String, complition: @escaping (RegSignResult) -> Void) {
        
        //Registration
      
        Auth.auth().createUser(withEmail: email, password: pass) { result, error in
            if error == nil {
                //Saved user
                UserDefaults.standard.set(name, forKey: email)
                
                //Give result:
                self.resultt = .success
                complition(self.resultt)
                
                //Enter in account
                self.signIn(email: email, pass: pass) { (complition) in
                    print(complition)
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
