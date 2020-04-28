//
//  DiscoveryNavigationController.swift
//  Dexter
//
//  Created by Sunchit Anand on 2/20/20.
//  Copyright © 2020 Sunchit Anand. All rights reserved.
//

import UIKit

class DiscoveryNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        setStatusBar(backgroundColor: Theme.Color.greenOn)
        // Do any additional setup after loading the view.
    }
    
    func setStatusBar(backgroundColor: UIColor) {
        let statusBarFrame: CGRect
        if #available(iOS 13.0, *) {
            statusBarFrame = self.view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.backgroundColor = backgroundColor
        self.view.addSubview(statusBarView)
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
