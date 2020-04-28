//
//  UserModelController.swift
//  Dexter
//
//  Created by Sunchit Anand on 12/30/19.
//  Copyright © 2019 Sunchit Anand. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore

class UserModelController {
    
    //    private var user: User?
    var db = Firestore.firestore()
    //    init() {
    //        self.user = nil
    //    }
    //
    /// TODO: Store firebase auth uid in User singleton and use that to reduce # of hits to auth server
    
    static func createUser(newDocumentId: String, user: User?, current: Bool, completion: @escaping (Result<User, Error>) -> ()) {
        if let user = user {
            let newUserRef = Firestore.firestore().collection("users").document(newDocumentId)
            newUserRef.setData(user.dictionary) { (err) in
                if let err = err {
                    completion(.failure(err))
                    return
                }
                if current {
                    User.setCurrent(user)
                    completion(.success(User.current))
                    return
                }
                completion(.success(user))
                return
            }
        }
    }
    
    static func getCurrentUser(completion: @escaping (Result<User, Error>) -> ()) {
        //        let usersByUid = Firestore.firestore().collection("users").document(uid)
        var uid = Auth.auth().currentUser!.uid
        uid.removeLast(2)
        let usersByUid = Firestore.firestore().collection("users").document(uid)
        
        usersByUid.getDocument { (snapshot, err) in
            if let err = err {
                print("ERROR: Error retriving user from Firestore.")
                completion(.failure(err))
                return
            }
            guard let snapshot = snapshot else {return}
            let userDoc = snapshot.data()
            let newUser = User(documentData: userDoc ?? [:])
            
            if let newUser = newUser {
                User.setCurrent(newUser)
                /*
                 downloadProfilePhoto(uid: uid) { response in
                 switch response {
                 case .success(let url):
                 print("get user ", url)
                 break
                 case .failure(let err):
                 print(err.localizedDescription)
                 break
                 }
                 }
                 */
                print("\(newUser.email) retrieved from Firestore")
                completion(.success(newUser))
            }
        }
    }
    
    static func getUser(uid: String, completion: @escaping (Result<User, Error>) -> ()) {
        //        let usersByUid = Firestore.firestore().collection("users").document(uid)
        let usersByUid = Firestore.firestore().collection("users").whereField(Fields.User.uid, isEqualTo: uid)
        
        /// TODO: Get user by uid (not document ID) - whereField clause
        /// remove last two characters from auth uid and store as uid in firestore (although, doc id = auth uid)
        
        usersByUid.getDocuments { (snapshot, err) in
            if let err = err {
                print("ERROR: Error retriving user from Firestore.")
                completion(.failure(err))
                return
            }
            guard let snapshot = snapshot else {return}
            let userDoc = snapshot.documents[0].data()
            let newUser = User(documentData: userDoc)
            
            if let newUser = newUser {
                User.setCurrent(newUser)
                /*
                 downloadProfilePhoto(uid: uid) { response in
                 switch response {
                 case .success(let url):
                 print("get user ", url)
                 break
                 case .failure(let err):
                 print(err.localizedDescription)
                 break
                 }
                 }
                 */
                print("\(newUser.email) retrieved from Firestore")
                completion(.success(newUser))
            }
        }
    }
    
