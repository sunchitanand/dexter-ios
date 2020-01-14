//
//  HomeViewController.swift
//  Dexter
//
//  Created by Sunchit Anand on 12/15/19.
//  Copyright © 2019 Sunchit Anand. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class HomeViewController: UIViewController {
    
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var createDummyPostButton: UIButton!
    @IBOutlet weak var discoveryToggleButton: DiscoveryToggleButton!
    
    
    let firebaseAuth = Auth.auth()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func createDummyPostTapped(_ sender: Any) {
        
        UserModelController.sharedInstance.getUser(uid: "DYT0zIoUO5msrzfV5P8q") { (result) in
            switch(result) {
            case .success(let user):
                print(user.firstName)
            case .failure(let err):
                print("Error: \(err.localizedDescription)")
            }
        }
    }
    
    @IBAction func discoveryToggled(_ sender: Any) {
        if discoveryToggleButton.isOn {
            print("On")
        }
        else {
            print("Off")
        }
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
    
    func transitionToAuthentication() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        DispatchQueue.main.async {
            let authProvidersVC = storyboard.instantiateViewController(identifier: Constants.Storyboard.authenticationNavigationController) as? UINavigationController
            self.view.window?.rootViewController = authProvidersVC
            self.view.window?.makeKeyAndVisible()
        }
    }
    
}
