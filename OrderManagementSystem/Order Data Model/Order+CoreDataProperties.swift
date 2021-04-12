//
//  Order+CoreDataProperties.swift
//  OrderManagementSystem
//
//  Created by iOS Developer on 12/04/21.
//
//

import Foundation
import CoreData


extension Order {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order")
    }

    @NSManaged public var customer_address: String?
    @NSManaged public var customer_name: String?
    @NSManaged public var customer_phone: String?
    @NSManaged public var order_due_date: String?
    @NSManaged public var order_number: String?
    @NSManaged public var total_amount: String?
    @NSManaged public var user_id: String?

}

extension Order : Identifiable {

}
