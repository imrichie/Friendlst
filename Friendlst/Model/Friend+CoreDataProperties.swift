//
//  Friend+CoreDataProperties.swift
//  Friendlst
//
//  Created by Richie Flores on 11/25/22.
//
//

import Foundation
import CoreData


extension Friend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Friend> {
        return NSFetchRequest<Friend>(entityName: "Friend")
    }

    @NSManaged public var city: String
    @NSManaged public var comments: String?
    @NSManaged public var email: String?
    @NSManaged public var firstName: String
    @NSManaged public var lastName: String
    @NSManaged public var phoneNumber: String?
    @NSManaged public var profilePhoto: Data?
    @NSManaged public var state: String

}

extension Friend : Identifiable {

}
