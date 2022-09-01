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
        // Override point for customization after application launch.
        return true
    }
}
    
