//
//  AppDelegate.swift
//  Pes
//
//  Created by Alinser Shchurko on 7.12.21.
//

import UIKit
import Firebase

@UIApplicationMain
//@available(iOS 13.0, *)
//@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Auth.auth().addStateDidChangeListener { auth, user in
            if user == nil {
                self.transitionBetweenDisp()
            }
        }
        // Override point for customization after application launch.
        return true
    }
    
    //MARK: FUNC transition between disp
    private func transitionBetweenDisp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let nextVC = storyboard.instantiateViewController(withIdentifier: "\(RegistrationVC.self)") as? RegistrationVC else { return }
        self.window?.rootViewController?.present(nextVC, animated: true)
    }
}
    
