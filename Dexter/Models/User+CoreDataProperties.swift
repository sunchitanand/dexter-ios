//
//  User+CoreDataProperties.swift
//  
//
//  Created by Sunchit Anand on 2/10/20.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var email: String?
    @NSManaged public var uid: String?

}
