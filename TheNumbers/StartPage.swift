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

final class StartPageVC: UIViewController {
    var registrationVM: RegistrationProtocol = RegistrationVM()
    
    //MARK: Labels outlet
    @IBOutlet private weak var nameUser: UILabel! {
        didSet {
            let defaults = UserDefaults.standard
            guard let email = Auth.auth().currentUser?.email else { return }
            nameUser.text = defaults.string(forKey: email)
        }
    }
    
    //MARK: EmailOut label
    @IBOutlet private weak var eMailUser: UILabel! {
        didSet { eMailUser.text = Auth.auth().currentUser?.email }
    }
    
    //MARK: Buttons outlet
    @IBOutlet private weak var logOutButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAutorization()
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
    //MARK: Check auth() func
    private func checkAutorization() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if user == nil {
                self.transitionBetweenDisp()
            }
        }
    }
}

//MARK: Delegate for showed name and e-mail user
extension StartPageVC: UserLabelDelegate {
    func getInf(_ inf: User ) {
        guard let email = inf.email else { return }
        let defaults = UserDefaults.standard
        nameUser.text = defaults.string(forKey: email)
        eMailUser.text = inf.email
            }
        }


