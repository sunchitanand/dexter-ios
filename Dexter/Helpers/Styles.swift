//
//  Styles.swift
//  Dexter
//
//  Created by Sunchit Anand on 12/16/19.
//  Copyright © 2019 Sunchit Anand. All rights reserved.
//

import Foundation
import UIKit

class Style {
    
    struct Labels {
        
    }
    
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
        
        // Create the bottom line (*currently, height set to 0 => not visible)
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textField.frame.height - 2, width: textField.frame.width, height: 0)
        bottomLine.backgroundColor = Theme.Color.greenOn.cgColor
        // Add the line to the text field
        textField.layer.addSublayer(bottomLine)
    }
    
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
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{6,}")
        return passwordTest.evaluate(with: password)
    }
    
    static func setFontandSize(textView: UITextView? = nil, label: UILabel? = nil, font: String, size: CGFloat) {
        if let textView = textView {
            textView.font = UIFont(name: font, size: size)
        }
        if let label = label {
            label.font = UIFont(name: font, size: size)
        }
    }
    
    static func styleSwitch(_ switchButton: UISwitch) {
        switchButton.tintColor = Theme.Color.switchOnBlue
        switchButton.onTintColor = Theme.Color.switchOnBlue
        switchButton.backgroundColor = Theme.Color.darkBg
        switchButton.layer.cornerRadius = 16
        switchButton.layer.masksToBounds = true
    }
    
    static func titleNewYork(_ textView: UITextView) {
        textView.font = UIFont(name: "NewYorkMedium-Heavy", size: 24)
        textView.alpha = 1
//        textView.textColor = Theme.Color.title
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
    
    static func textViewMessage(_ textView: UITextView) {
        textView.font = UIFont(name: Theme.Font.sansSerifSemiBold, size: 18)
        textView.textColor = .white
    }
    
    static func textViewSubtitle(_ textView: UITextView) {
        textView.font = UIFont(name: Theme.Font.sansSerifMedium, size: 20)
        textView.textColor = .white
    }
    
    static func headerSubtitle(_ textView: UITextView) {
        textView.font = UIFont(name: "SFProDisplay-Semibold", size: 14)
        textView.alpha = 0.7
        textView.textColor = .white
    }
    
    static func headerSubtitle(_ label: UILabel) {
        label.font = UIFont(name: "SFProDisplay-Semibold", size: 14)
        label.alpha = 0.7
        label.textColor = .white
    }
    static func styleBackButton(_ button: UIButton) {
        button.titleLabel?.font = UIFont(name: Theme.Font.sansSerifHeavy, size: 20)
        button.setTitleColor(Theme.Color.greenOn, for: .normal)
    }
    static func textFieldLabel(_ label: UILabel) {
        label.font = UIFont(name: Theme.Font.sansSerifSemiBold, size: 17)
        label.textColor = .white
    }
    
    static func aboutTextView(_ aboutTextView: UITextView) {
//        aboutTextView.backgroundColor = Theme.Color.cardBg
        aboutTextView.backgroundColor = .black
        //        aboutTextView.layer.borderWidth = 3
        //        aboutTextView.layer.borderColor = Theme.Color.greenOn.cgColor
        aboutTextView.layer.cornerRadius = 10
        aboutTextView.textContainer.maximumNumberOfLines = 10
        aboutTextView.textAlignment = .center
        aboutTextView.font = UIFont(name: Theme.Font.sansSerifRegular, size: 18)
        //        aboutTextView.centerVertically()
        aboutTextView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 5, right: 20)
        
        aboutTextView.textColor = .white
        
//        aboutTextView.layer.frame = CGRect(x: <#T##Double#>, y: <#T##Double#>, width: <#T##Double#>, height: <#T##Double#>)
//        aboutTextView.translatesAutoresizingMaskIntoConstraints = true
//        aboutTextView.sizeToFit()
//        aboutTextView.isScrollEnabled = false
    }
    
    static func profilePhotoImageView(_ imageView: UIImageView) {
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.layer.cornerRadius = 5
    }
    
}

