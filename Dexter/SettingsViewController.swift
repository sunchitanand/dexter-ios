//
//  SettingsViewController.swift
//  Dexter
//
//  Created by Sunchit Anand on 1/25/20.
//  Copyright © 2020 Sunchit Anand. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    @IBOutlet weak var signOutButton: UIButton!
    
    let firebaseAuth = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        do {
            try firebaseAuth.signOut()
        }
        catch let signOutError as NSError {
            /// TODO: Handle error
            print(signOutError.localizedDescription)
        }
        transitionToAuthenticationScreen()
    }
    
    func transitionToAuthenticationScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        DispatchQueue.main.async {
            let authProvidersVC = storyboard.instantiateViewController(identifier: Constants.Storyboard.authenticationNavigationController) as? UINavigationController
            self.view.window?.rootViewController = authProvidersVC
            self.view.window?.makeKeyAndVisible()
        }
    }
}
