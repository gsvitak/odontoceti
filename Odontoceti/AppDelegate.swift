//
//  AppDelegate.swift
//  Odontoceti
//
//  Created by Gregory Foster on 2/12/17.
//  Copyright © 2017 Greg M Foster. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {

        // Set up the tab bar and it's view controllers.
        let sensorsViewController = SensorsViewController()
        let cartographerViewController = CartographerViewController()
        let mapViewController = MapViewController()
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([cartographerViewController,
                                             mapViewController,
                                             sensorsViewController], animated: false)
        _ = MagnetDataSource.sharedSensor

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()

        return true
    }
}
