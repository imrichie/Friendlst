//
//  DataManager.swift
//  Friendlst
//
//  Created by Richie Flores on 11/15/22.
//

import Foundation
import CoreData

class DataManager {
    var managedObjectContext: NSManagedObjectContext!
    var listOfFriends: [NSManagedObject] = []
    
    func addFriend(newFriend: NSManagedObject) {
        listOfFriends.append(newFriend)
    }
    
    func saveFriend() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                fatalError(">>> ERROR SAVING DATA: \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
