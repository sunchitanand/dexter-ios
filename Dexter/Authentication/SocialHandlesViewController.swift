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
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageSubtitleTextView: DisplayTextView!
    
    @IBOutlet weak var cardContainer: UIView!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var aboutTextView: DisplayTextView!
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
        setupDummyData()
        setupRecognizer()
        setupKeyboardNotifications()
        
        photoHelper.completionHandler = { image in
            self.profilePhotoImageView.image = image
            UserModelController.updateProfilePhoto(image: image)
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
            let homeContainerVC = storyboard.instantiateViewController(identifier: Constants.Storyboard.homeSidebarContainerController)
            self.view.window?.rootViewController = homeContainerVC
            self.view.window?.makeKeyAndVisible()
        }
    }
    
    func setupElements() {
        let backgroundColor = Theme.Color.darkBg
        
        /* MARK: Views */
        scrollView.showsVerticalScrollIndicator = false
        
        let placeholderCornerRadius: CGFloat = 10
        twitterHandlePlaceholderView.layer.cornerRadius = placeholderCornerRadius
        twitterHandlePlaceholderView.backgroundColor = backgroundColor
        instagramHandlePlaceholderView.layer.cornerRadius = placeholderCornerRadius
        instagramHandlePlaceholderView.backgroundColor = backgroundColor

        Style.renderUserCardElements(cardContainer: cardContainer, separator: separatorView, profilePhoto: profilePhotoImageView, twitterLogo: twitterSmallImageView, instagramLogo: instagramSmallImageView, fullName: fullNameLabel, email: emailLabel, bio: aboutTextView, twitterHandle: nil, instagramUsername: nil)
        
        /* MARK: Image Views */
        let twitterLogo = UIImage(named: "twitter-logo-blue")
        let instagramLogo = UIImage(named: "instagram-logo")
    
        twitterLargeImageView.image = twitterLogo
        instagramLargeImageView.image = instagramLogo
        instagramLargeImageView.contentMode = .scaleAspectFit
        instagramSmallImageView.contentMode = .scaleAspectFit
        
        
        /* MARK: Buttons */
        Style.styleBackButton(backButton)
        
        Style.styleFilledButton(skipButton)
        skipButton.backgroundColor = Theme.Color.redOff
        Style.styleFilledButton(saveButton)
        
        
        /* MARK: Labels */
        Style.labelTitle(titleLabel)
        
        /* MARK: Text Views */
        Style.textViewSubtitle(messageSubtitleTextView)

        
        /*MARK: Text Fields */
        let placeholderFont = UIFont(name: Theme.Font.sansSerifRegular, size: 15)!
        let placeholderAttributes = [NSAttributedString.Key.font: placeholderFont]
        
        Style.styleTextField(twitterHandleTextField)
        twitterHandleTextField.attributedPlaceholder = NSAttributedString(string: "your Twitter handle", attributes: placeholderAttributes)
        
        Style.styleTextField(instagramHandleTextField)
        instagramHandleTextField.attributedPlaceholder = NSAttributedString(string: "your Instagram username", attributes: placeholderAttributes)
        
        
        /// setup data
        fullNameLabel.text = User.current.firstName + " " + User.current.lastName
        aboutTextView.text = User.current.about
        emailLabel.text = User.current.email
        
        messageSubtitleTextView.adjustsFontForContentSizeCategory = true
        //        messageSubtitleTextView.minimumZoomScale = 0.2
        
        /// Dark Mode
        self.view.backgroundColor = backgroundColor
        contentView.backgroundColor = backgroundColor
        messageSubtitleTextView.backgroundColor = backgroundColor
        
    }
    
    func setupDummyData() {
        fullNameLabel.text = "Sunchit Anand"
        aboutTextView.text = "SWE at Oracle, Bay Area. Deep into skiing, chess and space. Looking to connect with PMs and professionals working on autonomous vehicles."
        emailLabel.text = "sunchit.anand@gmail.com"
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
    /*
     func textFieldDidBeginEditing(_ textField: UITextField) {
     print("Entering twitter handle...")
     //1. Create the alert controller.
     let alert = UIAlertController(title: "Twitter", message: "Share your Twitter handle on your Dexter", preferredStyle: .alert)
     
     //2. Add the text field. You can configure it however you need.
     alert.addTextField { (textField) in
     textField.text = ""
     }
     
     // 3. Grab the value from the text field, and print it when the user clicks OK.
     alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
     let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
     print("Text field: \(String(describing: textField.text))")
     }))
     // 4. Present the alert.
     self.present(alert, animated: true, completion: nil)
     textField.becomeFirstResponder()
     }
     */
}
