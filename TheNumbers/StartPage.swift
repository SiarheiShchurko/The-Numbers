//
//  ViewController.swift
//  Pes
//
//  Created by Alinser Shchurko on 7.12.21.
//
//                
import UIKit
import Foundation
import Firebase

class StartPageVC: UIViewController {
    
    //MARK: Labels outlet
    @IBOutlet private weak var nameUser: UILabel!
    @IBOutlet private weak var eMailUser: UILabel! {
        didSet { eMailUser.text = Auth.auth().currentUser?.email }
    }
    
    //MARK: Buttons outlet
    @IBOutlet private weak var logOutButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().addStateDidChangeListener { auth, user in
            if user == nil {
                self.transitionBetweenDisp()
            }
        }
    }
    
    //MARK: LogOut func
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
    
    //MARK: FUNC transition between disp
    private func transitionBetweenDisp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let nextVC = storyboard.instantiateViewController(withIdentifier: "\(RegistrationVC.self)") as? RegistrationVC else { return }
        nextVC.delegate = self
        nextVC.modalPresentationStyle = .overFullScreen
        present(nextVC, animated: true)
        
    }
}

//MARK: Delegate for showed name and e-mail user
extension StartPageVC: UserLabelDelegate {
    func getInf(_ inf: User ) {
        nameUser.text = inf.name
        eMailUser.text = inf.email
    }
}

