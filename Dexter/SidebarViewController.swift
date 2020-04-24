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
    
    @IBOutlet weak var sidebarTableView: UITableView!
    @IBOutlet weak var sidebarTableViewHeader: UIView!
    
    let firebaseAuth = Auth.auth()
    
    let backgroundColor = Theme.Color.darkBg
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backgroundColor
        setupSidebar()
    }
    
    func setupSidebar() {
        self.view.backgroundColor = backgroundColor
        sidebarTableViewHeader.backgroundColor = backgroundColor
        sidebarTableView.backgroundColor = backgroundColor
        sidebarTableView.delegate = self
        sidebarTableView.dataSource = self
        
        sidebarTableView.separatorStyle = .none
        sidebarTableView.tableFooterView = UIView()
        
        SideMenuController.preferences.basic.menuWidth = 230
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

extension SidebarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = DisplayTextView()
        Style.textViewSubtitle(header)
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
        case 2:
            do { try firebaseAuth.signOut() }
                   catch let signOutError as NSError {
                       /// TODO: Handle error
                       print(signOutError.localizedDescription)
                   }
                   transitionToAuthenticationScreen()
        default:
            print("TODO")
        }
    }
    
        func transitionToAuthenticationScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        DispatchQueue.main.async {
            let authProvidersVC = storyboard.instantiateViewController(identifier: Constants.Storyboard.authenticationNavigationController) as? UINavigationController
            self.view.window?.rootViewController = authProvidersVC
            self.view.window?.makeKeyAndVisible()
        }
    }
}
