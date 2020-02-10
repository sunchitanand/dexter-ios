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
    let uid: String?
    let firstName: String
    let lastName: String
    let email: String
    
    private static var _current: User?
    
    static var current: User {
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }
        return currentUser
    }
    
    var dictionary: [String: Any] {
        return [
            Fields.User.uid: uid!,
            Fields.User.firstName: firstName,
            Fields.User.lastName: lastName,
            Fields.User.email: email
        ]
    }
}

extension User: DocumentSerializable {
    init?(documentData: [String : Any]) {
        print(documentData[Fields.User.firstName])
        let uid = documentData[Fields.User.uid] as? String ?? "null"
        let firstName = documentData[Fields.User.firstName] as? String ?? "null"
        let lastName = documentData[Fields.User.lastName] as? String ?? "null"
        let email = documentData[Fields.User.email] as? String ?? "null"
        
        self.init(uid: uid,
                  firstName: firstName,
                  lastName: lastName,
                  email: email)
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
    
    static func setCurrent(_ user: User) {
        _current = user
    }
}

extension User: CustomDebugStringConvertible {
    var debugDescription: String {
        return "User: [[\(dictionary)]]"
    }
}

extension User: CustomStringConvertible {
    var description: String {
        return "User email: [[\(email)]]"
    }
}
