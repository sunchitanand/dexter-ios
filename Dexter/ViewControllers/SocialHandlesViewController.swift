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
    
    /* MARK: Views */
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cardContainer: UIView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var twitterHandlePlaceholderView: UIView!
    @IBOutlet weak var instagramHandlePlaceholderView: UIView!
    
    /* MARK: Image Views */
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var twitterSmallImageView: UIImageView!
    @IBOutlet weak var twitterLargeImageView: UIImageView!
    @IBOutlet weak var instagramSmallImageView: UIImageView!
    @IBOutlet weak var instagramLargeImageView: UIImageView!

    
    /* MARK: Buttons */
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    
    /* MARK: Labels */
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var uploadPhotoLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    /* MARK: Text Views */
    @IBOutlet weak var messageSubtitleTextView: DisplayTextView!
    @IBOutlet weak var aboutTextView: DisplayTextView!
    
    /* MARK: Text Fields */
    @IBOutlet weak var twitterHandleTextField: UITextField!
    @IBOutlet weak var instagramHandleTextField: UITextField!

    let photoHelper = SelectPhotoHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
//        setupDummyData()
        setupRecognizer()
        setupKeyboardNotifications()
        
        photoHelper.completionHandler = { image in
            self.profilePhotoImageView.image = image
            self.uploadPhotoLabel.text = ""
            UserModelController.updateProfilePhoto(image: image) { (response) in
                switch response {
                case .success(let message):
                    print("[SocialHandlesViewController] \(message)")
                case .failure(let error):
                    let errorAlert = Render.singleActionAlert(title: "Error Occurred", message: error.localizedDescription)
                    self.present(errorAlert, animated: true, completion: nil)
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(SocialHandlesViewController.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SocialHandlesViewController.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if self.contentView.frame.origin.y == 0 {
            self.contentView.frame.origin.y -= keyboardFrame.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.contentView.frame.origin.y != 0 {
            self.contentView.frame.origin.y = 0
        }
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        let handles: [String : Any] = ["twitterHandle": twitterHandleTextField.text!,
                                       "instagramHandle": instagramHandleTextField.text!]
        UserModelController.updateUser(newUserData: handles) { (response) in
            switch response {
            case .success( _):
                self.transitionToDiscovery()
                return
            
            case .failure(let err):
                print(err.localizedDescription)
                let alertController = UIAlertController(title: "Error Occurred", message: "Could not save your details. Please try again.", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
                alertController.setTint(color: .white)
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
            let homeContainerVC = storyboard.instantiateViewController(identifier: Constants.Storyboard.homeSidebarContainerController)
            self.view.window?.rootViewController = homeContainerVC
            self.view.window?.makeKeyAndVisible()
        }
    }
    
    func setupElements() {
        let backgroundColor = Theme.Color.darkBg
        self.view.backgroundColor = backgroundColor
        
        /* MARK: Views */
        scrollView.showsVerticalScrollIndicator = false
        
        contentView.backgroundColor = backgroundColor
                
        let placeholderCornerRadius: CGFloat = 10
        twitterHandlePlaceholderView.layer.cornerRadius = placeholderCornerRadius
        twitterHandlePlaceholderView.backgroundColor = backgroundColor
        
        instagramHandlePlaceholderView.layer.cornerRadius = placeholderCornerRadius
        instagramHandlePlaceholderView.backgroundColor = backgroundColor

        Render.renderUserCardElements(cardContainer: cardContainer, separator: separatorView, profilePhoto: profilePhotoImageView, twitterLogo: twitterSmallImageView, instagramLogo: instagramSmallImageView, fullName: fullNameLabel, email: emailLabel, bio: aboutTextView, twitterHandle: nil, instagramUsername: nil)
        
        
        /* MARK: Image Views */
        let twitterLogo = UIImage(named: "twitter-logo-blue")
        twitterLargeImageView.image = twitterLogo
        twitterLargeImageView.contentMode = .scaleAspectFit
        
        let instagramLogo = UIImage(named: "instagram-logo")
        instagramLargeImageView.image = instagramLogo
        instagramLargeImageView.contentMode = .scaleAspectFit
        
        profilePhotoImageView.backgroundColor = backgroundColor
        
        
        /* MARK: Buttons */
        Render.styleBackButton(backButton)
        
        Render.styleFilledButton(skipButton)
        skipButton.backgroundColor = Theme.Color.dRed
        Render.styleFilledButton(saveButton)
        
        
        /* MARK: Labels */
        Render.labelTitle(titleLabel)
        
        uploadPhotoLabel.font = UIFont(name: Theme.Font.sansSerifRegular, size: 17)
        uploadPhotoLabel.textColor = .darkGray
        uploadPhotoLabel.text = "Upload Photo"
        
        
        /* MARK: Text Views */
        Render.textViewSubtitle(messageSubtitleTextView)
        
        messageSubtitleTextView.backgroundColor = backgroundColor

        
        /*MARK: Text Fields */
        let placeholderFont = UIFont(name: Theme.Font.sansSerifRegular, size: 15)!
        let placeholderAttributes = [NSAttributedString.Key.font: placeholderFont]
        
        Render.styleTextField(twitterHandleTextField)
        twitterHandleTextField.attributedPlaceholder = NSAttributedString(string: "Your Twitter handle", attributes: placeholderAttributes)
        twitterHandleTextField.autocorrectionType = .no
        
        Render.styleTextField(instagramHandleTextField)
        instagramHandleTextField.attributedPlaceholder = NSAttributedString(string: "Your Instagram username", attributes: placeholderAttributes)
        instagramHandleTextField.autocorrectionType = .no
        
        
        /// setup data
        fullNameLabel.text = User.current.firstName + " " + User.current.lastName
        aboutTextView.text = User.current.about
        emailLabel.text = User.current.email
        
        messageSubtitleTextView.adjustsFontForContentSizeCategory = true
        //        messageSubtitleTextView.minimumZoomScale = 0.2
        
    }
    
    func setupDummyData() {
        fullNameLabel.text = "Sunchit Anand"
        aboutTextView.text = "SWE at Oracle, Bay Area. Deep into skiing, chess and space. Looking to connect with PMs and professionals working on autonomous vehiclesSWE at Oracle, Bay Area. Deep into skiing, chess and space. Looking to connect with PMs and professionals working on autonomous vehicles."
        emailLabel.text = "sunchit.anand@gmail.com"
    }
}

extension SocialHandlesViewController: UITextFieldDelegate {
    /// Called when 'return' key pressed. return NO to ignore.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    /// Called when the user click on the view (outside the UITextField).
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setupRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.touch))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(recognizer)
    }
    
    @objc func touch() {
        self.view.endEditing(true)
    }
}
