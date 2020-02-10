//
//  Styles.swift
//  Dexter
//
//  Created by Sunchit Anand on 12/16/19.
//  Copyright © 2019 Sunchit Anand. All rights reserved.
//

import Foundation
import UIKit

class Styles {
    
    static func styleTextField(_ textField:UITextField) {
        
        //        // Create the bottom line
        //        let bottomLine = CALayer()
        //        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        //
        //        bottomLine.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        //
        //        // Remove border on text field
        //        textfield.borderStyle = .none
        //
        //        // Add the line to the text field
        //        textfield.layer.addSublayer(bottomLine)
        
        textField.layer.cornerRadius = textField.frame.size.height / 2
        textField.backgroundColor = UIColor.white
        textField.layer.borderWidth = 3.0
        textField.layer.borderColor = Theme.Color.buttonBlue.cgColor
        textField.borderStyle = .none
        
        textField.textAlignment = .center
        textField.clipsToBounds = true
        textField.backgroundColor = .white
    }
    
    static func styleFilledButton(_ button:UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = Theme.Color.buttonBlue
        button.layer.cornerRadius = button.frame.size.height / 2
        button.tintColor = UIColor.white
        button.titleLabel?.font = UIFont(name: Theme.Font.buttonTitle, size: 17)
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
    
    static func messageLabel(_ label: UILabel) {
        label.font = UIFont(name: Theme.Font.systemDefault, size: 15)
    }
    
}

