//
//  SplashViewController.swift
//  Dexter
//
//  Created by Sunchit Anand on 12/15/19.
//  Copyright © 2019 Sunchit Anand. All rights reserved.
//

import UIKit
import Firebase

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            navigateToHome()
        } else {
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
