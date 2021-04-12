//
//  User+CoreDataProperties.swift
//  OrderManagementSystem
//
//  Created by iOS Developer on 12/04/21.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var username: String?
    @NSManaged public var passsword: String?
    @NSManaged public var userId: String?

}

extension User : Identifiable {

}
