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
import CoreData

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        
        fullNameTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.delegate = self
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        let error = validateFields()
        if error != nil {
            showError(error!)
        }
        else {
            let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let firstName = String((fullNameTextField.text?.split(separator: " ").first)!)
            let lastName = String((fullNameTextField.text?.split(separator: " ").last)!)
            
            /** Create user in Firebase Authentication */
            Auth.auth().createUser(withEmail: email!, password: password!) { (authResult, error) in
                if let error = error {
                    let message = "Error creating user"
                    self.showError(message)
                    print(error.localizedDescription)
                }
                else {
                    /// Remove last two characters of Auth UID to store in Firestore
                    var firestoreUID = authResult!.user.uid
                    firestoreUID.removeLast(2)
                    let userData: [String: Any] = [Fields.User.uid: firestoreUID,
                                                   Fields.User.firstName: firstName,
                                                   Fields.User.lastName: lastName,
                                                   Fields.User.email: email!]
                    
                    let newUser = User(documentData: userData)!
                    // print(Fields.User.firstName, userData[Fields.User.firstName], newUser.firstName, firstName)
                    
                    /** Create user in Firestore */
                    UserModelController.createUser(newDocumentId: authResult!.user.uid, user: newUser, current: true) { (result) in
                        switch (result) {
                        case .success(let user):
                            print("current user firstname ", user.firstName)
                            self.pushAboutUserVC()
                            
                        case .failure(let err):
                            self.showError("Error saving user data")
                            print(err.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    /** DON'T DELETE  */
    
    //    func pushConfirmSignUpVC() {
    //        // grab the navigation view controller and push confirmSignUpVC in that
    //        let confirmSignUpViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.confirmSignUpViewController) as! AboutUserViewController
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
    
    func pushAboutUserVC() {
        let aboutUserViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.aboutUserViewController) as! AboutUserViewController
        navigationController?.pushViewController(aboutUserViewController, animated: true)
    }
    
    func validateFields() -> String? {
        // Check if all fields are filled in
        if fullNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all the fields"
        }
        
        // Check if password is secure
        return nil
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 0.7
    }
    
    func setupElements() {
        /** Hide the error label */
        errorLabel.alpha = 0
        
        /** Style the elements */
        Style.styleTextField(fullNameTextField)
        Style.styleTextField(emailTextField)
        Style.styleTextField(passwordTextField)
        Style.styleFilledButton(signUpButton)
        Style.textFieldLabel(fullNameLabel)
        Style.textFieldLabel(emailLabel)
        Style.textFieldLabel(passwordLabel)
        Style.styleBackButton(backButton)
        errorLabel.textColor = Theme.Color.dRed
    
        
        fullNameTextField.keyboardType = .default
        fullNameTextField.autocapitalizationType = .words
        fullNameTextField.autocorrectionType = .no
        emailTextField.keyboardType = .emailAddress
        passwordTextField.textContentType = .password
        
        /// Dark Mode
        self.view.backgroundColor = Theme.Color.darkBg
    }
}

extension SignUpViewController: UITextFieldDelegate {
    /**
     * Called when 'return' key pressed. return NO to ignore.
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /**
     * Called when the user click on the view (outside the UITextField).
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
