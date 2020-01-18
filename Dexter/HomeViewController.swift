//
//  HomeViewController.swift
//  Dexter
//
//  Created by Sunchit Anand on 12/15/19.
//  Copyright © 2019 Sunchit Anand. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class HomeViewController: UIViewController {
    
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var createDummyPostButton: UIButton!
    @IBOutlet weak var discoveryToggleButton: DiscoveryToggleButton!
    @IBOutlet weak var permissionToggleButton: DiscoveryToggleButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    var nearbyPermission: GNSPermission!
    var messageMgr: GNSMessageManager?
    var publication: GNSPublication?
    var subscription: GNSSubscription?
    
    let firebaseAuth = Auth.auth()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Permission change listener
        nearbyPermission = GNSPermission(changedHandler: { [unowned self] (isGranted) in
            print("granted: \(isGranted) ")
        })
        
        GNSMessageManager.setDebugLoggingEnabled(true)
        
        messageMgr = GNSMessageManager(apiKey: Constants.APIKey.nearbyMessages, paramsBlock: { (params) in
            guard let params = params else {return}
            
            // This is called when microphone permission is enabled or disabled by the user.
            params.microphonePermissionErrorHandler = { hasError in
                if (hasError) {
                    print("Nearby works better if microphone use is allowed")
                }
            }
            // This is called when Bluetooth permission is enabled or disabled by the user.
            params.bluetoothPermissionErrorHandler = { hasError in
                if (hasError) {
                    print("Nearby works better if Bluetooth use is allowed")
                }
            }
            // This is called when Bluetooth is powered on or off by the user.
            params.bluetoothPowerErrorHandler = { hasError in
                if (hasError) {
                    print("Nearby works better if Bluetooth is turned on")
                }
            }
        })
    }
    
    @IBAction func getCurrentUserTapped(_ sender: Any) {
        
        UserModelController.sharedInstance.getUser(uid: "DYT0zIoUO5msrzfV5P8q") { (result) in
            switch(result) {
            case .success(let user):
                print(user.firstName)
            case .failure(let err):
                print("Error: \(err.localizedDescription)")
            }
        }
    }
    
    @IBAction func discoveryToggled(_ sender: Any) {
        if discoveryToggleButton.isOn {
            print("Discovery: On")
            //            let userDict = UserModelController.sharedInstance.getStoredUser()
            //            let message = userDict[Fields.User.firstName] as! String + " says Hi!"
            let msg = String(format:"User %d says hi!", arc4random() % 100)
            startSharing(withName: msg)
        }
        else {
            print("Discovery: Off")
            stopSharing()
        }
    }
    
    @IBAction func permissionToggled(_ sender: Any) {
        if permissionToggleButton.isOn {
            GNSPermission.setGranted(true)
            print("Permission: ALLOW")
        } else {
            GNSPermission.setGranted(false)
            print("Permission: DENY")
        }
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        do {
            try firebaseAuth.signOut()
        }
        catch let signOutError as NSError {
            /// TODO: Handle error
            print(signOutError.localizedDescription)
        }
        transitionToAuthentication()
    }
    
    func startSharing(withName name: String) {
        if let messageMgr = self.messageMgr {
            // Show the name in the message view title
            //            messageLabel.text = name
            
            // Publish the name to nearby devices.
            let pubMessage: GNSMessage = GNSMessage(content: name.data(using: .utf8, allowLossyConversion: true))
            
            publication = messageMgr.publication(with: pubMessage, paramsBlock: { (params: GNSPublicationParams?) in
                guard let params = params else {return}
                params.permissionRequestHandler = { (permissionHandler: GNSPermissionHandler?) in
                    print("show dialgue")
                }
            })
            
            // Subscribe to messages from nearby devices and display them in the message view.
            subscription = messageMgr.subscription(messageFoundHandler: { (message: GNSMessage?) in
                guard let message = message else {return}
                DispatchQueue.main.async {
                    let data = message.content!
                    self.messageLabel.text = String(decoding: data, as: UTF8.self)
                }
                print(message.content!)
                
            }, messageLostHandler: { (message: GNSMessage?) in
                guard let message = message else {return}
                print(message.content!)
            })
        }
    }
    
    func stopSharing() {
        publication = nil
        subscription = nil
        messageLabel.text = "Stopped"
    }
    
    func transitionToAuthentication() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        DispatchQueue.main.async {
            let authProvidersVC = storyboard.instantiateViewController(identifier: Constants.Storyboard.authenticationNavigationController) as? UINavigationController
            self.view.window?.rootViewController = authProvidersVC
            self.view.window?.makeKeyAndVisible()
        }
    }
    
}
