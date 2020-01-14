//
//  UserModelController.swift
//  Dexter
//
//  Created by Sunchit Anand on 12/30/19.
//  Copyright © 2019 Sunchit Anand. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class UserModelController {
    
    static let sharedInstance = UserModelController()
    private var user: User?
    
    init() {
        self.user = nil
    }
    
    func getUser(uid: String, completion: @escaping (Result<User, Error>) -> ()) {
        let usersByUid = Firestore.firestore().collection("users").document(uid)
        
        usersByUid.getDocument { (snapshot, err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            guard let snapshot = snapshot else {return}
            let userDoc = snapshot.data()
            if let newUser = User(documentData: userDoc!) {
                self.user = newUser
                print(self.user!.firstName)
                print(newUser.firstName)
                completion(.success(newUser))
            }
        }
    }
    
    
//    func queryAllUsers(completion: @escaping (Result<[User], Error>) -> ()) {
//        let usersRef = Firestore.firestore().collection("users")
//        //        let query = usersRef.whereField("name.first", isEqualTo: "Sunchit")
//
//        usersRef.getDocuments { (snapshot, err) in
//            if let err = err {
//                completion(.failure(err))
//                return
//            }
//            guard let snapshot = snapshot else {return}
//            let userDocs = snapshot.documents
//            var usersList: [User] = []
//            for userDoc in userDocs {
//                //                print("User: \(userDoc.data()["email"] ?? "no")")
//                if let newUser = User(documentData: userDoc.data()) {
//                    usersList.append(newUser)
//                    //                    print("User's email is \(newUser.email)")
//                }
//            }
//            completion(.success(usersList))
//        }
//    }
    
}
