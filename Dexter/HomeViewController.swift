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
import CoreData

class HomeViewController: UIViewController {
    
    @IBOutlet weak var createDummyPostButton: UIButton!
    @IBOutlet weak var discoveryToggleButton: DiscoveryToggleButton!
    @IBOutlet weak var permissionToggleButton: DiscoveryToggleButton!
    @IBOutlet weak var userContactTableView: UITableView!
    
    var nearbyPermission: GNSPermission!
    var messageMgr: GNSMessageManager?
    var publication: GNSPublication?
    var subscription: GNSSubscription?
    
    let firebaseAuth = Auth.auth()
    let db = Firestore.firestore()
    
    var container: NSPersistentContainer!

    var usernames: [String] = []
    var currentUserId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        
        self.currentUserId = firebaseAuth.currentUser?.uid
        
        /** Permission change listener */
        nearbyPermission = GNSPermission(changedHandler: { [unowned self] (isGranted) in
            print("granted: \(isGranted) ")
        })
        GNSMessageManager.setDebugLoggingEnabled(true)
        messageMgr = GNSMessageManager(apiKey: Constants.APIKey.nearbyMessages, paramsBlock: { (params) in
            guard let params = params else {return}
            
            /** This is called when microphone permission is enabled or disabled by the user.*/
            params.microphonePermissionErrorHandler = { hasError in
                if (hasError) {
                    print("Nearby works better if microphone use is allowed")
                }
            }
            /** This is called when Bluetooth permission is enabled or disabled by the user. */
            params.bluetoothPermissionErrorHandler = { hasError in
                if (hasError) {
                    print("Nearby works better if Bluetooth use is allowed")
                }
            }
            /** This is called when Bluetooth is powered on or off by the user. */
            params.bluetoothPowerErrorHandler = { hasError in
                if (hasError) {
                    print("Nearby works better if Bluetooth is turned on")
                }
            }
        })
        
        userContactTableView.delegate = self
        userContactTableView.dataSource = self
        
        if container != nil {
            print("Core Data works! :)")
        }
        else {
            print("Doesn't work! :(")
        }
    }
    
    @IBAction func getCurrentUserTapped(_ sender: Any) {
        //        UserModelController.sharedInstance.getUser(uid: "DYT0zIoUO5msrzfV5P8q") { (result) in
        //            switch(result) {
        //            case .success(let user):
        //                print(user.firstName)
        //            case .failure(let err):
        //                print("Error: \(err.localizedDescription)")
        //            }
        //        }
    }
    
    @IBAction func discoveryToggled(_ sender: Any) {
        if discoveryToggleButton.isOn {
            print("Discovery: On")
//            let msg = String(format:"User %d says hi!", arc4random() % 100)
            let msg = User.current.uid!
            startSharing(withName: msg)
        } else {
            print("Discovery: Off")
            stopSharing()
        }
    }
    
    @IBAction func permissionToggled(_ sender: Any) {
        if permissionToggleButton.isOn {
            GNSPermission.setGranted(true)
            print("Permission: ALLOW")
            
            /** delete later */
            self.usernames.append("Sunchit Anand")
            
            self.userContactTableView.reloadData()
        } else {
            GNSPermission.setGranted(false)
            print("Permission: DENY")
        }
    }
    
    /**
     Google Nearby
     */
    
    func startSharing(withName name: String) {
        if let messageMgr = self.messageMgr {
            //            messageLabel.text = name
            
            /** Publish the name to nearby devices. */
            let pubMessage: GNSMessage = GNSMessage(content: name.data(using: .utf8, allowLossyConversion: true))
            
            publication = messageMgr.publication(with: pubMessage, paramsBlock: { (params: GNSPublicationParams?) in
                guard let params = params else {return}
                params.permissionRequestHandler = { (permissionHandler: GNSPermissionHandler?) in
                    print("show dialgue")
                }
            })
            
            /** Subscribe to messages from nearby devices and display them in the message view. */
            subscription = messageMgr.subscription(messageFoundHandler: { (message: GNSMessage?) in
                guard let message = message else {return}
                
                let data = message.content!
                let dataString = String(decoding: data, as: UTF8.self)
                
                //                DispatchQueue.main.async {
                //                    self.messageLabel.text = dataString
                //                }
                
                self.usernames.append(dataString)
                self.userContactTableView.reloadData()
                
            }, messageLostHandler: { (message: GNSMessage?) in
                guard let message = message else {return}
                print(message.content!)
            })
        }
    }
    
    func stopSharing() {
        publication = nil
        subscription = nil
        //        messageLabel.text = "Stopped"
    }
    
    func setupElements() {
        Styles.styleFilledButton(permissionToggleButton)
        Styles.styleFilledButton(discoveryToggleButton)
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    /** Return how many rows the table view should show */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernames.count
    }
    
    /** Configure each cell - runs everytime a new cell appears */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let username = usernames[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserContactCell") as! UserContactCell
        cell.setUserContact(username: username)
        
        return cell
    }
    
}
