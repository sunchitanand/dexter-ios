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
    /* MARK: Labels */
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var termsAndPolicyMessageLabel: UILabel!
    
    /* MARK: Text Fields */
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    /* MARK: Buttons */
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var termsAndPolicyButton: UIButton!
    
    static var isUserCreated = false
    
    let termsAndPolicyMessage = "By signing up, you're agreeing to our Privacy Policy and Terms of Service."
    let createUserError = "An error occured when trying to create user. Please try again."
    let firestoreError = "An error occured when trying to save user data."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        
        fullNameTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.delegate = self
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        if !SignUpViewController.isUserCreated {
            SignUpViewController.isUserCreated = true
            createNewUser()
        }
        else {
            self.pushAboutUserVC()
        }
    }
    
    @IBAction func termsAndPolicyTapped(_ sender: Any) {
       if let url = URL(string:
            "https://www.notion.so/dexterapp/DEXTER-PRIVACY-POLICY-6de9eab9da514cd9ad3357d18d1b936f") {
            UIApplication.shared.open(url)
        }
    }
    
    
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func createNewUser() {
        let error = validateFields()
        if error != nil {
            Render.showErrorLabel(errorLabel: self.errorLabel, message: error!)
        }
        else {
            let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let fullName = fullNameTextField.text
            let splitName = fullName?.split(separator: " ")
            let firstName = String((splitName?.first!)!)
            let lastName = splitName?.count == 1 ? "" : String((splitName?.last!)!)
            
            
            /** Create user in Firebase Authentication */
            Auth.auth().createUser(withEmail: email!, password: password!) { (authResult, error) in
                if let error = error {
                    print("[ERROR] \(error.localizedDescription)")
                    let message = error.localizedDescription
                    Render.showErrorLabel(errorLabel: self.errorLabel, message: message)
                }
                else {
                    print("[SUCCESS] User created in Auth.")
                    /// Remove last two characters of Auth UID to store in Firestore
                    var firestoreUID = authResult!.user.uid
                    firestoreUID.removeLast(2)
                    let userData: [String: Any] = [Fields.User.uid: firestoreUID,
                                                   Fields.User.firstName: firstName,
                                                   Fields.User.lastName: lastName,
                                                   Fields.User.email: email!]
                    
                    let newUser = User(documentData: userData)!
                    // print(Fields.User.firstName, userData[Fields.User.firstName], newUser.firstName, firstName)
                    
                    /// Create user in Firestore
                    UserModelController.createUser(newDocumentId: firestoreUID, user: newUser, current: true) { (result) in
                        switch (result) {
                        case .success(let user):
                            print("Creating new user... \(user)")
                            self.pushAboutUserVC()
                            
                        case .failure(let err):
                            Render.showErrorLabel(errorLabel: self.errorLabel, message: err.localizedDescription)
                            print(err.localizedDescription)
                        }
                    }
                }
            }
        }
    }

    func transitionToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        DispatchQueue.main.async {
            let homeContainerVC = storyboard.instantiateViewController(identifier: Constants.Storyboard.homeSidebarContainerController)
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
        /* TODO: Check if password is secure */
    
        return nil
    }
    
    func setupElements() {
        self.view.backgroundColor = Theme.Color.darkBg
        
        /* MARK: Labels */
        Render.textFieldLabel(fullNameLabel)
        Render.textFieldLabel(emailLabel)
        Render.textFieldLabel(passwordLabel)
        Render.errorLabel(errorLabel)
        
        termsAndPolicyMessageLabel.text = self.termsAndPolicyMessage
        termsAndPolicyMessageLabel.font = UIFont(name: Theme.Font.sansSerifRegular, size: 14)
        termsAndPolicyMessageLabel.textColor = .lightGray
        
        
        /* MARK: Text Fields */
        Render.styleTextField(fullNameTextField)
        fullNameTextField.keyboardType = .default
        fullNameTextField.autocapitalizationType = .words
        fullNameTextField.autocorrectionType = .no
        
        Render.styleTextField(emailTextField)
        emailTextField.keyboardType = .emailAddress
        
        Render.styleTextField(passwordTextField)
        passwordTextField.textContentType = .password
        
        
        /* MARK: Buttons */
        Render.styleFilledButton(signUpButton)
        Render.styleBackButton(backButton)
    }
}

extension SignUpViewController: UITextFieldDelegate {
    /// Called when 'return' key pressed. return NO to ignore.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    /// Called when the user click on the view (outside the UITextField).
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
