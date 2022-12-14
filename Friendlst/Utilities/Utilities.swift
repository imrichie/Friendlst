//
//  Constants.swift
//  Friendlst
//
//  Created by Richie Flores on 10/13/22.
//

import Foundation

struct Constants {
    struct CellNames {
        static let customFriendCell = "CustomFriendCell"
        static let emptyTableViewCell = "EmptyTableViewCell"
    }
    
    struct SegueNames {
        static let addFriendSegue = "AddFriendSeque"
        static let editFriendSegue = "EditFriendSegue"
    }
    
    struct ControllerNames {
        static let mainViewController = "ViewController"
        static let addFriendViewController = "AddFriendViewController"
    }
    
    struct CoreDataNames {
        static let dataModel = "Friendlst"
        static let entityName = "Friend"
    }
    
    struct CustomViewNames {
        static let emptyStateView = "EmptyStateView"
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
