//
//  AboutUserViewController.swift
//  Dexter
//
//  Created by Sunchit Anand on 12/15/19.
//  Copyright © 2019 Sunchit Anand. All rights reserved.
//

import UIKit

class AboutUserViewController: UIViewController {
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var greetingTitleLabel: UILabel!
    @IBOutlet weak var greetingSubtitleTextView: AlignedTextView!
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var backButton: UIButton!
    
    public var email : String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        aboutTextView.delegate = self
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        let aboutData: [String : Any] = ["about": aboutTextView.text!]
        UserModelController.updateUser(newUserData: aboutData) { (response) in
            switch (response) {
            case .success( _):
                //                self.transitionToDiscovery()
                self.pushSocialHandlesViewController()
                break
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func pushSocialHandlesViewController() {
        let socialHandlesViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.socialHandlesViewController) as! SocialHandlesViewController
        navigationController?.pushViewController(socialHandlesViewController, animated: true)
    }
    
    func setupElements() {
        Style.aboutTextView(aboutTextView)
        Style.styleBackButton(backButton)
        Style.styleFilledButton(nextButton)
        Style.labelTitle(greetingTitleLabel)
        Style.textViewSubtitle(greetingSubtitleTextView)
        
        greetingTitleLabel.text = "Hey, \(User.current.firstName)."
        
        /// Dark Mode
        let bg = Theme.Color.darkBg
        self.view.backgroundColor = bg
        greetingSubtitleTextView.backgroundColor = bg
    }
}

extension AboutUserViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = aboutTextView.text ?? ""
        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }
        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        // make sure the result is under x characters
        return updatedText.count <= 350
    }
}

extension AboutUserViewController: UITextFieldDelegate {
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
}
