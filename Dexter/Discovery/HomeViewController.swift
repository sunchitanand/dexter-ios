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
import CoreBluetooth
import os

class HomeViewController: UIViewController {
    
    @IBOutlet weak var userContactTableView: UITableView!
    @IBOutlet weak var discoverySwitch: UISwitch!
    @IBOutlet weak var discoveryLabel: UILabel!
    @IBOutlet weak var discoveryStatusLabel: UILabel!
    @IBOutlet weak var userContactTableViewHeaderView: UIView!
    @IBOutlet weak var tableViewHeaderSeparator: UIView!
    
    var nearbyPermission: GNSPermission!
    var messageMgr: GNSMessageManager?
    var publication: GNSPublication?
    var subscription: GNSSubscription?
    
    let firebaseAuth = Auth.auth()
    let db = Firestore.firestore()
    
    var isStatusBarHidden: Bool = false
    
    var container: NSPersistentContainer!
    
    var incomingUserIds: [String] = []
    var nearbyUsers : [User] = []
    var currentUserId: String!
    
    // just for simulating Google Nearby
    var allUsers : [User] = []
    var counter : Int = 0
    
    let discoveryOffMessage = "Turn on to be discovered by people in the same room"
    let discoveryOnMessage = "Turn off to stop discovery"
    let emptyViewControllerMessage = "People near you, right now, will appear here."
    let emptyViewControllerSubtitle = "Swipe <- to delete card."
    
    private var peripheralManager: CBPeripheralManager?
    private var centralManager: CBCentralManager?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        setupElements()
        self.currentUserId = firebaseAuth.currentUser?.uid
//        initializePermissionChangeListener()
//        setupGNSMessageManager()
        
        // persist uid and fetch from firestore
        print(currentUserId!)
        
        /// Get user when app directly opens to Discovery screen
        if !User.doesCurrentUserExist() {
            // get user - UserModelController
            UserModelController.getCurrentUser() { (response) in
                switch response {
                case .success(let user):
                    print("Current user: \(user.email)")
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
        }
            
        else {
            print(User.current)
        }
        
        
        /// FOR SIMULATION:
        /// Get all users and store in allUsers[]
        /*
         counter = 0
         UserModelController.getAllUsers { (response) in
         switch response {
         case .success(let userList):
         self.allUsers = userList
         print("All users successfully fetched")
         case .failure(let err):
         print("Firestore: Error getting all users | \(err.localizedDescription)")
         }
         }
         */
        
        // print(User.current.dictionary)
        // Theme.showFonts()
        
//        UserModelController.getUser(uid: "crLLIUZAsoQowZyijRA5NK31JC92", current: false) { (_) in }
    }
    
    @IBAction func discoverySwitchToggled(_ sender: Any) {
        toggleStatusBarColor()
        
        if discoverySwitch.isOn {
            print("Discovery: On")
            userContactTableViewHeaderView.backgroundColor = Theme.Color.dGreen
            discoveryStatusLabel.text = discoveryOnMessage
            // let msg = String(format:"User %d says hi!", arc4random() % 100)
            
            /// uncomment when google nearby works
            //            startSharing(withName: self.currentUserId)
            
            /*
             bluetoothManager.startAdvertising(with: User.current.uid)
             bluetoothManager.delegate = self
             */
            
            peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
            centralManager = CBCentralManager(delegate: self, queue: nil)
            
            /** FOR SIMULATION */
            /// Transfer a user from allUsers to nearbyUsers[] and increment pointer
            /*
             if counter < allUsers.count {
             print(allUsers[counter])
             nearbyUsers.append(allUsers[counter])
             counter += 1
             }
             else {
             print("No more users nearby")
             }
             */
            
            self.userContactTableView.reloadData()
        } else {
            print("Discovery: Off")
            userContactTableViewHeaderView.backgroundColor = Theme.Color.dGreen
            discoveryStatusLabel.text = discoveryOffMessage
            /// uncomment for Nearby
            //            stopSharing()
        }
        userContactTableViewHeaderView.backgroundColor = discoverySwitch.isOn ? Theme.Color.dGreen : Theme.Color.dRed
    }
    
    /* MARK: UI Elements Setup */
    
    func stopSharing() {
        publication = nil
        subscription = nil
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupElements() {
        //        Styles.styleFilledButton(permissionToggleButton)
        Style.styleSwitch(discoverySwitch)
        Style.discoveryTitleLabel(discoveryLabel)
        discoveryStatusLabel.font = UIFont(name: Theme.Font.sansSerifRegular, size: 16)
        discoveryStatusLabel.textColor = .black
        //        Styles.headerSubtitle(discoveryStatusLabel)
        if discoverySwitch.isOn {
            userContactTableViewHeaderView.backgroundColor = Theme.Color.dGreen
            discoveryStatusLabel.text = discoveryOnMessage
        }
        else {
            userContactTableViewHeaderView.backgroundColor = Theme.Color.dRed
            discoveryStatusLabel.text = discoveryOffMessage
        }
        setupTableView()
        toggleStatusBarColor()
        
        //        var customTabBarItem: UITabBarItem = UITabBarItem(title: nil, image: UIImage(named: "YOUR_IMAGE_NAME")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "YOUR_IMAGE_NAME"))
        //        self.tabBarItem = customTabBarItem
    }
    
    override var prefersStatusBarHidden: Bool {
        return self.isStatusBarHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    func toggleStatusBarColor() {
        if self.navigationController!.navigationBar.isHidden == true {
            let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 50.0))
            view.backgroundColor = discoverySwitch.isOn ? Theme.Color.dGreen : Theme.Color.dRed
            self.view.addSubview(view)
            discoveryLabel.bringSubviewToFront(view)
        }
    }
    
    /** Not being used */
    func changeStatusBar() {
        if #available(iOS 13.0, *) {
            //            let app = UIApplication.shared
            let statusBarHeight: CGFloat = (self.view.window?.windowScene?.statusBarManager?.statusBarFrame.size.height) ?? CGFloat.zero
            print(statusBarHeight)
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = UIColor.red
            view.addSubview(statusbarView)
            
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
            
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = UIColor.red
        }
    }
}

