//
//  User.swift
//  Dexter
//
//  Created by Sunchit Anand on 12/26/19.
//  Copyright © 2019 Sunchit Anand. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase

struct User {
    
    /// NOTE: private (set) - private setter but getter access from outside this class
    private(set) var uid: String
    private(set) var firstName: String
    private(set) var lastName: String
    private(set) var email: String
    private(set) var about: String?
    private(set) var twitterHandle: String?
    private(set) var instagramHandle: String?
    private(set) var profilePhotoURL: String?
    private(set) var flagCount: Int?
    
    static var _current: User?
    
    /// checking if current user not nil before it is used by an outside class
    static var current: User {
        guard let currentUser = _current else {
//            fatalError("Current user doesn't exist")
            return User(documentData: [:])!
            /// TODO: Send a notification to a VC and go to Auth page
            
        }
        return currentUser
    }
    
    /// read user
    var dictionary: [String: Any] {
        return [
            Fields.User.uid: uid,
            Fields.User.firstName: firstName,
            Fields.User.lastName: lastName,
            Fields.User.email: email,
            Fields.User.about: about ?? "",
            Fields.User.twitterHandle: twitterHandle ?? "",
            Fields.User.instagramHandle: instagramHandle ?? "",
            Fields.User.profilePhotoURL: profilePhotoURL ?? "",
            Fields.User.flagCount: flagCount ?? 0
        ]
    }
    
    static func setCurrent(_ user: User) {
        _current = user
    }
    
    static func updateCurrent(_ dataDict: [String : Any]) {
        /// iterate thru dict and update _current with new values
        for (field, value) in dataDict {
            // force unwrap _current here?
            switch field {
            case Fields.User.firstName:
                _current?.firstName = value as! String
                print("User object: First name updated")
                break
            case Fields.User.lastName:
                _current?.lastName = value as! String
                print("User object: Last name updated")
                break
            case Fields.User.email:
                _current?.email = value as! String
                print("User object: Email updated")
                break
            case Fields.User.about:
                _current?.about = value as? String
                break
            case Fields.User.twitterHandle:
                _current?.twitterHandle = value as? String
                print("User object: Twitter handle updated")
                break
            case Fields.User.instagramHandle:
                _current?.instagramHandle = value as? String
                print("User object: Instagram username updated")
                break
            case Fields.User.profilePhotoURL:
                _current?.profilePhotoURL = value as? String
                print("User object: Profile photo URL updated")
                break
            case Fields.User.flagCount:
                _current?.flagCount = value as? Int
                print("User object: Flag count updated")
                break
            default:
                print("User object: No update")
                break
            }
        }
    }
    
    static func doesCurrentUserExist() -> Bool {
        if _current != nil {
            return true
        }
        return false
    }
}

extension User: DocumentSerializable {
    
    init?(documentData: [String : Any]) {
        //        print(documentData[Fields.User.firstName])
        let uid = documentData[Fields.User.uid] as? String ?? ""
        let firstName = documentData[Fields.User.firstName] as? String ?? ""
        let lastName = documentData[Fields.User.lastName] as? String ?? ""
        let email = documentData[Fields.User.email] as? String ?? ""
        let about = documentData[Fields.User.about] as? String ?? ""
        let twitterHandle = documentData[Fields.User.twitterHandle] as? String ?? ""
        let instagramHandle = documentData[Fields.User.instagramHandle] as? String ?? ""
        let profilePhotoURL = documentData[Fields.User.profilePhotoURL] as? String ?? ""
        let flagCount = documentData[Fields.User.flagCount] as? Int ?? 0
        
        self.init(uid: uid,
                  firstName: firstName,
                  lastName: lastName,
                  email: email,
                  about: about,
                  twitterHandle: twitterHandle,
                  instagramHandle: instagramHandle,
                  profilePhotoURL: profilePhotoURL,
                  flagCount: flagCount)
    }
    
    //    init?(snapshot: DocumentSnapshot) {
    //        if let documentData = snapshot.data() {
    //            let uid = documentData[Fields.User.uid] as? String ?? ""
    //            let firstName = documentData[ Fields.User.firstName] as? String ?? ""
    //            let lastName = documentData[Fields.User.lastName] as? String ?? ""
    //            let email = documentData[Fields.User.email] as? String ?? ""
    //
    //            self.init(uid: uid,
    //                      firstName: firstName,
    //                      lastName: lastName,
    //                      email: email)
    //        }
    //    }
    
}
/// what to display when printing User.current
//extension User: CustomDebugStringConvertible {
//    var debugDescription: String {
//        return "User: [[\(dictionary)]]"
//    }
//}

extension User: CustomStringConvertible {
    var description: String {
        return "User: [[\(email)]]"
    }
}
