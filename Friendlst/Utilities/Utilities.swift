//
//  Constants.swift
//  Friendlst
//
//  Created by Richie Flores on 10/13/22.
//

import Foundation

struct Constants {
    struct CellNames {
        static let friendCell = "FriendCell"
        static let defaultCell = "ListCell"
    }
    
    struct SegueNames {
        static let addFriendSegue = "AddFriendSeque"
        static let editFriendSegue = "EditFriendSegue"
    }
    
    struct ControllerNames {
        static let mainViewController = "ViewController"
        static let addFriendViewController = "AddFriendViewController"
    }
}

struct Persistance {
    static func getDocumentsDirectory() -> URL {
        return URL.documentsDirectory
    }
    
    static func getDataFilePath() -> URL {
        return Persistance.getDocumentsDirectory().appending(path: "Friends.plist")
    }
}
