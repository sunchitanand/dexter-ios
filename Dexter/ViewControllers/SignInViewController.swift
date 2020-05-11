//
//  SignInViewController.swift
//  Dexter
//
//  Created by Sunchit Anand on 12/15/19.
//  Copyright © 2019 Sunchit Anand. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {
    /* MARK: Labels */
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    /* MARK: Text Fields */
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    /* MARK: Buttons */
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    let errorMessage = "The password is invalid or the user does not exist."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        setupKeyboardNotifications()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(SignInViewController.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignInViewController.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardFrame.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let valid = validateFields()
        if valid != nil {
            Render.showErrorLabel(errorLabel: errorLabel, message: valid!)
            return
        }
        
        // Sign in the user
        Auth.auth().signIn(withEmail: email!, password: password!) { (result, error) in
            if error != nil {
                print(error!.localizedDescription)
                Render.showErrorLabel(errorLabel: self.errorLabel, message: error!.localizedDescription)
            }
            else {
                // Transition to home
                UserModelController.getCurrentUser() { (response) in
                    switch (response) {
                    case .success(_):
                        self.transitionToHome()
                    
                    case .failure(let err):
                        print("Login Error: \(err.localizedDescription)")
                        Render.showErrorLabel(errorLabel: self.errorLabel, message: err.localizedDescription)
                    }
                }
            }
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        if emailTextField.text == "" {
            Render.showErrorLabel(errorLabel: errorLabel, message: "Please enter your email and then click on Forgot password")
            return
        }
        Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) { (err) in
            if let err = err {
                let errorAlert = Render.singleActionAlert(title: "Error", message: err.localizedDescription)
                self.present(errorAlert, animated: true, completion: nil)
            }
        }
        let successAlert = Render.singleActionAlert(title: "Email Sent", message: "A password reset link has been sent to your email.")
        present(successAlert, animated: true, completion: nil)
    }
    
    func transitionToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        DispatchQueue.main.async {
            let homeContainerVC = storyboard.instantiateViewController(identifier: Constants.Storyboard.homeSidebarContainerController)
            self.view.window?.rootViewController = homeContainerVC
            self.view.window?.makeKeyAndVisible()
            if let window = self.view.window {
                UIView.transition(with: window,
                duration: 0.3,
                options: .transitionCrossDissolve,
                animations: nil,
                completion: nil)
            }
        }
    }
    
    func validateFields() -> String? {
        // Check if all fields are filled in
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all the fields"
        }
        return nil
    }
    
    func setupElements() {
         self.view.backgroundColor = Theme.Color.darkBg
        
        /* MARK: Text Fields */
        Render.styleTextField(emailTextField)
        emailTextField.keyboardType = .emailAddress
        
        Render.styleTextField(passwordTextField)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.keyboardType = .default
        passwordTextField.autocorrectionType = .no
        
        
        /* MARK: Buttons */
        Render.styleFilledButton(signInButton)
        
        Render.styleBackButton(backButton)
        
        forgotPasswordButton.setTitle("Forgot password?", for: .normal)
        forgotPasswordButton.titleLabel?.font = UIFont(name: Theme.Font.sansSerifSemiBold, size: 16)
        forgotPasswordButton.setTitleColor(Theme.Color.dGreen, for: .normal)
        
        /* MARK: Labels */
        Render.errorLabel(errorLabel)
        Render.textFieldLabel(emailLabel)
        Render.textFieldLabel(passwordLabel)
    }
    
}

extension SignInViewController: UITextFieldDelegate {
    // Called when 'return' key pressed. return NO to ignore.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    // Called when the user clicks on the view (outside the UITextField).
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}