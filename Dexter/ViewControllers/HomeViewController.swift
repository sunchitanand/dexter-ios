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
import SideMenuSwift

class HomeViewController: UIViewController {
    
    @IBOutlet weak var sideBarButton: UIButton!
    
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
    static var nearbyUsers : [User] = []
    var currentUserId: String!
    
    // just for simulating Google Nearby
    static var allUsers : [User] = []
    var counter : Int = 0
    
    let discoveryOffMessage = "Turn on to be discovered by people around you"
    let discoveryOnMessage = "Turn off to stop discovery"
    let emptyViewControllerMessage = "People around you with Dexter (turned ON) will appear here."
    let emptyViewControllerSubtitle = "Dexter uses Bluetooth for Discovery."
    
    private var peripheralManager: CBPeripheralManager?
    private var centralManager: CBCentralManager?
    
    static var executedOnce = false
    
    override func awakeFromNib() {
        if !HomeViewController.executedOnce {
            HomeViewController.executedOnce = true
            print("Running initial setup...")
            oneTimeSetup()
        }
    }
    
    func oneTimeSetup() {
        self.currentUserId = firebaseAuth.currentUser?.uid
        
        /// Get user when app directly opens to Discovery screen
        if !User.doesCurrentUserExist() {
            // get user - UserModelController
            UserModelController.getCurrentUser() { (response) in
                switch response {
                case .success(let user):
                    print("Current user: \(user.email)")
                    
                case .failure(let err):
                    print(err.localizedDescription)
                    let errorAlert = Render.singleActionAlert(title: "Error Alert", message: "Could not fetch your details. Please try logging in again.")
                    self.present(errorAlert, animated: true, completion: nil)
                }
            }
        }
        else {
            print(User.current)
        }
        
        // persist uid and fetch from firestore
        print(currentUserId!)
        
        /// FOR SIMULATION:
        /// Get all users and store in allUsers[]
        counter = 0
        UserModelController.getAllUsers { (response) in
            switch response {
            case .success(let userList):
                HomeViewController.allUsers = userList
                print("All users successfully fetched")
                
            case .failure(let err):
                print("Firestore: Error getting all users | \(err.localizedDescription)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Number of users stored: ", HomeViewController.allUsers.count)
        setupElements()
        /*
         print(User.current.dictionary)
         Theme.showFonts()
         */
    }
    
    @objc
    @IBAction func sideBarButtonTapped(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
    
    @IBAction func discoverySwitchToggled(_ sender: Any) {
        toggleStatusBarColor()
        
        if discoverySwitch.isOn {
            print("Discovery: On")
            discoveryStatusLabel.text = discoveryOnMessage
            // let msg = String(format:"User %d says hi!", arc4random() % 100)
            
            /** Production Code */
//            startSharing()
            
            
            /** FOR SIMULATION */
            /// Transfer a user from allUsers to nearbyUsers[] and increment pointer
            
            if counter < HomeViewController.allUsers.count {
                print(HomeViewController.allUsers[counter])
                HomeViewController.nearbyUsers.append(HomeViewController.allUsers[counter])
                counter += 1
            } else { print("No more users nearby") }
            
            self.userContactTableView.reloadData()
        }
        else {
            print("Discovery: Off")
            discoveryStatusLabel.text = discoveryOffMessage
            /** Production Code  */
//             stopSharing()
        }
        userContactTableViewHeaderView.backgroundColor = discoverySwitch.isOn ? Theme.Color.dGreen : Theme.Color.dRed
    }
    

    func startSharing() {
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func stopSharing() {
        publication = nil
        subscription = nil
    }
    
    
    /* MARK: UI Elements Setup */
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    func setupElements() {
        /* MARK: Buttons*/
        //        Styles.styleFilledButton(permissionToggleButton)
        
        let menuImg = UIImage(named: "baseline_menu_black_24pt")?.withRenderingMode(.alwaysOriginal)
        //        sideBarButton.setImage(menuImg, for: .normal)
        //        sideBarButton.imageView?.contentMode = .scaleAspectFill
        sideBarButton.setBackgroundImage(menuImg, for: .normal)
        sideBarButton.contentMode = .scaleAspectFit
        
        /* MARK: Switch*/
        Render.styleSwitch(discoverySwitch)
        
        
        /* MARK: Labels*/
        Render.discoveryTitleLabel(discoveryLabel)
        
        discoveryStatusLabel.font = UIFont(name: Theme.Font.sansSerifMedium, size: 16)
        discoveryStatusLabel.textColor = .black
        discoveryStatusLabel.sizeToFit()
        discoveryStatusLabel.numberOfLines = 0
        
        /* MARK: Views */
        
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
        
        /*
         var customTabBarItem: UITabBarItem = UITabBarItem(title: nil, image: UIImage(named: "YOUR_IMAGE_NAME")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "YOUR_IMAGE_NAME"))
         self.tabBarItem = customTabBarItem
         */
    }
    
    func setupNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.view.setNeedsLayout()
        
        let menuImg = UIImage(named: "round_menu_white_24pt")?.withRenderingMode(.alwaysTemplate)
        
        let menuButton = UIBarButtonItem(image: menuImg, style: .done, target: self, action: #selector(sideBarButtonTapped(_:)))
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.leftBarButtonItem = menuButton
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
    
    /** deprecated  **/
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
        if HomeViewController.nearbyUsers.count == 0 {
            userContactTableView.setEmptyView(title: emptyViewControllerMessage, message: emptyViewControllerSubtitle)
        }
        else {
            userContactTableView.restore()
        }
        return HomeViewController.nearbyUsers.count
    }
    
    /** Configure each cell - runs everytime a new cell appears */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nearbyUser = HomeViewController.nearbyUsers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserContactCell") as! UserContactCell
        cell.setUserContact(user: nearbyUser)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = HomeViewController.nearbyUsers[indexPath.row]
        let storyboard = UIStoryboard(name: "Discovery", bundle: nil)
        let profileVC = storyboard.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        profileVC.selectedUser = selectedUser
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    /// Swipe to delete: delete from objects and table view
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            HomeViewController.nearbyUsers.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
        else if editingStyle == .insert {
            print("New user cell inserted in Table View")
            tableView.insertRows(at: [indexPath], with: .left)
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

/* MARK: Central Manager*/
extension HomeViewController: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case .unknown:
            print("[CentralManager] Bluetooth state: unknown")
            let errorAlert = Render.singleActionAlert(title: "Error Occurred", message: "An error occured while trying to use Bluetooth. Please try again.")
            self.present(errorAlert, animated: true, completion: nil)
        
        case .resetting:
            print("[CentralManager] Bluetooth state: resetting")
            let errorAlert = Render.singleActionAlert(title: "Error Occurred", message: "Please try again.")
            self.present(errorAlert, animated: true, completion: nil)
        
        case .unsupported:
            print("[CentralManager] Bluetooth state: unsupported")
            let errorAlert = Render.singleActionAlert(title: "Bluetooth Unsupported", message: "Bluetooth is not supported on this device.")
            self.present(errorAlert, animated: true, completion: nil)
            
        case .unauthorized:
            print("[CentralManager] Bluetooth state: unauthorized")
            let alertController = UIAlertController (title: "Bluetooth Access Required ", message: "Please allow Dexter to use Bluetooth in Settings.", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            alertController.setTint(color: .white)
            present(alertController, animated: true, completion: nil)
            
        case .poweredOff:
            print("[CentralManager] Bluetooth state: powered OFF")
            
        case .poweredOn:
            print("[CentralManager] Bluetooth state: powered ON")
            if central.isScanning {
                central.stopScan()
            }
            // central.scanForPeripherals(withServices: [TransferService.serviceUUID])
            central.scanForPeripherals(withServices: [TransferService.serviceUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
            
        @unknown default:
            print("[CentralManager] Bluetooth state: defaulted")
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
                    HomeViewController.nearbyUsers.append(newIncomingUser)
                    print("Discovered user saved")
                    self.userContactTableView.reloadData()
                    
                case .failure(_):
                    break
                }
            }
        }
    }
}

/* MARK: Peripheral Manager*/
extension HomeViewController: CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        switch peripheral.state {
        case .unknown:
            print("[PeripheralManager] Bluetooth state: unknown")
        case .resetting:
            print("[PeripheralManager] Bluetooth state: resetting")
        case .unsupported:
            print("[PeripheralManager] Bluetooth state: unsupported")
        case .unauthorized:
            print("[PeripheralManager] Bluetooth state: unauthorized")
            let alertController = UIAlertController (title: "Bluetooth Access Required ", message: "Please allow Dexter to use Bluetooth in Settings.", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            alertController.setTint(color: .white)
            present(alertController, animated: true, completion: nil)
        case .poweredOff:
            print("[PeripheralManager] Bluetooth state: powered OFF")
        case .poweredOn:
            print("[PeripheralManager] Bluetooth state: powered ON")
            if peripheral.isAdvertising {
                peripheral.stopAdvertising()
            }
            var advertisingData: [String : Any] = [
                CBAdvertisementDataServiceUUIDsKey: [TransferService.serviceUUID]
            ]
            advertisingData[CBAdvertisementDataLocalNameKey] = User.current.uid
            print(User.current.uid)
            /*
            if let uid = User.current.uid {
                advertisingData[CBAdvertisementDataLocalNameKey] = uid
            }
             */
            print("Starting Advertising")
            self.peripheralManager?.startAdvertising(advertisingData)
            let advertisingString = String(describing: advertisingData[CBAdvertisementDataLocalNameKey])
            print("Advertisement started [\(advertisingString)]")
        @unknown default:
            print("[PeripheralManager] Bluetooth state: defaulted")
        }
    }
}
