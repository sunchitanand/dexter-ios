//
//  SidebarCell.swift
//  Dexter
//
//  Created by Sunchit Anand on 4/16/20.
//  Copyright © 2020 Sunchit Anand. All rights reserved.
//

import UIKit

class SidebarCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var label: UILabel!
    var section: Int = 0
    var row: Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
//        styleCell()
    }
    /*
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    */
    func styleCell() {
        self.backgroundColor = Theme.Color.darkBg
        Style.textFieldLabel(label)
        label.font = UIFont(name: Theme.Font.sansSerifMedium, size: 17)
        
        switch section {
        case 2:
            label.textColor = Theme.Color.dRed
            label.font = UIFont(name: Theme.Font.sansSerifSemiBold, size: 18)
        default:
            label.textColor = .white
        }
        
    }
    
    func setupCellData(label: String, icon: UIImage, section: Int, row: Int) {
        self.label.text = label
        self.icon.image = icon
        self.section = section
        self.row = row
        print(row, section)
        styleCell()
        
    }

}