/* MARK: TableViewController  */

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    /** Return how many rows the table view should show */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if nearbyUsers.count == 0 {
            userContactTableView.setEmptyView(title: emptyViewControllerMessage, message: emptyViewControllerSubtitle)
        }
        else {
            userContactTableView.restore()
        }
        return nearbyUsers.count
    }
    
    /** Configure each cell - runs everytime a new cell appears */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let nearbyUser = nearbyUsers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserContactCell") as! UserContactCell
        
        cell.setUserContact(user: nearbyUser)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = nearbyUsers[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileVC = storyboard.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        profileVC.selectedUser = selectedUser
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    
    func setupTableView() {
        userContactTableView.delegate = self
        userContactTableView.dataSource = self
        userContactTableView.sectionHeaderHeight = 70
        userContactTableView.tableFooterView = UIView()
        /*
         userContactTableView.separatorStyle = .none
         userContactTableView.separatorColor = Theme.Color.separator
         */
        userContactTableView.contentInsetAdjustmentBehavior = .never
        
        let background = Theme.Color.darkBg
        userContactTableView.backgroundColor = background
        tableViewHeaderSeparator.backgroundColor = background
    }
}

/*
 extension HomeViewController: BluetoothManagerDelegate {
 func peripheralsDidUpdate() {
 print("Peripheral Did Update: \(bluetoothManager.peripherals.mapValues{$0.name})")
 
 }
 } */

/* MARK: Peripheral Manager*/
extension HomeViewController: CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            if peripheral.isAdvertising {
                peripheral.stopAdvertising()
            }
            
            var advertisingData: [String : Any] = [
                CBAdvertisementDataServiceUUIDsKey: [TransferService.serviceUUID]
            ]
            
            advertisingData[CBAdvertisementDataLocalNameKey] = User.current.uid
            print(User.current.uid)
            //            if let uid = User.current.uid {
            //                advertisingData[CBAdvertisementDataLocalNameKey] = uid
            //            }
            print("Starting Advertising")
            self.peripheralManager?.startAdvertising(advertisingData)
            print("Advertisement started [\(String(describing: advertisingData[CBAdvertisementDataLocalNameKey]))]")
        } else {
            #warning("handle other states")
        }
    }
}

/* MARK: Central Manager*/
extension HomeViewController: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            
            if central.isScanning {
                central.stopScan()
            }
            
//            central.scanForPeripherals(withServices: [TransferService.serviceUUID])
            central.scanForPeripherals(withServices: [TransferService.serviceUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
        } else {
            #warning("Error handling")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        
        //        peripherals[peripheral.identifier] = peripheral
        let incomingUserId = advertisementData[CBAdvertisementDataLocalNameKey] as? String
        
        if let incomingUserId = incomingUserId {
            print("User \(incomingUserId) discovered")
            self.incomingUserIds.append(incomingUserId)

            var newIncomingUser: User!
            UserModelController.getUser(uid: incomingUserId) { (response) in
                switch response {
                case .success(let user):
                    newIncomingUser = user
                    self.nearbyUsers.append(newIncomingUser)
                    print("Discovered user saved")
                    self.userContactTableView.reloadData()
                case .failure(_):
                    break
                }
            }
        }
    }
}
