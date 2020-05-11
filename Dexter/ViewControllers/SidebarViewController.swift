//
//  SidebarViewController.swift
//  Dexter
//
//  Created by Sunchit Anand on 4/18/20.
//  Copyright © 2020 Sunchit Anand. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SideMenuSwift

class SidebarViewController: UIViewController {
    
    /* MARK: Views */
    @IBOutlet weak var sidebarTableView: UITableView!
    @IBOutlet weak var sidebarTableViewHeader: UIView!
    @IBOutlet weak var dexterLogoImageView: UIImageView!
    
    /* MARK: Labels */
    @IBOutlet weak var greetingLabel: UILabel!
    
    let firebaseAuth = Auth.auth()
    
    let sectionHeaders = ["Account", "Help", ""]
    
    let rowLabels = [
        ["Edit Profile", "Change Password"],
        ["Feedback", "Report a bug", "Terms & Privacy"],
        ["Logout"]
    ]
    
    let icons = [
        [UIImage(named: "account_circle_white_24pt"), UIImage(named: "https_white_24pt")],
        [UIImage(named: "feedback_white_24pt"), UIImage(named: "bug_report_white_24pt"), UIImage(named: "policy_white_24pt")],
        [UIImage(named: "exit_to_app_white_24pt")]
    ]
    
    let backgroundColor = Theme.Color.darkBg
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSidebar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        DispatchQueue.main.async {
            self.greetingLabel.text = "Hey,\n  \(User.current.firstName)"
        }
    }
    
    func setupSidebar() {
        self.view.backgroundColor = backgroundColor
        
        SideMenuController.preferences.basic.menuWidth = 230
        
        /* MARK: Views */
        sidebarTableView.delegate = self
        sidebarTableView.dataSource = self
        sidebarTableView.backgroundColor = backgroundColor
        sidebarTableView.separatorStyle = .none
        sidebarTableView.tableFooterView = UIView()
        
        sidebarTableViewHeader.backgroundColor = backgroundColor
        
        Render.dexterLogo(dexterLogoImageView)
        
        
        /* MARK: Labels */
        Render.labelTitle(greetingLabel)
        greetingLabel.text = "Hey,\n  \(User.current.firstName)"
        //        greetingLabel.font = UIFont(name: Theme.Font.serifSemiBold, size: 27)
        greetingLabel.numberOfLines = 0
        greetingLabel.sizeToFit()
    }
}

extension SidebarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UITextView()
        header.isEditable = false
        header.isUserInteractionEnabled = false
        Render.textViewSubtitle(header)
        header.text = sectionHeaders[section]
        header.textContainerInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        header.backgroundColor = backgroundColor
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 2:
            return 0
        default:
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = backgroundColor
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 45
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return rowLabels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowLabels[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SidebarCell", for: indexPath) as! SidebarCell
        let title = rowLabels[indexPath.section][indexPath.row]
        let icon = icons[indexPath.section][indexPath.row]!
        //        print(indexPath.section, indexPath.row)
        cell.setupCellData(label: title, icon: icon, section: indexPath.section, row: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.selectionStyle = .gray
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        
        case 0:
            switch indexPath.row {
            case 0:
                print("Edit profile selected")
                let settingsVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.settingsViewController) as! SettingsViewController
                sideMenuController?.hideMenu(animated: true, completion: { (result) in
                    if result {
                        self.sideMenuController?.setContentViewController(to: settingsVC)
                    }
                })
                
            case 1:
                print("Change password selected")
                let changePasswordVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.changePasswordViewController) as! ChangePasswordViewController
                sideMenuController?.hideMenu(animated: true, completion: { (result) in
                    if result {
                        self.sideMenuController?.setContentViewController(to: changePasswordVC)
                    }
                })
            default:
                print("Section/row does not exist")
            }
        
        case 1:
            switch indexPath.row {
            case 0:
                print("Opening Feedback Form on Safari...")
                if let url = URL(string: "https://forms.gle/uA6n64HZdE1h2Bdf6") {
                    UIApplication.shared.open(url)
                }
            case 1:
                print("Opening Report a Bug Form on Safari...")
                if let url = URL(string: "https://forms.gle/a1jH2QJQuhACtSz88") {
                    UIApplication.shared.open(url)
                }
            case 2:
                print("Opening Privacy Policy on Safari...")
                if let url = URL(string:
                    "https://www.notion.so/dexterapp/DEXTER-PRIVACY-POLICY-6de9eab9da514cd9ad3357d18d1b936f") {
                    UIApplication.shared.open(url)
                }
            default:
                print("Section/row does not exist")
            }
            
        case 2:
            print("Sidebar: Logout")
            do {
                try firebaseAuth.signOut()
            }
            catch let signOutError as NSError {
                print(signOutError.localizedDescription)
                let errorAlert = Render.singleActionAlert(title: "Error Occurred", message: "There was an error trying to log you out. Please try again.")
                self.present(errorAlert, animated: true, completion: nil)
                return
            }
            print("[STATE] Logged Out")
            HomeViewController.clearUserContactTableView()
            transitionToAuthenticationScreen()
        default:
            print("Section/row does not exist")
        }
    }
    
    func transitionToAuthenticationScreen() {
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        DispatchQueue.main.async {
            let authProvidersVC = storyboard.instantiateViewController(identifier: Constants.Storyboard.authenticationNavigationController) as? UINavigationController
            self.view.window?.rootViewController = authProvidersVC
            self.view.window?.makeKeyAndVisible()
        }
    }
}
