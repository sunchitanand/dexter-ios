//
//  SettingsViewController.swift
//  Dexter
//
//  Created by Sunchit Anand on 1/25/20.
//  Copyright © 2020 Sunchit Anand. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    /* MARK: Views */
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    
    /* MARK: Buttons */
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var changePhotoButton: UIButton!
    
    /* MARK: Labels */
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var changePhotoLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var twitterLabel: UILabel!
    @IBOutlet weak var instagramLabel: UILabel!
    
    /* MARK: Text Fields */
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var twitterTextField: UITextField!
    @IBOutlet weak var instagramTextField: UITextField!
    
    let firebaseAuth = Auth.auth()
    var nearbyPermission: GNSPermission!
    
    let photoHelper = SelectPhotoHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loading Settings View Controller...")
        setupElements()
        aboutTextView.delegate = self
        
        photoHelper.completionHandler = { image in
            self.profilePhotoImageView.image = image
            UserModelController.updateProfilePhoto(image: image)
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        restoreUserDetails()
//        self.tabBarController?.selectedIndex = 0
        transitionToHome()
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        let first = String((nameTextField.text?.split(separator: " ").first)!)
        let last = String((nameTextField.text?.split(separator: " ").last)!)
        print(first, last)
        let about = aboutTextView.text
        
        let userData = [Fields.User.firstName: first,
                        Fields.User.lastName: last,
                        Fields.User.about: about!,
                        Fields.User.email: self.emailTextField.text!,
                        Fields.User.twitterHandle: twitterTextField.text!,
                        Fields.User.instagramHandle: instagramTextField.text!] as [String : Any]
        
        UserModelController.updateUser(newUserData: userData as [String : Any]) { (response) in
            switch response {
            case .success(_):
                print("User Settings updated!")
            case .failure(let err):
                print("Error updating user settings: \(err.localizedDescription)")
            }
        }
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func changePhotoTapped(_ sender: Any) {
        photoHelper.presentActionSheet(from: self)
    }
    
    @IBAction func backTapped(_ sender: Any) {
        transitionToHome()
    }
    
    func transitionToHome() {
        let storyboard = UIStoryboard(name: "Discovery", bundle: nil)
        DispatchQueue.main.async {
            let homeVC = storyboard.instantiateViewController(identifier: Constants.Storyboard.discoveryNavigationController) as! UINavigationController
            //            self.view.window?.rootViewController = homeVC
            //            self.view.window?.makeKeyAndVisible()
            self.sideMenuController?.setContentViewController(to: homeVC)
        }
    }
    
    func restoreUserDetails() {
        nameTextField.text = User.current.firstName + " " + User.current.lastName
        emailTextField.text = User.current.email
        aboutTextView.text = User.current.about
        twitterTextField.text = User.current.twitterHandle
        instagramTextField.text = User.current.instagramHandle
        /*
         profilePhotoImageView.image = UserModelController.fetchFromFileSystem(relativePath: "profilePhotos", uid: User.current.uid)
         
         let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
         let localURL = documentsURL.appendingPathComponent("profile-pictures/\(User.current.uid)")
         print(localURL)
         if FileManager.default.fileExists(atPath: localURL.absoluteString) {
         let imageData = try! Data(contentsOf: localURL)
         let image = UIImage(data: imageData)
         print("Image: \(image.debugDescription)")
         profilePhotoImageView.image = image
         } else {
         print("File does not exist in file system.")
         }
         
         UserModelController.downloadProfilePhoto(uid: User.current.uid) { (result) in
         switch result {
         case .success(_):
         UserModelController.readFromFileSystem(relativePath: "profile-pictures", uid: User.current.uid) { (image) in
         self.profilePhotoImageView.image = image
         }
         case .failure(_):
         print("error downloading")
         }
         }
         */
        
        UserModelController.readFromFileSystem(relativePath: "profile-pictures", uid: User.current.uid) { (image) in
            self.profilePhotoImageView.image = image
        }
        
        /* UserModelController.downloadProfilePhoto(uid: User.current.uid) { (result) in
         switch result {
         case .success(let imageFileURL):
         let imageData = try! Data(contentsOf: imageFileURL)
         let image = UIImage(data: imageData)
         DispatchQueue.main.async {
         self.profilePhotoImageView.image = image
         
         }
         print("URL2", imageFileURL.absoluteString)
         print("Image: ", image!)
         
         case .failure(let err):
         print("Firebase Download Error: \(err.localizedDescription)")
         }
         }
         
         UserModelController.readFromFileSystem(relativePath: "profile-pictures", uid: User.current.uid) { (image) in
         DispatchQueue.main.async {
         self.profilePhotoImageView.image = image
         
         }
         } */
        
        /*
         UserModelController.downloadProfilePhoto(uid: User.current.uid) { (result) in
         switch result {
         case .success(let imageFileURL):
         DispatchQueue.main.async {
         UserModelController.readFromFileSystem(relativePath: "profile-pictures", uid: User.current.uid) { (image) in
         self.profilePhotoImageView.image = image
         }
         }
         case .failure(let err):
         print("Firebase Download Error: \(err.localizedDescription)")
         }
         } */
        
    }
    
    func setupTextFields() {
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: self.view.frame.size.width, height: 38)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(title: "Dismiss", style: .done, target: self, action: #selector(doneActionButton))
        
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
        nameTextField.inputAccessoryView = toolbar
        aboutTextView.inputAccessoryView = toolbar
        emailTextField.inputAccessoryView = toolbar
        twitterTextField.inputAccessoryView = toolbar
        instagramTextField.inputAccessoryView = toolbar
    }
    @objc func doneActionButton() {
        self.view.endEditing(true)
    }
    
    func setupElements() {
        let backgroundColor = Theme.Color.darkBg
        self.view.backgroundColor = backgroundColor
        scrollView.backgroundColor = backgroundColor
        contentView.backgroundColor = backgroundColor
        
        /* MARK: Buttons */
        Render.styleBackButton(backButton)
        
        Render.styleFilledButton(cancelButton)
        cancelButton.backgroundColor = Theme.Color.dRed
        
        Render.styleFilledButton(saveButton)
        
        
        /* MARK: Labels */
        Render.labelTitle(settingsLabel)
        Render.textFieldLabel(changePhotoLabel)
        Render.textFieldLabel(nameLabel)
        Render.textFieldLabel(emailLabel)
        Render.textFieldLabel(aboutLabel)
        Render.textFieldLabel(twitterLabel)
        Render.textFieldLabel(instagramLabel)
        
        /* MARK: Text Fields */
        Render.styleTextField(nameTextField)
        Render.styleTextField(emailTextField)
        Render.styleTextField(twitterTextField)
        Render.styleTextField(instagramTextField)
        setupTextFields()
        
        /* MARK: Text Views */
        Render.enterBioTextView(aboutTextView)
        aboutTextView.font = UIFont(name: Theme.Font.sansSerifRegular, size: 17)
        
        /* MARK: Views*/
        Render.profilePhotoImageView(profilePhotoImageView)
        
        restoreUserDetails()
    }
}

extension SettingsViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print("chars \(textView.text.count) \( text)")
        
//        self.adjustFrames()
        let maxTextCount = 350
        if(textView.text.count > maxTextCount && range.length == 0) {
            print("Please summarize in \(maxTextCount) characters or less")
            return false;
        }
        return true;
    }
    
    func adjustFrames() {
        var textFrame = aboutTextView.frame
        textFrame.size.height = aboutTextView.contentSize.height
        aboutTextView.frame = textFrame
    }
}
