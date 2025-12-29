//
//  AppDelegate.swift
//  MahjongKitchen
//
//  Created by Ray Meyer on 10/1/21.
//

import UIKit
import Purchases

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var maj = Maj()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "oVYVOmJIUymSlEvBiDYUMNPnWIHhUwPk")
        return true
    }
}

