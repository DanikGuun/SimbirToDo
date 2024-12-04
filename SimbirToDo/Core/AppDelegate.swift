//
//  AppDelegate.swift
//  SimbirToDo
//
//  Created by Данила Бондарь on 02.12.2024.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navContoller = UINavigationController(rootViewController: TasksListController())
        navContoller.navigationBar.prefersLargeTitles = true
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navContoller
        window?.makeKeyAndVisible()
        return true
    }

}

