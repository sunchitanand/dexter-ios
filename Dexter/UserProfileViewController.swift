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
    @IBOutlet weak var instagramUsernameLabel: UILabel!
    @IBOutlet weak var container: UIView!
    
    public var temp : String = ""
    public var selectedUser  = User(documentData: [:])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
    }
    
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func setupElements() {
        if let selectedUser = selectedUser {
            let first = selectedUser.firstName
            let last = selectedUser.lastName
            fullNameLabel.text = first + " " + last
            aboutTextView.text = selectedUser.about
            emailLabel.text = selectedUser.email
            twitterUsernameLabel.text = selectedUser.twitterHandle
            instagramUsernameLabel.text = selectedUser.instagramHandle
        }
        
        let cardColor = Theme.Color.cardBg
        profilePhotoImageView.backgroundColor = Theme.Color.switchOnBlue
        profilePhotoImageView.layer.cornerRadius = 10
        
        Style.setFontandSize(textView: nil, label: fullNameLabel, font: Theme.Font.sansSerifSemiBold, size: 18)
        separator.backgroundColor = Theme.Color.switchOnBlue
        Style.setFontandSize(textView: aboutTextView, label: nil, font: Theme.Font.sansSerifSemiBold, size: 15)
        aboutTextView.backgroundColor = cardColor
        Style.setFontandSize(textView: nil, label: emailLabel, font: Theme.Font.sansSerifRegular, size: 15)
        Style.setFontandSize(textView: nil, label: twitterUsernameLabel, font: Theme.Font.sansSerifRegular, size: 15)
        Style.setFontandSize(textView: nil, label: instagramUsernameLabel, font: Theme.Font.sansSerifRegular, size: 15)
        Style.styleBackButton(backButton)
        container.backgroundColor = cardColor
        container.layer.borderColor = Theme.Color.switchOnBlue.cgColor
        container.layer.borderWidth = 0
        container.layer.cornerRadius = 10
        container.layer.shadowOpacity = 0.3
        container.layer.shadowOffset = CGSize(width: 1, height: 2)

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
