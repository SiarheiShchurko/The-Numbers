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
    
    var userDataBase: [String: String]  { get set }
    func loadUsers(_ email: String, _ name: String)
}

final class RegistrationVM: RegistrationProtocol {
    
    var userDataBase = Dictionary<String, String>()
    
    func loadUsers(_ email: String,_ name: String) {
        if !userDataBase.keys.contains(email) {
        userDataBase.updateValue(name, forKey: email)
        }
    }
    
    

    //MARK: Registrtion func

    

}
