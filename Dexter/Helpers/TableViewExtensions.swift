//
//  TableViewExtensions.swift
//  Dexter
//
//  Created by Sunchit Anand on 2/23/20.
//  Copyright © 2020 Sunchit Anand. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func setEmptyView(title: String, message: String) {
        let textColor = UIColor.darkGray
        let transparency: CGFloat = 0.8
        let textFont = Theme.Font.sansSerifMedium
        let shadowColor = UIColor.darkGray
        
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.textColor = textColor
        titleLabel.alpha = transparency
        titleLabel.font = UIFont(name: textFont, size: 17)
//        titleLabel.shadowColor = shadowColor
//        titleLabel.shadowOffset = CGSize(width: -1.0,height: -1.0)
        
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        
//        titleLabel.centerYAnchor
//            .constraint(equalTo: emptyView.centerYAnchor, constant: 100).isActive = true
        titleLabel.centerXAnchor
            .constraint(equalTo: emptyView.centerXAnchor).isActive = true
        titleLabel.topAnchor
            .constraint(equalTo: emptyView.topAnchor, constant: 185).isActive = true
        titleLabel.leftAnchor
            .constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        titleLabel.rightAnchor
            .constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = textColor
        messageLabel.font = UIFont(name: textFont, size: 17)
        messageLabel.alpha = transparency
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
//        messageLabel.shadowColor = shadowColor
//        messageLabel.shadowOffset = CGSize(width: -1.0,height: -1.0)
        
        messageLabel.centerXAnchor
            .constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.bottomAnchor
            .constraint(equalTo: emptyView.bottomAnchor, constant: -50).isActive = true
        //        messageLabel
        //                .centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        //        messageLabel.topAnchor
        //            .constraint(equalTo: titleLabel.bottomAnchor, constant: 15).isActive = true
        //        messageLabel.leftAnchor
        //            .constraint(equalTo: emptyView.leftAnchor, constant: 10).isActive = true
        //        messageLabel.rightAnchor
        //            .constraint(equalTo: emptyView.rightAnchor, constant: 10).isActive = true
        
        // The only tricky part is here:
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

