//
//  ChangePasswordViewController.swift
//  Dexter
//
//  Created by Sunchit Anand on 4/24/20.
//  Copyright © 2020 Sunchit Anand. All rights reserved.
//

import UIKit
import Firebase

class ChangePasswordViewController: UIViewController {
    /* MARK: Labels */
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var enterAgainLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    /* MARK: Text Views */
    @IBOutlet weak var oldPasswordTextView: DisplayTextView!
    @IBOutlet weak var newPasswordTextView: DisplayTextView!
    
    /* MARK: Text Fields */
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordONETextField: UITextField!
    @IBOutlet weak var newPasswordTWOTextField: UITextField!
    
    /* MARK: Buttons */
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var deleteAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        setupRecognizer()
    }
    
    @IBAction func changePasswordTapped(_ sender: Any) {
        if newPasswordONETextField.text == newPasswordTWOTextField.text {
            Auth.auth().currentUser?.updatePassword(to: newPasswordTWOTextField.text!) { (error) in
                if let error = error {
                    print("Error occured while changing password. \(error.localizedDescription)")
                }
            }
        }
        else {
            let message = "Passwords don't match."
            print(message)
            Render.showErrorLabel(errorLabel: self.errorLabel, message: message)
        }
    }
    
    func setNewPassword() {
        let newPasswordONE = newPasswordONETextField.text!
        let newPasswordTWO = newPasswordTWOTextField.text!
        
        if newPasswordONE == newPasswordTWO {
            Auth.auth().currentUser?.updatePassword(to: newPasswordONE) { (error) in
                if let error = error {
                    print("Error updating password...\(error.localizedDescription)")
                }
                else {
                    print("Password updated.")
                }
            }
        }
    }
    
    @IBAction func deleteAccountTapped(_ sender: Any) {
        let deleteAccountAlert = UIAlertController(title: "Delete account", message: "All your data will be permanently deleted from Dexter servers.", preferredStyle: UIAlertController.Style.alert)
        
        deleteAccountAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction!) in
            print("Deleting user...")
            let user = Auth.auth().currentUser
            
            user?.delete { error in
                if let error = error {
                    print("Error deleting user...\(error.localizedDescription)")
                } else {
                    print("Account deleted.")
                    self.transitionToWelcome()
                }
            }
        }))
        
        deleteAccountAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Cancelled deleting user.")
        }))
        present(deleteAccountAlert, animated: true, completion: nil)
    }
    
    @IBAction func backTapped(_ sender: Any) {
        transitionToHome()
    }
    
    func transitionToHome() {
        let storyboard = UIStoryboard(name: "Discovery", bundle: nil)
        DispatchQueue.main.async {
            let homeVC = storyboard.instantiateViewController(identifier: Constants.Storyboard.discoveryNavigationController) as! UINavigationController
            self.sideMenuController?.setContentViewController(to: homeVC)
        }
    }
    
    func transitionToWelcome() {
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        DispatchQueue.main.async {
            let authProvidersVC = storyboard.instantiateViewController(identifier: Constants.Storyboard.authenticationNavigationController) as? UINavigationController
            self.view.window?.rootViewController = authProvidersVC
            self.view.window?.makeKeyAndVisible()
        }
    }
    
    func setupRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.touch))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(recognizer)
    }
    
    @objc func touch() {
        self.view.endEditing(true)
    }
    
    func setupElements() {
        let backgroundColor = Theme.Color.darkBg
        self.view.backgroundColor = backgroundColor
        
        /* MARK: Labels */
        Render.labelTitle(headerTitleLabel)
        Render.textFieldLabel(enterAgainLabel)
        Render.errorLabel(errorLabel)
        
        /* MARK: Text Views */
        Render.textViewMessage(oldPasswordTextView)
        Render.textViewMessage(newPasswordTextView)
        
        
        /* MARK: Text Fields */
        Render.styleTextField(oldPasswordTextField)
        oldPasswordTextField.textContentType = .password
        oldPasswordTextField.isSecureTextEntry = true
        
        Render.styleTextField(newPasswordONETextField)
        newPasswordONETextField.textContentType = .password
        newPasswordONETextField.isSecureTextEntry = true
        
        Render.styleTextField(newPasswordTWOTextField)
        newPasswordTWOTextField.textContentType = .password
        newPasswordTWOTextField.isSecureTextEntry = true
        
        
        /* MARK: Buttons */
        Render.styleBackButton(backButton)
        
        Render.styleFilledButton(changePasswordButton)
        changePasswordButton.backgroundColor = Theme.Color.dGreen
        
        deleteAccountButton.setTitleColor(Theme.Color.dRed, for: .normal)
        deleteAccountButton.titleLabel?.font = UIFont(name: Theme.Font.sansSerifSemiBold, size: 18)
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
