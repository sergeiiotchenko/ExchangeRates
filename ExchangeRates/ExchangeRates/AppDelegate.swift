//
//  AppDelegate.swift
//  ExchangeRates
//
//  Created by Сергей Иотченко on 13.02.21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        if let window = self.window {
            let mainTabBar = MainTabBarController()
            window.rootViewController = mainTabBar
            window.makeKeyAndVisible()
        }
        
        return true
    }
}
