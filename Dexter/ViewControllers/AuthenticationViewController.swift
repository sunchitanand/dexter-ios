//
//  AuthenticationViewController.swift
//  Dexter
//
//  Created by Sunchit Anand on 12/15/19.
//  Copyright © 2019 Sunchit Anand. All rights reserved.
//

import UIKit
import CoreData

class AuthenticationViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var topMessageTextView: DisplayTextView!
    @IBOutlet weak var humaansCoverImageView: UIImageView!
    
    var container: NSPersistentContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SignUpViewController.isUserCreated = false
        setupElements()
    }
    
    func setupElements() {
        let backgroundColor = Theme.Color.darkBg
        self.view.backgroundColor = backgroundColor
        topMessageTextView.backgroundColor = backgroundColor
        
        /* MARK: Buttons */
        Render.styleFilledButton(signUpButton)
        Render.signInButton(signInButton)
        
        /* MARK: Labels */
        Render.labelTitle(greetingLabel)
        
        /* MARK: Text View */
        Render.textViewMessage(topMessageTextView)
        
        /* MARK: Image View*/
        humaansCoverImageView.image = UIImage(named: "cover-dark")
        humaansCoverImageView.contentMode = .scaleAspectFill
    }

}
