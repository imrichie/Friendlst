//
//  DataManager.swift
//  Friendlst
//
//  Created by Richie Flores on 11/15/22.
//

import Foundation
import CoreData

class DataManager {
    lazy var managedObjectContext = persistentContainer.viewContext
    var listOfFriends: [NSManagedObject] = []
    
    // Adding a Friend
    func addFriend(newFriend: NSManagedObject) {
        listOfFriends.append(newFriend)
    }
    
    // Deleting a Friend
    func deleteFriend(friend: NSManagedObject) {
        self.managedObjectContext.delete(friend)
    }
    
    // Saving data
    func saveData() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                fatalError(">>> CORE DATA Failed to save data: \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // Fetch data
    func fetchData() {
        let fetchRequest = Friend.fetchRequest()
        
        do {
            listOfFriends = try managedObjectContext.fetch(fetchRequest)
        } catch {
            fatalError(">>> CORE DATA Failed to fetch data \(error.localizedDescription)")
        }
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Friendlst")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}
