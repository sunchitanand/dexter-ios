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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var changePhotoLabel: UILabel!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var twitterLabel: UILabel!
    @IBOutlet weak var twitterTextField: UITextField!
    @IBOutlet weak var instagramLabel: UILabel!
    @IBOutlet weak var instagramTextField: UITextField!
    @IBOutlet weak var GNSLabel: UILabel!
    @IBOutlet weak var GNSPermissionSwitch: UISwitch!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    let firebaseAuth = Auth.auth()
    var nearbyPermission: GNSPermission!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        print("appeared")
        
        /** Permission change listener */
        nearbyPermission = GNSPermission(changedHandler: { [unowned self] (isGranted) in
            print("Permission Handler in Settings [Message]: \(isGranted) ")
            
            /// TODO: if isGranted is true, then toggle Permission switch to ON programatically
        })
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        do { try firebaseAuth.signOut() }
        catch let signOutError as NSError {
            /// TODO: Handle error
            print(signOutError.localizedDescription)
        }
        transitionToAuthenticationScreen()
    }
    
    
    @IBAction func GNSPermissionSwitchToggled(_ sender: Any) {
        if GNSPermissionSwitch.isOn {
            GNSPermission.setGranted(true)
            print("Permission Switch: ALLOW")
        } else {
            GNSPermission.setGranted(false)
            print("Permission Switch: DENY")
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        restoreUserDetails()
        self.tabBarController?.selectedIndex = 0
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
    
    func transitionToAuthenticationScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        DispatchQueue.main.async {
            let authProvidersVC = storyboard.instantiateViewController(identifier: Constants.Storyboard.authenticationNavigationController) as? UINavigationController
            self.view.window?.rootViewController = authProvidersVC
            self.view.window?.makeKeyAndVisible()
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
        
        self.view.backgroundColor = Theme.Color.darkBg
        scrollView.backgroundColor = Theme.Color.darkBg
        contentView.backgroundColor = Theme.Color.darkBg
        
        Style.styleBackButton(signOutButton)
        Style.labelTitle(settingsLabel)
        
        Style.textFieldLabel(changePhotoLabel)
        Style.profilePhotoImageView(profilePhotoImageView)
        
        Style.textFieldLabel(nameLabel)
        Style.styleTextField(nameTextField)
        
        Style.textFieldLabel(emailLabel)
        Style.styleTextField(emailTextField)
        
        Style.textFieldLabel(aboutLabel)
        Style.aboutTextView(aboutTextView)
        aboutTextView.font = UIFont(name: Theme.Font.sansSerifRegular, size: 17)
        
        Style.textFieldLabel(twitterLabel)
        Style.styleTextField(twitterTextField)
        
        Style.textFieldLabel(instagramLabel)
        Style.styleTextField(instagramTextField)
        
        Style.textFieldLabel(GNSLabel)
        Style.styleSwitch(GNSPermissionSwitch)
        
        Style.styleFilledButton(cancelButton)
        cancelButton.backgroundColor = Theme.Color.dRed
        Style.styleFilledButton(saveButton)
        
        restoreUserDetails()
        
        setupTextFields()
        
    }
}
