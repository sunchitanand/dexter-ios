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
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.textColor = UIColor.lightGray
        
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        
        titleLabel.centerYAnchor
            .constraint(equalTo: emptyView.centerYAnchor, constant: 40).isActive = true
        titleLabel.centerXAnchor
            .constraint(equalTo: emptyView.centerXAnchor).isActive = true
        titleLabel.leftAnchor
            .constraint(equalTo: emptyView.leftAnchor, constant: 55).isActive = true
        titleLabel.rightAnchor
            .constraint(equalTo: emptyView.rightAnchor, constant: -55).isActive = true
        titleLabel.font = UIFont(name: Theme.Font.sansSerifRegularItalic, size: 20)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: Theme.Font.sansSerifRegularItalic, size: 18)
        messageLabel.centerXAnchor
            .constraint(equalTo: emptyView.centerXAnchor).isActive = true
        //        messageLabel
        //                .centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        messageLabel.topAnchor
            .constraint(equalTo: titleLabel.bottomAnchor, constant: 15).isActive = true
        //        messageLabel.leftAnchor
        //                .constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        //        messageLabel.rightAnchor
        //                .constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        // The only tricky part is here:
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

