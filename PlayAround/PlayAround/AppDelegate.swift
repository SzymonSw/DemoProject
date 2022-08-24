//
//  AppDelegate.swift
//  PlayAround
//
//  Created by Szymon Swietek on 29/07/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let mainNav = UINavigationController()
        window?.rootViewController = mainNav
        window?.makeKeyAndVisible()
        appCoordinator = AppCoordinator()
        appCoordinator.startWith(rootNavController: mainNav)

        return true
    }
}