    static func getAllUsers(completion: @escaping (Result<[User], Error>) -> ()) {
        let usersRef = Firestore.firestore().collection("users")
        //        let query = usersRef.whereField("name.first", isEqualTo: "Sunchit")
        
        usersRef.getDocuments { (snapshot, err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            guard let snapshot = snapshot else {return}
            let userDocs = snapshot.documents
            var usersList: [User] = []
            for userDoc in userDocs {
                //                print("User: \(userDoc.data()["email"] ?? "no")")
                let newUser = User(documentData: userDoc.data())
                if let newUser = newUser {
                    usersList.append(newUser)
                    print("User's email is \(newUser.email)")
                    /*
                     downloadProfilePhoto(uid: newUser.uid) { response in
                     switch response {
                     case .success(let url):
                     print("get All users ", url)
                     break
                     case .failure(let err):
                     print(err.localizedDescription)
                     break
                     }
                     }
                     */
                }
            }
            completion(.success(usersList))
        }
    }
    
    static func updateUser(newUserData: [String: Any], completion: @escaping (Result<Bool, Error>) -> ()) {
        let userRef = Firestore.firestore().collection("users").document(User.current.uid)
            userRef.updateData(newUserData) { (err) in
                if let err = err {
                    print("Error updating document")
                    completion(.failure(err))
                }
                else {
                    /// update User singleton
                    User.updateCurrent(newUserData)
                    completion(.success(_: true))
                }
            }
    }
    
    static func updateProfilePhoto(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            /// present alert?
            print("Something went wrong. Please try again.")
            return
        }
        
        let storage = Storage.storage()
        let imageRef = storage.reference().child("profile-pictures").child(User.current.uid)
        
        /// upload image to Firebase Storage
        imageRef.putData(data, metadata: nil) { (metadata, err) in
            if let err = err {
                print("Error: Can't upload data to Firebase Storage. \(err.localizedDescription)")
                return
            }
            imageRef.downloadURL { (url, err) in
                if let err = err {
                    print("Download URL Error: \(err.localizedDescription)")
                    return
                }
                var urlString: String
                guard url != nil else {
                    print("No URL receieved")
                    return
                }
                urlString = url!.absoluteString
                let photoData = [Fields.User.profilePhotoURL: urlString]
                
                User.updateCurrent(photoData)
                
                /// upload URL to Firestore
                updateUser(newUserData: photoData as [String : Any]) { (response) in
                    switch response {
                    case .success(_):
                        print("Profile photo uploaded to Firestore")
                    case .failure(let err):
                        print("Firestore Error: \(err.localizedDescription)")
                    }
                }
                
                downloadProfilePhoto(uid: User.current.uid) { response in
                    switch response {
                    case .success(let url):
                        print("update profile photo", url)
                        break
                    case .failure(let err):
                        print(err.localizedDescription)
                        break
                    }
                }
            }
        }
    }
    /// Download and store in local file system
    static func downloadProfilePhoto(uid: String, completion: @escaping (Result<URL, Error>) -> ()) {
        let storage = Storage.storage()
        let imageRef = storage.reference().child("profile-pictures").child(uid)
        var localFileURL : URL!
        
        // Create local filesystem URL
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let localURL = documentsURL.appendingPathComponent("profile-pictures/\(uid)")
        let downloadTask = imageRef.write(toFile: localURL) { url, error in
            if let error = error {
                print("Firebase Error: Write to file. \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                DispatchQueue.main.async {
                    localFileURL = url
                    completion(.success(localFileURL))
                }
            }
        }
    }
    
    static func readFromFileSystem(relativePath: String, uid: String, completion: @escaping (UIImage) -> Void) {
        
        var image : UIImage! = UIImage()
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fullPath = relativePath + "/" + uid
        let localURL = documentsURL.appendingPathComponent(fullPath)
        
        print("URL1", localURL.path)
        if fileManager.fileExists(atPath: localURL.path) {
            do {
                let imageData = try Data(contentsOf: localURL)
                image = UIImage(data: imageData)
                print("Image1: ", image!)
                completion(image)
            } catch let error as NSError {
                let errorString = error.description
                print(errorString)
                return
            }
        } else {
            print("File does not exist in file system.")
        }
    }
    
    static func flagUser(uid: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        let userRef = Firestore.firestore().collection("users").document(uid)
        
        UserModelController.getUser(uid: uid) { (response) in
            switch response {
            case .success(let user):
                print(user)
                print("Current flag count: \(String(describing: user.flagCount))")
                let newFlagCount = user.flagCount! + 1
                print(newFlagCount)
                let data = [Fields.User.flagCount: newFlagCount]
                
                userRef.updateData(data, completion: { (error) in
                    if let error = error {
                        completion(.failure(error))
                    }
                    else {
                        completion(.success(true))
                    }
                })
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

//
//    func getStoredUser() -> Dictionary<String, Any> {
//        return user!.dictionary
//    }
