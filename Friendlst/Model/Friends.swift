//
//  DummyData.swift
//  Friendlst
//
//  Created by Richie Flores on 10/19/22.
//

import Foundation

class Friends: NSObject, Codable {
    
    var firstName = String()
    var lastName = String()
    var location = String()
    
    var email: String?
    var phoneNumber: String?    
    var comments: String?
}
