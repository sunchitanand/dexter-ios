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

enum FirestoreError: Error {
    case userDoesNotExist
    case noURLReceived
}

enum FileSystemError: Error {
    case fileDoesNotExist
}

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
                    print("[ERROR] creating new user in Firestore.")
                    completion(.failure(err))
                    return
                }
                if current {
                    User.setCurrent(user)
                    print("[SUCCESS] New user [\(User.current.uid)] created. ")
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
                print("[ERROR] retriving user from Firestore.")
                completion(.failure(err))
                return
            }
            guard let snapshot = snapshot else {return}
            let userDoc = snapshot.data()
            let newUser = User(documentData: userDoc ?? [:])
            
            if let newUser = newUser {
                if newUser.email == "" {
                    let error = FirestoreError.userDoesNotExist
                    print("[ERROR] Firestore returned success response but user is nil")
                    completion(.failure(error))
                    return
                }
                User.setCurrent(newUser)
                if !doesProfilePhotoExist(uid: uid) {
                    downloadProfilePhoto(uid: uid) { (response) in }
                }
                print("[SUCCESS] \(newUser) retrieved from Firestore")
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
                print("[ERROR] retriving user from Firestore.")
                completion(.failure(err))
                return
            }
            guard let snapshot = snapshot else {return}
            let userDoc = snapshot.documents[0].data()
            let newUser = User(documentData: userDoc)
            
            if let newUser = newUser {
                if !doesProfilePhotoExist(uid: uid) {
                    downloadProfilePhoto(uid: uid) { (response) in }
                }
                print("[SUCCESS] \(newUser) retrieved from Firestore")
                completion(.success(newUser))
            }
        }
    }
    /** Used for Simulating discovery behavior **/
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
                print("[ERROR] updating document")
                completion(.failure(err))
            }
            else {
                /// update User singleton
                User.updateCurrent(newUserData)
                completion(.success(_: true))
            }
        }
    }
    
    static func deleteCurrentUser(completion: @escaping (Result<Bool, Error>) -> ()) {
        let userRef = Firestore.firestore().collection("users").document(User.current.uid)
        userRef.delete { (err) in
            if let err = err {
                print("[ERROR] deleting user document from Firestore.")
                completion(.failure(err))
                return
            }
            print("[SUCCESS] User document [\(User.current.uid)] deleted successfully.")
            let storage = Storage.storage()
            let imageRef = storage.reference().child("profile-pictures").child(User.current.uid)
            imageRef.delete { (err) in
                if let err = err {
                    print("[ERROR] deleting profile photo from Firebase Storage.")
                    completion(.failure(err))
                    return
                }
                print("[SUCCESS] Profile photo deleted from Firebase Storage.")
                completion(.success(true))
            }
        }
    }
    
    static func getProfilePhoto(uid: String, completion: @escaping (Result<UIImage, Error>) -> ()) {
        
        UserModelController.readFromFileSystem(relativePath: "profile-pictures", uid: uid) { (response) in
            switch response {
            case .success(let image):
                completion(.success(image))
                return
                
            case .failure(_):
                UserModelController.downloadProfilePhoto(uid: uid) { (response) in
                    switch response {
                        
                    case .success(let image):
                            completion(.success(image))
                        return
                        
                    case .failure(let error):
                        completion(.failure(error))
                        return
                    }
                }
            }
        }
    }
    
    /// Download and store in local file system.
    static func downloadProfilePhoto(uid: String, completion: @escaping (Result<UIImage, Error>) -> ()) {
        let storage = Storage.storage()
        let imageRef = storage.reference().child("profile-pictures").child(uid)
        var localFileURL : URL!
        
        // Create local filesystem URL
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let localURL = documentsURL.appendingPathComponent("profile-pictures/\(uid)")
        
        let downloadTask = imageRef.write(toFile: localURL) { url, error in
            if let error = error {
                print("[ERROR] downloading profile photo from Firebase. \(error.localizedDescription)")
                completion(.failure(error))
                return
            } else {
                DispatchQueue.main.async {
                    localFileURL = url
                    print("[SUCCESS] Profile photo downloaded at path: \(localFileURL.path).")
                    let imageData = try! Data(contentsOf: localFileURL)
                    let image = UIImage(data: imageData)
                    completion(.success(image!))
                    return
                }
            }
        }
    }
    
    /// Upload photo to Firebase Storage, get the URL and store in Local File System.
       static func updateProfilePhoto(image: UIImage, completion: @escaping (Result<String, Error>) -> ()) {
           guard let data = image.jpegData(compressionQuality: 0.0) else {
               // present alert?
               print("[ERROR] Something went wrong. Please try again.")
               return
           }
           
           let storage = Storage.storage()
           let imageRef = storage.reference().child("profile-pictures").child(User.current.uid)
           
           // upload image to Firebase Storage
           imageRef.putData(data, metadata: nil) { (metadata, err) in
               if let err = err {
                   print("[ERROR] uploading data to Firebase Storage... \n\(err.localizedDescription)")
                   completion(.failure(err))
                   return
               }
               imageRef.downloadURL { (url, err) in
                   if let err = err {
                       print("[ERROR] downloading profile photo URL... \n\(err.localizedDescription)")
                       completion(.failure(err))
                       return
                   }
                   var urlString: String
                   guard url != nil else {
                       let log = "No URL received"
                       print(log)
                       let error = FirestoreError.noURLReceived
                       completion(.failure(error))
                       return
                   }
                   urlString = url!.absoluteString
                   let photoUrlEntry = [Fields.User.profilePhotoURL: urlString]
                   
                   User.updateCurrent(photoUrlEntry)
                   
                   // upload URL to Firestore
                   updateUser(newUserData: photoUrlEntry as [String : Any]) { (response) in
                       switch response {
                       case .success(_):
                           let log = "[SUCCESS] Profile photo uploaded to Firestore"
                           print(log)
                           completion(.success(log))
                           return
                           
                       case .failure(let err):
                           print("[ERROR] updating user profile photo URL in Firestore... \n\(err.localizedDescription)")
                           completion(.failure(err))
                           return
                       }
                   }
                   // Can be optimized by storing directly from user input to file system instead of downloading from Firebase and storing (after the update)
                   downloadProfilePhoto(uid: User.current.uid) { _ in }
               }
           }
       }
    
    static func readFromFileSystem(relativePath: String, uid: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        var image : UIImage! = UIImage()
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fullPath = relativePath + "/" + uid
        let localURL = documentsURL.appendingPathComponent(fullPath)
        
        print("Reading from file system... \n at URL: ", localURL.path)
        if fileManager.fileExists(atPath: localURL.path) {
            do {
                let imageData = try Data(contentsOf: localURL)
                image = UIImage(data: imageData)
                print("[SUCCESS] File fetched from file system.")
                completion(.success(image))
                return
            }
            catch let error as NSError {
                print("[ERROR] fetching file from file system... \(error.description)")
                completion(.failure(error))
                return
            }
        }
        else {
            let log = "[ERROR] File does not exist in file system."
            print(log)
            let error = FileSystemError.fileDoesNotExist
            completion(.failure(error))
            
        }
    }
    
    static func doesProfilePhotoExist(uid: String) -> Bool {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fullPath = "profile-pictures" + "/" + uid
        let localURL = documentsURL.appendingPathComponent(fullPath)
        return fileManager.fileExists(atPath: localURL.path) ? true : false
    }
    
    /// Deletes from File System and returns true if operation was successful.
    static func deleteFromFileSystem(relativePath: String, uid: String) -> Bool {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fullPath = relativePath + "/" + uid
        let localURL = documentsURL.appendingPathComponent(fullPath)
        if doesProfilePhotoExist(uid: uid) {
            do {
                try fileManager.removeItem(at: localURL)
            }
            catch let error as NSError {
                print("[ERROR] deleting profile photo... \n\(error.localizedDescription)")
                return false
            }
            print("[SUCCESS] Profile photo for [\(uid)] deleted from file system.")
            return true
        }
        print("[ERROR] Profile photo for [\(uid)] could not be deleted because it does not exist in the file system.")
        return false
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
