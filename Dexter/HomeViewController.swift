//
//  HomeViewController.swift
//  Dexter
//
//  Created by Sunchit Anand on 12/15/19.
//  Copyright © 2019 Sunchit Anand. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var createDummyPostButton: UIButton!
    let firebaseAuth = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        do {
            try firebaseAuth.signOut()
        }
        catch let signOutError as NSError {
            /// TODO: Handle error
            print(signOutError.localizedDescription)
        }
        transitionToAuthentication()
    }
    
    @IBAction func createDummyPostTapped(_ sender: Any) {
        
    }
    
    func transitionToAuthentication() {
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         DispatchQueue.main.async {
             let authProvidersVC = storyboard.instantiateViewController(identifier: Constants.Storyboard.authenticationNavigationController) as? UINavigationController
             self.view.window?.rootViewController = authProvidersVC
             self.view.window?.makeKeyAndVisible()
         }
     }

}
