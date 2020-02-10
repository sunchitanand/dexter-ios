//
//  SplashViewController.swift
//  Dexter
//
//  Created by Sunchit Anand on 12/15/19.
//  Copyright © 2019 Sunchit Anand. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class SplashViewController: UIViewController {
    
    var container: NSPersistentContainer!
    var toHome: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            toHome = true
            navigateToHome()
        } else {
            toHome = false
            navigateToAuth()
        }
    }
    
    func navigateToHome() {
        let homeViewController = storyboard?.instantiateViewController(identifier: "HomeTabBarController") as! UITabBarController
        DispatchQueue.main.async {
            self.view.window?.rootViewController = homeViewController
            self.view.window?.makeKeyAndVisible()
        }
    }
    
    func navigateToAuth() {
        let authNavigationController = storyboard?.instantiateViewController(identifier: "AuthenticationNavigationController") as! UINavigationController
        DispatchQueue.main.async {
            self.view.window?.rootViewController = authNavigationController
            self.view.window?.makeKeyAndVisible()
        }
        // self.present(homeViewController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if toHome {
            if let homeVC = segue.destination as? HomeViewController {
                homeVC.container = container
            }
        }
        else {
            if let authVC = segue.destination as? AuthenticationViewController {
                authVC.container = container
            }
        }
    }
    
}
