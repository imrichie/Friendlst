//
//  DataManager.swift
//  Friendlst
//
//  Created by Richie Flores on 11/5/22.
//

import Foundation

class DataManager {
    var friendsList = [Friend]()
    
    func loadSampleFriendData() {
        let friend1 = Friend()
        friend1.firstName = "Sophie"
        friend1.lastName = "Hodges"
        friend1.location = "Glendale, AZ"
        
        let friend2 = Friend()
        friend2.firstName = "Stewart"
        friend2.lastName = "Warren"
        friend2.location = "Palm Springs, CA"
        
        let friend3 = Friend()
        friend3.firstName = "Melanie"
        friend3.lastName = "Hill"
        friend3.location = "Austin, TX"
        
        friendsList.append(friend1)
        friendsList.append(friend2)
        friendsList.append(friend3)
    }
    
    func addFriend(newFriend: Friend) {
        friendsList.append(newFriend)
    }
}