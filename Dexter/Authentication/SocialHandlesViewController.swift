//
//  SocialHandlesViewController.swift
//  
//
//  Created by Sunchit Anand on 3/7/20.
//

import UIKit
import Firebase
import FirebaseStorage

class SocialHandlesViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageSubtitleTextView: AlignedTextView!
    
    @IBOutlet weak var cardContainer: UIView!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var aboutTextView: AlignedTextView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var twitterSmallImageView: UIImageView!
    @IBOutlet weak var instagramSmallImageView: UIImageView!
    @IBOutlet weak var twitterHandlePlaceholderView: UIView!
    @IBOutlet weak var instagramHandlePlaceholderView: UIView!
    
    @IBOutlet weak var twitterLargeImageView: UIImageView!
    @IBOutlet weak var instagramLargeImageView: UIImageView!
    @IBOutlet weak var twitterHandleTextField: UITextField!
    @IBOutlet weak var instagramHandleTextField: UITextField!
    
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    let photoHelper = SelectPhotoHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        
        photoHelper.completionHandler = { image in
            self.profilePhotoImageView.image = image
            UserModelController.updateProfilePhoto(image: image)
        }
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        let handles: [String : Any] = ["twitterHandle": twitterHandleTextField.text!,
                                       "instagramHandle": instagramHandleTextField.text!]
        UserModelController.updateUser(newUserData: handles) { (response) in
            switch response {
            case .success( _):
                //                User._current?.twitterHandle = self.twitterHandleTextField.text
                //                User._current?.instagramHandle = self.instagramHandleTextField.text
                self.transitionToDiscovery()
                return
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    @IBAction func addPhotoTapped(_ sender: Any) {
        photoHelper.presentActionSheet(from: self)
    }
    
    @IBAction func skipTapped(_ sender: Any) {
        self.transitionToDiscovery()
    }
    
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func transitionToDiscovery() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        DispatchQueue.main.async {
            let homeContainerVC = storyboard.instantiateViewController(identifier: Constants.Storyboard.homeTabBarController) as? UITabBarController
            self.view.window?.rootViewController = homeContainerVC
            self.view.window?.makeKeyAndVisible()
        }
    }
    
    func setupElements() {
        Style.styleBackButton(backButton)
        Style.labelTitle(titleLabel)
        Style.textViewSubtitle(messageSubtitleTextView)
        
        let cardBg = Theme.Color.cardBg
        cardContainer.backgroundColor = cardBg
        cardContainer.layer.cornerRadius = 10
        cardContainer.layer.shadowOpacity = 0.3
        cardContainer.layer.shadowOffset = CGSize(width: 1, height: 2)
        
        Style.profilePhotoImageView(profilePhotoImageView)
        fullNameLabel.font = UIFont(name: Theme.Font.sansSerifMedium, size: 19)
        aboutTextView.font = UIFont(name: Theme.Font.sansSerifRegular, size: 16)
        aboutTextView.backgroundColor = cardBg
        
        emailLabel.font = UIFont(name: Theme.Font.sansSerifRegular, size: 18)
        twitterHandlePlaceholderView.layer.cornerRadius = 10
        instagramHandlePlaceholderView.layer.cornerRadius = 10
        
//        twitterLargeImageView.layer.cornerRadius = 5
//        instagramLargeImageView.layer.cornerRadius = 5
//        Style.styleTextField(twitterHandleTextField)
//        Style.styleTextField(instagramHandleTextField)
//        twitterHandleTextField.placeholder = "Twitter"
//        instagramHandleTextField.placeholder = "Instagram"
        
        Style.styleFilledButton(skipButton)
        skipButton.backgroundColor = Theme.Color.redOff
        Style.styleFilledButton(saveButton)
        
        /// setup data
        fullNameLabel.text = User.current.firstName + " " + User.current.lastName
        aboutTextView.text = User.current.about
        emailLabel.text = User.current.email
        
        messageSubtitleTextView.adjustsFontForContentSizeCategory = true
//        messageSubtitleTextView.minimumZoomScale = 0.2
        
        /// Dark Mode
        let bg = Theme.Color.darkBg
        self.view.backgroundColor = bg
        messageSubtitleTextView.backgroundColor = bg
        aboutTextView.backgroundColor = .black
        cardContainer.backgroundColor = .black
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
