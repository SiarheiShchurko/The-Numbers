//
//  ViewController.swift
//  Pes
//
//  Created by Alinser Shchurko on 7.12.21.
//
//                
import UIKit
import Firebase

class StartPageVC: UIViewController {
    @IBOutlet private weak var logOutButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    @IBAction private func logOutAction() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
}




