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
    @IBOutlet private weak var nameUser: UILabel! {
        didSet { nameUser.text =  }
    }
    @IBOutlet private weak var logOutButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction private func logOutAction() {
        let alert = UIAlertController(title: "Do you want exit?", message: nil, preferredStyle: .alert)
        let buttonYes = UIAlertAction(title: "Yes", style: .default) { _ in
            do {
                try Auth.auth().signOut()
            } catch {
                print(error)
            }
        }
        let buttonNo = UIAlertAction(title: "No", style: .cancel) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(buttonYes)
        alert.addAction(buttonNo)
        present(alert, animated: true)
    }
}




