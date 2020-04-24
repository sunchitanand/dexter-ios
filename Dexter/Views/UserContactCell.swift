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
    @IBOutlet weak var nameTextView: DisplayTextView!
    @IBOutlet weak var aboutTextView: DisplayTextView!
    //    @IBOutlet weak var cardView: UIView!
    
    // TODO: pass User and update all views
    func setUserContact(user: User) {
        self.nameTextView.text = user.firstName + " " + user.lastName
        self.aboutTextView.text = user.about
        
        /*
         UserModelController.downloadProfilePhoto(uid: user.uid) { (result) in
         switch result {
         case .success(let imageFileURL):
         let imageData = try! Data(contentsOf: imageFileURL)
         let image = UIImage(data: imageData)
         
         print("IMAGE: ", image!)
         self.profilePhotoImageView.image = image
         case .failure(let err):
         print("Firebase Download Error: \(err.localizedDescription)")
         }
         }
         */
        UserModelController.readFromFileSystem(relativePath: "profile-pictures", uid: user.uid) { (image) in
            print("image: ", image.debugDescription)
            self.profilePhotoImageView.image = image
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        styleCell()
    }
    
    func styleCell() {
        nameTextView.font = UIFont(name: Theme.Font.sansSerifSemiBold, size: 17)
        aboutTextView.font = UIFont(name: Theme.Font.sansSerifRegular, size: 15)
        aboutTextView.textContainer.maximumNumberOfLines = 5
        aboutTextView.textContainer.lineBreakMode = .byTruncatingTail
        self.selectionStyle = .none
        
        Style.profilePhotoImageView(profilePhotoImageView)
        
        self.backgroundColor = Theme.Color.darkBg
        nameTextView.backgroundColor = Theme.Color.darkBg
        nameTextView.textColor = .white
        aboutTextView.backgroundColor = Theme.Color.darkBg
        aboutTextView.textColor = .white
        
        /*
         cardView.backgroundColor = .white
         cardView.layer.cornerRadius = 10
         cardView.layer.shadowColor = UIColor.black.cgColor
         cardView.layer.shadowOpacity = 0.2
         cardView.layer.shadowOffset = .zero
         cardView.layer.shadowRadius = 5
         
         cardView.layer.shadowPath = UIBezierPath(rect: cardView.bounds).cgPath
         cardView.layer.shouldRasterize = true
         cardView.layer.rasterizationScale = UIScreen.main.scale
         */
    }
}
