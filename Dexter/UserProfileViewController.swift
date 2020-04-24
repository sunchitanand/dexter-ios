//
//  UserProfileViewController.swift
//  Dexter
//
//  Created by Sunchit Anand on 2/20/20.
//  Copyright © 2020 Sunchit Anand. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var twitterUsernameLabel: UILabel!
    @IBOutlet weak var twitterLogo: UIImageView!
    @IBOutlet weak var instagramUsernameLabel: UILabel!
    @IBOutlet weak var instagramLogo: UIImageView!
    @IBOutlet weak var container: UIView!
    
    public var temp : String = ""
    public var selectedUser  = User(documentData: [:])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        setupDummyData()
    }
    
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func setupElements() {
        let backgroundColor = Theme.Color.darkBg
        self.view.backgroundColor = backgroundColor
        
        /* MARK: Buttons */
        Style.styleBackButton(backButton)
        
        /* MARK: Views */
        Style.renderUserCardElements(cardContainer: container, separator: separator, profilePhoto: profilePhotoImageView, twitterLogo: twitterLogo, instagramLogo: instagramLogo, fullName: fullNameLabel, email: emailLabel, bio: aboutTextView, twitterHandle: twitterUsernameLabel, instagramUsername: instagramUsernameLabel)
        
    }
    
    func setupDummyData() {
        fullNameLabel.text = "Sunchit Anand"
        aboutTextView.text = "SWE at Oracle, Bay Area. Deep into skiing, chess and space. Looking to connect with PMs and professionals working on autonomous vehicles."
        emailLabel.text = "sunchit.anand@gmail.com"
        twitterUsernameLabel.text = "@sunchitanand"
        instagramUsernameLabel.text = "@sunchitanand"
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
