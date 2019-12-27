//
//  SignUpViewController.swift
//  Dexter
//
//  Created by Sunchit Anand on 12/15/19.
//  Copyright © 2019 Sunchit Anand. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        let error = validateFields()
        if error != nil {
            showError(error!)
        }
        else {
            
            let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let firstName = fullNameTextField.text?.split(separator: " ").first
            let lastName = fullNameTextField.text?.split(separator: " ").last
            
            Auth.auth().createUser(withEmail: email!, password: password!) { (authResult, error) in
                if error != nil {
                    let message = "Error creating user"
                    self.showError(message)
                    print(message)
                }
                else {
                    let db = Firestore.firestore()
                    
                    let userData: [String: Any] = [
                        "name": [
                            "first": firstName,
                            "last": lastName
                        ],
                        "userId": authResult!.user.uid
                    ]
                    
                    db.collection("users").addDocument(data: userData) { (error) in
                        if error != nil {
                            self.showError("Error saving user data")
                        }
                        else {
                            self.transitionToHome()
                        }
                    }
                    // Transition to Home
                }
            }
        }
    }
    
    // DON'T DELETE
    
//    func pushConfirmSignUpVC() {
//        // grab the navigation view controller and push confirmSignUpVC in that
//        let confirmSignUpViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.confirmSignUpViewController) as! ConfirmSignUpViewController
//        confirmSignUpViewController.email = emailTextField.text
//        navigationController?.pushViewController(confirmSignUpViewController, animated: true)
//    }
    
    func transitionToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        DispatchQueue.main.async {
            let homeContainerVC = storyboard.instantiateViewController(identifier: Constants.Storyboard.homeTabBarController) as? UITabBarController
            self.view.window?.rootViewController = homeContainerVC
            self.view.window?.makeKeyAndVisible()
        }
    }
    
    func validateFields() -> String? {
        // Check if all fields are filled in
        if fullNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        
        // Check if password is secure
        return nil
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func setupElements() {
        // Hide the error label
        errorLabel.alpha = 0
        
        // Style the elements
        Styles.styleTextField(fullNameTextField)
        Styles.styleTextField(emailTextField)
        Styles.styleTextField(passwordTextField)
        Styles.styleFilledButton(signUpButton)
    }
}
