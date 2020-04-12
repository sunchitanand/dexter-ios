////
////  HomeViewController.swift
////  Dexter
////
////  Created by Sunchit Anand on 12/15/19.
////  Copyright © 2019 Sunchit Anand. All rights reserved.
////
//
//import UIKit
//import Firebase
//import FirebaseFirestore
//import CoreData
//import CoreBluetooth
//import os
//
//class HomeViewController: UIViewController {
//
//    @IBOutlet weak var userContactTableView: UITableView!
//    @IBOutlet weak var discoverySwitch: UISwitch!
//    @IBOutlet weak var discoveryLabel: UILabel!
//    @IBOutlet weak var discoveryStatusLabel: UILabel!
//    @IBOutlet weak var userContactTableViewHeaderView: UIView!
//    @IBOutlet weak var tableViewHeaderSeparator: UIView!
//
//    var nearbyPermission: GNSPermission!
//    var messageMgr: GNSMessageManager?
//    var publication: GNSPublication?
//    var subscription: GNSSubscription?
//
//    let firebaseAuth = Auth.auth()
//    let db = Firestore.firestore()
//
//    var isStatusBarHidden: Bool = false
//
//    var container: NSPersistentContainer!
//
//    var incomingUserIds: [String] = []
//    var nearbyUsers : [User] = []
//    var currentUserId: String!
//
//    // just for simulating Google Nearby
//    var allUsers : [User] = []
//    var counter : Int = 0
//
//    let discoveryOffMessage = "Turn on to be discovered by people in the same room"
//    let discoveryOnMessage = "Turn off to stop discovery"
//    let emptyViewControllerMessage = "People near you, right now, will appear here."
//    let emptyViewControllerSubtitle = "Swipe <- to delete card."
//
//    var centralManager: CBCentralManager!
//
//    var discoveredPeripheral: CBPeripheral?
//    var transferCharacteristic: CBCharacteristic?
//    var connectionIterationsComplete = 0
//    var defaultIterations = 5
//
//    override func viewDidLoad() {
//
//        let options = [CBCentralManagerOptionShowPowerAlertKey: true]
//        centralManager = CBCentralManager(delegate: self, queue: nil, options: options)
//
//        super.viewDidLoad()
//
////        centralManager = CBCentralManager(delegate: self, queue: nil)
////        let options = [CBCentralManagerOptionRestoreIdentifierKey: "DexterCentralManager"]
//
//        setupElements()
//        self.currentUserId = firebaseAuth.currentUser?.uid
//        initializePermissionChangeListener()
//        setupGNSMessageManager()
//
//        // persist uid and fetch from firestore
//        print(currentUserId!)
//
//        /// Get user when app directly opens to Discovery screen
//        if !User.doesCurrentUserExist() {
//            // get user - UserModelController
//            UserModelController.getUser(uid: currentUserId, current: true) { (response) in
//                switch response {
//                case .success(_):
//                    print("User fetched from Firestore.")
//                    print(User.current)
//                case .failure(let err):
//                    print(err.localizedDescription)
//                }
//            }
//        }
//
//        else {
//            print(User.current)
//        }
//
//
//        /// FOR SIMULATION:
//        /// Get all users and store in allUsers[]
//        /*
//         counter = 0
//         UserModelController.getAllUsers { (response) in
//         switch response {
//         case .success(let userList):
//         self.allUsers = userList
//         print("All users successfully fetched")
//         case .failure(let err):
//         print("Firestore: Error getting all users | \(err.localizedDescription)")
//         }
//         }
//         */
//
//        // print(User.current.dictionary)
//        // Theme.showFonts()
//    }
//
//    @IBAction func discoverySwitchToggled(_ sender: Any) {
//        toggleStatusBarColor()
//
//        if discoverySwitch.isOn {
//            print("Discovery: On")
//            userContactTableViewHeaderView.backgroundColor = Theme.Color.dGreen
//            discoveryStatusLabel.text = discoveryOnMessage
//            // let msg = String(format:"User %d says hi!", arc4random() % 100)
//
//            /// uncomment when google nearby works
////            startSharing(withName: self.currentUserId)
//
//            /** FOR SIMULATION */
//            /// Transfer a user from allUsers to nearbyUsers[] and increment pointer
//            /*
//             if counter < allUsers.count {
//             print(allUsers[counter])
//             nearbyUsers.append(allUsers[counter])
//             counter += 1
//             }
//             else {
//             print("No more users nearby")
//             }
//             */
//
//
//            self.userContactTableView.reloadData()
//
//        } else {
//            print("Discovery: Off")
//            userContactTableViewHeaderView.backgroundColor = Theme.Color.dGreen
//            discoveryStatusLabel.text = discoveryOffMessage
//            /// uncomment for Nearby
////            stopSharing()
//        }
//        userContactTableViewHeaderView.backgroundColor = discoverySwitch.isOn ? Theme.Color.dGreen : Theme.Color.dRed
//    }
//
//    /* MARK: Google Nearby */
//
//    func initializePermissionChangeListener() {
//        /** Permission change listener */
//        nearbyPermission = GNSPermission(changedHandler: { [unowned self] (isGranted) in
//            print("granted: \(isGranted) ")
//        })
//    }
//
//    func setupGNSMessageManager() {
//        GNSMessageManager.setDebugLoggingEnabled(true)
//        messageMgr = GNSMessageManager(apiKey: Constants.APIKey.nearbyMessages, paramsBlock: { (params) in
//            guard let params = params else {return}
//
//            /** This is called when microphone permission is enabled or disabled by the user.*/
//            params.microphonePermissionErrorHandler = { hasError in
//                if (hasError) { print("Nearby works better if microphone use is allowed") }
//            }
//            /** This is called when Bluetooth permission is enabled or disabled by the user. */
//            params.bluetoothPermissionErrorHandler = { hasError in
//                if (hasError) { print("Nearby works better if Bluetooth use is allowed") }
//            }
//            /** This is called when Bluetooth is powered on or off by the user. */
//            params.bluetoothPowerErrorHandler = { hasError in
//                if (hasError) { print("Nearby works better if Bluetooth is turned on") }
//            }
//        })
//    }
//
//    func startSharing(withName name: String) {
//        print("SHARING!!!!")
//        if let messageMgr = self.messageMgr {
//            //            messageLabel.text = name
//            /** Publish the name to nearby devices. */
//            let pubMessage: GNSMessage = GNSMessage(content: name.data(using: .utf8, allowLossyConversion: true))
//
//            publication = messageMgr.publication(with: pubMessage, paramsBlock: { (params: GNSPublicationParams?) in
//                let data = pubMessage.content!
//                print(String(decoding: data, as: UTF8.self))
//                                guard let params = params else {return}
//                                params.permissionRequestHandler = { (permissionHandler: GNSPermissionHandler?) in
//                                    print("show dialogue")
//                                }
//            })
//            /** Subscribe to messages from nearby devices and display them in the message view. */
//            subscription = messageMgr.subscription(messageFoundHandler: { (message: GNSMessage?) in
//                guard let message = message else {return}
//                print("MESSAGE RECEIVED!")
//                let data = message.content!
//                let newIncomingUserId = String(decoding: data, as: UTF8.self)
//                self.incomingUserIds.append(newIncomingUserId)
//
//                /// Fetch from Firestore and append into nearbyUsers[]
//                UserModelController.getUser(uid: newIncomingUserId, current: false) { (response) in
//                    switch response {
//                    case .success(let newIncomingUser):
//                        print("added")
//                        self.nearbyUsers.append(newIncomingUser)
//                    case .failure(let err):
//                        print("Firestore Error: \(err.localizedDescription)")
//                    }
//                }
//                self.userContactTableView.reloadData()
//
//            }, messageLostHandler: { (message: GNSMessage?) in
//                guard let message = message else {return}
//                print(message.content!)
//            },
//               paramsBlock:{ (params: GNSSubscriptionParams?) in
//                guard let params = params else { return }
//                params.strategy = GNSStrategy(paramsBlock: { (params: GNSStrategyParams?) in
//                    guard let params = params else { return }
//                    print("Google Nearby: Background Mode Turned On")
//                    params.allowInBackground = true
//                    params.discoveryMediums = .BLE
//                })
//            })
//        }
//    }
//
//    /* MARK: UI Elements Setup */
//
//    func stopSharing() {
//        publication = nil
//        subscription = nil
//    }
//
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
//
//    func setupElements() {
//        //        Styles.styleFilledButton(permissionToggleButton)
//        Style.styleSwitch(discoverySwitch)
//        Style.discoveryTitleLabel(discoveryLabel)
//        discoveryStatusLabel.font = UIFont(name: Theme.Font.sansSerifRegular, size: 16)
//        discoveryStatusLabel.textColor = .black
//        //        Styles.headerSubtitle(discoveryStatusLabel)
//        if discoverySwitch.isOn {
//            userContactTableViewHeaderView.backgroundColor = Theme.Color.dGreen
//            discoveryStatusLabel.text = discoveryOnMessage
//        }
//        else {
//            userContactTableViewHeaderView.backgroundColor = Theme.Color.dRed
//            discoveryStatusLabel.text = discoveryOffMessage
//        }
//        setupTableView()
//        toggleStatusBarColor()
//
//        //        var customTabBarItem: UITabBarItem = UITabBarItem(title: nil, image: UIImage(named: "YOUR_IMAGE_NAME")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "YOUR_IMAGE_NAME"))
//        //        self.tabBarItem = customTabBarItem
//    }
//
//    override var prefersStatusBarHidden: Bool {
//        return self.isStatusBarHidden
//    }
//
//    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
//        return .slide
//    }
//
//    func toggleStatusBarColor() {
//        if self.navigationController!.navigationBar.isHidden == true {
//            let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 50.0))
//            view.backgroundColor = discoverySwitch.isOn ? Theme.Color.dGreen : Theme.Color.dRed
//            self.view.addSubview(view)
//            discoveryLabel.bringSubviewToFront(view)
//        }
//    }
//
//    /** Not being used */
//    func changeStatusBar() {
//        if #available(iOS 13.0, *) {
//            //            let app = UIApplication.shared
//            let statusBarHeight: CGFloat = (self.view.window?.windowScene?.statusBarManager?.statusBarFrame.size.height) ?? CGFloat.zero
//            print(statusBarHeight)
//
//            let statusbarView = UIView()
//            statusbarView.backgroundColor = UIColor.red
//            view.addSubview(statusbarView)
//
//            statusbarView.translatesAutoresizingMaskIntoConstraints = false
//            statusbarView.heightAnchor
//                .constraint(equalToConstant: statusBarHeight).isActive = true
//            statusbarView.widthAnchor
//                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
//            statusbarView.topAnchor
//                .constraint(equalTo: view.topAnchor).isActive = true
//            statusbarView.centerXAnchor
//                .constraint(equalTo: view.centerXAnchor).isActive = true
//
//        } else {
//            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
//            statusBar?.backgroundColor = UIColor.red
//        }
//    }
//}
//
///* MARK: TableViewController  */
//
//extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
//    /** Return how many rows the table view should show */
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if nearbyUsers.count == 0 {
//            userContactTableView.setEmptyView(title: emptyViewControllerMessage, message: emptyViewControllerSubtitle)
//        }
//        else {
//            userContactTableView.restore()
//        }
//        return nearbyUsers.count
//    }
//
//    /** Configure each cell - runs everytime a new cell appears */
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let nearbyUser = nearbyUsers[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: "UserContactCell") as! UserContactCell
//
//        cell.setUserContact(user: nearbyUser)
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedUser = nearbyUsers[indexPath.row]
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let profileVC = storyboard.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
//        profileVC.selectedUser = selectedUser
//        DispatchQueue.main.async {
//            self.navigationController?.pushViewController(profileVC, animated: true)
//        }
//    }
//
//    func setupTableView() {
//        userContactTableView.delegate = self
//        userContactTableView.dataSource = self
//        userContactTableView.sectionHeaderHeight = 70
//        userContactTableView.tableFooterView = UIView()
//        //        userContactTableView.separatorStyle = .none
//        //        userContactTableView.separatorColor = Theme.Color.separator
//        userContactTableView.contentInsetAdjustmentBehavior = .never
//
//        let background = Theme.Color.darkBg
//        userContactTableView.backgroundColor = background
//        tableViewHeaderSeparator.backgroundColor = background
//    }
//}
//
///* MARK: CB: Central Manager*/
//
//extension HomeViewController : CBCentralManagerDelegate {
//
//    func retrievePeripheral() {
//         self.centralManager?.scanForPeripherals(withServices: [TransferService.serviceUUID] , options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
//    }
//
//    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        switch central.state {
//        case .unknown:
//            print("Central Manager: Unknown")
//            return
//        case .resetting:
//            print("Central Manager: Resetting")
//            return
//        case .unsupported:
//            print("Bluetooth is not supported on this device")
//            return
//        case .poweredOff:
//            print("Central Manager: Powered Off")
//            return
//        case .poweredOn:
//            print("Central Manager: Powered On")
//            retrievePeripheral()
//            print("Scanned!!")
//        case .unauthorized:
//            /// TODO: In a real app, you'd deal with all the states accordingly
//            if #available(iOS 13.0, *) {
//                switch central.authorization {
//                case .denied:
//                    os_log("You are not authorized to use Bluetooth")
//                case .restricted:
//                    os_log("Bluetooth is restricted")
//                default:
//                    os_log("Unexpected authorization")
//                }
//            } else {
//                // Fallback on earlier versions
//            }
//            return
//        @unknown default:
//            print("A previously unknown central manager state occurred")
//            return
//        }
//    }
//
//    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//
//        /// Can you make use of advertisementData?
//
//        // Reject if the signal strength is too low to attempt data transfer.
//        // Change the minimum RSSI value depending on your app’s use case.
//        /*
//        guard RSSI.intValue >= -2000
//            else {
//                os_log("Discovered perhiperal not in expected range, at %d", RSSI.intValue)
//                return
//        }
//         */
//        os_log("Discovered %s at %d", String(describing: peripheral.name), RSSI.intValue)
//        // Device is in range - have we already seen it?
//        if discoveredPeripheral != peripheral {
//            // Save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it.
//            discoveredPeripheral = peripheral
//            // And finally, connect to the peripheral.
//            os_log("Connecting to perhiperal %@", peripheral)
//            centralManager.connect(peripheral, options: nil)
//        }
//    }
//
//    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
//        print("Central Manager: App is going into background mode.")
//    }
//
//    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
//        os_log("Failed to connect to %@. %s", peripheral, String(describing: error))
////        cleanup()
//    }
//
//    /*
//     *  We've connected to the peripheral, now we need to discover the services and characteristics to find the 'transfer' characteristic.
//     */
//    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//        os_log("Peripheral Connected")
//
//        // Stop scanning
//        centralManager.stopScan()
//        os_log("Scanning stopped")
//
//        // set iteration info
//        connectionIterationsComplete += 1
//
//        // Make sure we get the discovery callbacks
//        peripheral.delegate = self
//
//        // Search only for services that match our UUID
//        peripheral.discoverServices([TransferService.serviceUUID])
//    }
//
//    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
//        os_log("Perhiperal Disconnected")
//        discoveredPeripheral = nil
//
//        // We're disconnected, so start scanning again
//        if connectionIterationsComplete < defaultIterations {
//            retrievePeripheral()
//        } else {
//            os_log("Connection iterations completed")
//        }
//    }
//}
//
///* MARK: CB: Peripheral Manager*/
//
//extension HomeViewController: CBPeripheralDelegate {
//    // implementations of the CBPeripheralDelegate methods
//
//    /*
//     *  The peripheral letting us know when services have been invalidated.
//     */
//    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
//
//        for service in invalidatedServices where service.uuid == TransferService.serviceUUID {
//            os_log("Transfer service is invalidated - rediscover services")
//            peripheral.discoverServices([TransferService.serviceUUID])
//        }
//    }
//
//    /*
//     *  The Transfer Service was discovered
//     */
//    ///#6
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//        if let error = error {
//            os_log("Error discovering services: %s", error.localizedDescription)
////            cleanup()
//            return
//        }
//
//        // Discover the characteristic we want...
//
//        // Loop through the newly filled peripheral.services array, just in case there's more than one.
//        guard let peripheralServices = peripheral.services else { return }
//        for service in peripheralServices {
//            peripheral.discoverCharacteristics([TransferService.characteristicUUID], for: service)
//        }
//    }
//
//    /*
//     *  The Transfer characteristic was discovered.
//     *  Once this has been found, we want to subscribe to it, which lets the peripheral know we want the data it contains
//     */
//    /// #7
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
//        // Deal with errors (if any).
//        if let error = error {
//            os_log("Error discovering characteristics: %s", error.localizedDescription)
////            cleanup()
//            return
//        }
//        // Again, we loop through the array, just in case and check if it's the right one
//        guard let serviceCharacteristics = service.characteristics else { return }
//        for characteristic in serviceCharacteristics where characteristic.uuid == TransferService.characteristicUUID {
//            // If it is, subscribe to it
//            transferCharacteristic = characteristic
//            peripheral.setNotifyValue(true, for: characteristic)
//        }
//        // Once this is complete, we just need to wait for the data to come in.
//    }
//
//
//    /*
//     *   This callback lets us know more data has arrived via notification on the characteristic
//     */
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//        // Deal with errors (if any)
//        if let error = error {
//            os_log("Error discovering characteristics: %s", error.localizedDescription)
////            cleanup()
//            return
//        }
//
//        guard let characteristicData = characteristic.value,
//            let stringFromData = String(data: characteristicData, encoding: .utf8) else { return }
//
//        os_log("Received %d bytes: %s", characteristicData.count, stringFromData)
//
//        // Have we received the end-of-message token?
//        if stringFromData == "EOM" {
//            // End-of-message case: show the data.
//            // Dispatch the text view update to the main queue for updating the UI, because
//            // we don't know which thread this method will be called back on.
//            DispatchQueue.main.async() {
//                self.textView.text = String(data: self.data, encoding: .utf8)
//            }
//
//            // Write test data
//            writeData()
//        } else {
//            // Otherwise, just append the data to what we have previously received.
//            data.append(characteristicData)
//        }
//    }
//
//    /*
//     *  The peripheral letting us know whether our subscribe/unsubscribe happened or not
//     */
//    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
//        // Deal with errors (if any)
//        if let error = error {
//            os_log("Error changing notification state: %s", error.localizedDescription)
//            return
//        }
//
//        // Exit if it's not the transfer characteristic
//        guard characteristic.uuid == TransferService.characteristicUUID else { return }
//
//        if characteristic.isNotifying {
//            // Notification has started
//            os_log("Notification began on %@", characteristic)
//        } else {
//            // Notification has stopped, so disconnect from the peripheral
//            os_log("Notification stopped on %@. Disconnecting", characteristic)
////            cleanup()
//        }
//
//    }
//
//    /*
//     *  This is called when peripheral is ready to accept more data when using write without response
//     */
//    func peripheralIsReady(toSendWriteWithoutResponse peripheral: CBPeripheral) {
//        os_log("Peripheral is ready, send data")
////        writeData()
//    }
//
//}
//
//
