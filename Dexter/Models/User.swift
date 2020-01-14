//
//  User.swift
//  Dexter
//
//  Created by Sunchit Anand on 12/26/19.
//  Copyright © 2019 Sunchit Anand. All rights reserved.
//

import Foundation

struct User {
    /// NOTE: private (set) - private setter but getter access from outside this class
    private(set) var uid: String?
    private(set) var firstName: String
    private(set) var lastName: String
    private(set) var email: String

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
        let uid = documentData[Fields.User.uid] as? String ?? ""
        let firstName = documentData[ Fields.User.firstName] as? String ?? "cNull"
        let lastName = documentData[Fields.User.lastName] as? String ?? "cNull"
        let email = documentData[Fields.User.email] as? String ?? "cNull"
        
        self.init(uid: uid,
                  firstName: firstName,
                  lastName: lastName,
                  email: email)
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




