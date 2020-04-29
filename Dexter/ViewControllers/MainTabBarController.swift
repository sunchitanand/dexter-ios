//
//  MainTabBarController.swift
//  Dexter
//
//  Created by Sunchit Anand on 3/18/20.
//  Copyright © 2020 Sunchit Anand. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    func setupTabBar() {
        
        tabBar.barTintColor = .black
        tabBar.barStyle = .black
        tabBar.itemPositioning = .fill
        tabBar.tintColor = Theme.Color.cardBg
        tabBar.itemWidth = 100
        
        // Top Margin on Tab Bar
        /*
         guard let items  = tabBar.items else {return}
         for item in items {
         item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
         }
         */
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
