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
    @IBOutlet weak var topMessageTextView: AlignedTextView!
    @IBOutlet weak var humaansCoverImageView: UIImageView!
    
    var container: NSPersistentContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
    }
    
    // Style the views
    func setupElements() {
        Style.styleFilledButton(signUpButton)
        Style.styleBackButton(signInButton)
        Style.labelTitle(greetingLabel)
        Style.textViewMessage(topMessageTextView)
        humaansCoverImageView.image = UIImage(named: "cover-dark")
        humaansCoverImageView.contentMode = .scaleAspectFill
        
        /// Dark Mode
        self.view.backgroundColor = Theme.Color.darkBg
        topMessageTextView.backgroundColor = Theme.Color.darkBg
    }

}
