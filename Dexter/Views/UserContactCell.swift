//
//  UserContactCell.swift
//  Dexter
//
//  Created by Sunchit Anand on 1/20/20.
//  Copyright © 2020 Sunchit Anand. All rights reserved.
//

import UIKit

class UserContactCell: UITableViewCell {
    /* MARK: Text Views */
    @IBOutlet weak var nameTextView: DisplayTextView!
    @IBOutlet weak var aboutTextView: DisplayTextView!
    
    /* MARK: Labels */
    @IBOutlet weak var timestampLabel: UILabel!
    
    /* MARK: Views */
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    //    @IBOutlet weak var cardView: UIView!
    
    // TODO: pass User and update all views
    func setUserContact(user: User) {
        self.nameTextView.text = user.firstName + " " + user.lastName
        self.aboutTextView.text = user.about
        
        
//        UserModelController.downloadProfilePhoto(uid: user.uid) { (result) in
//            switch result {
//            case .success(let image):
//                self.profilePhotoImageView.image = image
//
//            case .failure(let err):
//                print("Firebase Download Error: \(err.localizedDescription)")
//            }
//        }
//
//        UserModelController.readFromFileSystem(relativePath: "profile-pictures", uid: user.uid) { (response) in
//            switch response {
//            case .success(let image):
//                self.profilePhotoImageView.image = image
//
//            case .failure(_):
//                self.profilePhotoImageView.backgroundColor = .black
//            }
//        }
        
        UserModelController.getProfilePhoto(uid: user.uid) { (response) in
            switch response {
            case .success(let image):
                self.profilePhotoImageView.image = image
            case .failure(_):
                self.profilePhotoImageView.backgroundColor = .black
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        styleCell()
    }
    
    func styleCell() {
        let backgroundColor = Theme.Color.darkBg
        self.backgroundColor = backgroundColor
        self.selectionStyle = .none
        
        /* MARK: Text Views */
        nameTextView.font = UIFont(name: Theme.Font.sansSerifSemiBold, size: 17)
        nameTextView.backgroundColor = backgroundColor
        nameTextView.textColor = .white
        
        aboutTextView.font = UIFont(name: Theme.Font.sansSerifRegular, size: 16)
        aboutTextView.textContainer.maximumNumberOfLines = 6
        aboutTextView.textContainer.lineBreakMode = .byTruncatingTail
        aboutTextView.backgroundColor = backgroundColor
        aboutTextView.textColor = .white
        
        
        /* MARK: Image Views */
        Render.profilePhotoImageView(profilePhotoImageView)
        
        
        /* MARK: Labels */
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        let dateString = formatter.string(from: date)
        timestampLabel.text = dateString //String(hour) + ":" + String(minutes)
        timestampLabel.font = UIFont(name: Theme.Font.sansSerifRegular, size: 11)
        timestampLabel.textColor = .lightGray
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
