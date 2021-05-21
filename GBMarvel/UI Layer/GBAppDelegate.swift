//
//  AppDelegate.swift
//  GBMarvel
//
//  Created by Aditya Deshmane on 17/05/21.
//

import UIKit

@main
class GBAppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //Set an empty window to application
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        //Set Characterlist View Controller as root
        GBApplicationRouter.shared.launchCharacterListFlow()
        return true
    }
}
