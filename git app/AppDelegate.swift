//
//  AppDelegate.swift
//  git app
//
//  Created by Henry Silva Olivo on 1/15/20.
//  Copyright © 2020 hsilva. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let centerViewController = MasterViewController(nibName: "MasterViewController", bundle: nil)
        let navigationController = GLGeneralNavigationController(rootViewController: centerViewController)
        //navigationController.setNavigationBarHidden(true, animated: false)
        window!.rootViewController = navigationController
        window!.makeKeyAndVisible()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    


}

