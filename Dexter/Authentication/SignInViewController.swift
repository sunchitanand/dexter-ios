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
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(SignInViewController.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(SignInViewController.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    //    deinit {
    //        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    //        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    //        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    //    }
    
    @IBAction func signInTapped(_ sender: Any) {
        
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        /// TODO: Validate the text fields
        
        /// TODO: Sign in the user
        Auth.auth().signIn(withEmail: email!, password: password!) { (result, error) in
            if error != nil {
                print(error!.localizedDescription)
                self.showError(error!.localizedDescription)
            }
            else {
                /// Transition to home
                self.transitionToHome()
                
            }
        }
    }
    
    //    @objc func keyboardWillShow(notification: NSNotification) {
    //        guard let userInfo = notification.userInfo else {return}
    //        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
    //        let keyboardFrame = keyboardSize.cgRectValue
    //        if self.view.frame.origin.y == 0 {
    //            self.view.frame.origin.y -= keyboardFrame.height
    //        }
    //    }
    //
    //    @objc func keyboardWillHide(notification: NSNotification) {
    //        if self.view.frame.origin.y != 0 {
    //            self.view.frame.origin.y = 0
    //        }
    //    }
    
    func transitionToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        DispatchQueue.main.async {
            let homeContainerVC = storyboard.instantiateViewController(identifier: Constants.Storyboard.homeTabBarController) as? UITabBarController
            self.view.window?.rootViewController = homeContainerVC
            self.view.window?.makeKeyAndVisible()
        }
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func setupElements() {
        // Hide the error label
        errorLabel.alpha = 0
        
        // Style the elements
        Styles.styleTextField(emailTextField)
        Styles.styleTextField(passwordTextField)
        Styles.styleFilledButton(signInButton)
        Styles.messageLabel(errorLabel)
        
    }
    
}

extension SignInViewController: UITextFieldDelegate {
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
