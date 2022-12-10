//
//  SceneDelegate.swift
//  Friendlst
//
//  Created by Richie Flores on 10/13/22.
//

import UIKit
import CoreData 

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: - Instance Properties
    var window: UIWindow?
    var dataManager: DataManager = DataManager()
    
    // MARK: - Delegate Methods
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let navController = window!.rootViewController as! UINavigationController
        let mainViewController = navController.viewControllers.first! as! ViewController
        mainViewController.dataManager = dataManager
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        dataManager.saveData()
    }
}
