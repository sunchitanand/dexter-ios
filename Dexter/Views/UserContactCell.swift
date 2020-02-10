//
//  UserContactCell.swift
//  Dexter
//
//  Created by Sunchit Anand on 1/20/20.
//  Copyright © 2020 Sunchit Anand. All rights reserved.
//

import UIKit

class UserContactCell: UITableViewCell {
    
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var nameTextField: UILabel!
    @IBOutlet weak var aboutTextField: UILabel!
    
    func setUserContact(username: String) {
        self.nameTextField.text = username
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Styles.messageLabel(nameTextField)
        Styles.messageLabel(aboutTextField)
    }
}
