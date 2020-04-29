//
//  Styles.swift
//  Dexter
//
//  Created by Sunchit Anand on 12/16/19.
//  Copyright © 2019 Sunchit Anand. All rights reserved.
//

import Foundation
import UIKit

class Render {
    
    struct Labels {
        
    }
    
    /* MARK: Text Fields */
    
    static func styleTextField(_ textField:UITextField) {
        //        textField.backgroundColor = Theme.Color.cardBg
        textField.backgroundColor = .black
        textField.textColor = .white
        
        textField.textAlignment = .center
        textField.layer.cornerRadius = textField.frame.size.height / 2
        textField.borderStyle = .none
        textField.clipsToBounds = true
        textField.placeholder = ""
        textField.font = UIFont(name: Theme.Font.sansSerifRegular, size: 18)
        textField.spellCheckingType = .no
        textField.returnKeyType = .done
        // Create the bottom line (*currently, height set to 0 => not visible)
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textField.frame.height - 2, width: textField.frame.width, height: 0)
        bottomLine.backgroundColor = Theme.Color.greenOn.cgColor
        // Add the line to the text field
        textField.layer.addSublayer(bottomLine)
    }
    
    /* MARK: Buttons */
    
    static func styleFilledButton(_ button:UIButton) {
        button.backgroundColor = Theme.Color.dGreen
        button.layer.cornerRadius = button.frame.size.height / 2
        button.tintColor = UIColor.white
        button.setTitleColor(Theme.Color.darkBg, for: .normal)
        button.titleLabel?.font = UIFont(name: Theme.Font.buttonTitle, size: 20)
        
        /// Shadow
        //        button.layer.shadowPath = UIBezierPath(rect: button.bounds).cgPath
        //        button.layer.shadowRadius = button.frame.size.height / 2
        button.layer.shadowOffset = CGSize(width: 1, height: 2)
        button.layer.shadowOpacity = 0.5
    }
    
    static func styleHollowButton(_ button:UIButton) {
        // Hollow rounded corner style
        button.layer.borderWidth = 4
        button.layer.borderColor = Theme.Color.buttonBlue.cgColor
        button.layer.cornerRadius = button.frame.size.height / 2
        button.tintColor = UIColor.black
        button.titleLabel?.font = UIFont(name: Theme.Font.buttonTitle, size: 17)
    }
    
    static func styleBackButton(_ backButton: UIButton) {
        let backImg = UIImage(named: "back")?.withRenderingMode(.alwaysOriginal)
        backButton.setImage(backImg, for: .normal)
        backButton.contentMode = .scaleAspectFit
        backButton.setTitle("", for: .normal)
    }
    
    static func signInButton(_ button: UIButton) {
        button.titleLabel?.font = UIFont(name: Theme.Font.sansSerifHeavy, size: 20)
        button.setTitleColor(Theme.Color.dGreen, for: .normal)
    }
    
    static func moreButton(_ button: UIButton) {
        let moreImg = UIImage(named: "baseline_more_vert_white_24pt")?.withRenderingMode(.alwaysOriginal)
        button.setImage(moreImg, for: .normal)
        button.contentMode = .scaleAspectFit
        button.setTitle("", for: .normal)
    }
    
    
    /* MARK: Labels */
    
    static func discoveryTitleLabel(_ label: UILabel) {
        label.font = UIFont(name: "NewYorkMedium-Heavy", size: 25)
        label.alpha = 1
        //        label.textColor = Theme.Color.title
        label.textColor = Theme.Color.darkBg
    }
    
    static func labelTitle(_ label: UILabel) {
        label.font = UIFont(name: Theme.Font.serifSemiBold, size: 26)
        label.textColor = .white
    }
    
    static func errorLabel(_ label: UILabel) {
        label.textColor = Theme.Color.dRed
        label.font = UIFont(name: Theme.Font.sansSerifRegular, size: 17)
        label.sizeToFit()
        label.alpha = 0
    }
    
    static func showErrorLabel(errorLabel: UILabel, message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            errorLabel.alpha = 0
        }
    }
    
    static func textFieldLabel(_ label: UILabel) {
        label.font = UIFont(name: Theme.Font.sansSerifSemiBold, size: 17)
        label.textColor = .white
    }
    
    
    /* MARK: Text Views */
    
    static func titleNewYork(_ textView: UITextView) {
        textView.font = UIFont(name: "NewYorkMedium-Heavy", size: 24)
        textView.alpha = 1
        //        textView.textColor = Theme.Color.title
    }
    
    static func textViewMessage(_ textView: UITextView) {
        textView.font = UIFont(name: Theme.Font.sansSerifSemiBold, size: 18)
        textView.backgroundColor = Theme.Color.darkBg
        textView.textColor = .white
        textView.sizeToFit()
        textView.isScrollEnabled = false
    }
    
    static func textViewSubtitle(_ textView: UITextView) {
        textView.font = UIFont(name: Theme.Font.sansSerifMedium, size: 20)
        textView.textColor = .white
        textView.sizeToFit()
    }
    
    static func enterBioTextView(_ aboutTextView: UITextView) {
        aboutTextView.font = UIFont(name: Theme.Font.sansSerifRegular, size: 17)
        aboutTextView.backgroundColor = .black
        /*
         aboutTextView.layer.borderWidth = 3
         aboutTextView.layer.borderColor = Theme.Color.greenOn.cgColor
         */
        aboutTextView.layer.cornerRadius = 10
        //        aboutTextView.textContainer.maximumNumberOfLines = 10
        aboutTextView.textAlignment = .center
        aboutTextView.centerVertically()
        aboutTextView.textContainerInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        //        aboutTextView.isScrollEnabled = true
        aboutTextView.textColor = .white
        aboutTextView.returnKeyType = .done
        
        /*
         aboutTextView.layer.frame = CGRect(x: <#T##Double#>, y: <#T##Double#>, width: <#T##Double#>, height: <#T##Double#>)
         aboutTextView.translatesAutoresizingMaskIntoConstraints = true
         aboutTextView.sizeToFit()
         aboutTextView.isScrollEnabled = false
         */
    }
    
    
    /* MARK: Views */
    
    static func profilePhotoImageView(_ imageView: UIImageView) {
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.layer.cornerRadius = 5
    }
    
    static func styleSwitch(_ switchButton: UISwitch) {
        switchButton.tintColor = Theme.Color.switchOnBlue
        switchButton.onTintColor = Theme.Color.switchOnBlue
        switchButton.backgroundColor = .black
        switchButton.layer.cornerRadius = 16
        switchButton.layer.masksToBounds = true
    }
    
    static func renderUserCardElements(cardContainer: UIView, separator: UIView, profilePhoto: UIImageView, twitterLogo: UIImageView, instagramLogo: UIImageView, fullName: UILabel, email: UILabel, bio: UITextView, twitterHandle: UILabel?, instagramUsername: UILabel?) {
        let cardBgColor = UIColor.black
        
        cardContainer.backgroundColor = cardBgColor
        cardContainer.layer.cornerRadius = 10
        cardContainer.layer.shadowOpacity = 0.3
        cardContainer.layer.shadowOffset = CGSize(width: 1, height: 2)
        
        separator.backgroundColor = Theme.Color.darkBg
        
        Render.profilePhotoImageView(profilePhoto)
        
        let twitterLogoImg = UIImage(named: "twitter-logo-blue")
        let instagramLogoImg = UIImage(named: "instagram-logo")
        twitterLogo.image = twitterLogoImg
        instagramLogo.image = instagramLogoImg
        twitterLogo.contentMode = .scaleAspectFit
        instagramLogo.contentMode = .scaleAspectFit
        
        fullName.font = UIFont(name: Theme.Font.sansSerifHeavy, size: 18)
        fullName.textColor = .white
        
        email.textColor = Theme.Color.dGreen
        email.font = UIFont(name: Theme.Font.sansSerifMedium, size: 17)
        
        bio.font = UIFont(name: Theme.Font.sansSerifMedium, size: 17)
        bio.backgroundColor = cardBgColor
        bio.textColor = .white
        bio.sizeToFit()
        bio.isScrollEnabled = false
        
    }
    
    static func dexterLogo(_ imageView: UIImageView) {
        let dexterLogoImg = UIImage(named: "dexter-logo-white")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Theme.Color.dGreen
        imageView.image = dexterLogoImg
    }
    
    /* MARK: Alerts */
    
    static func singleActionAlert (title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(alertAction)
        alertController.setTint(color: .white)
        return alertController
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{6,}")
        return passwordTest.evaluate(with: password)
    }
}

