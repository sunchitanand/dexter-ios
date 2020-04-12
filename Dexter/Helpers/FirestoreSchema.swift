//
//  FirestoreSchema.swift
//  Dexter
//
//  Created by Sunchit Anand on 12/28/19.
//  Copyright © 2019 Sunchit Anand. All rights reserved.
//

import Foundation

struct Collections {
    
}

struct Fields {
    struct User {
        static let uid: String = "uid"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let email = "email"
        static let about = "about"
        static let twitterHandle = "twitterHandle"
        static let instagramHandle = "instagramHandle"
        static let profilePhotoURL = "profilePhotoURL"
    }
}
