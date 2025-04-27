//
//  AppDelegate.swift
//  secureVault
//
//  Created by Simana Karkee on 18/11/2024.
//

import UIKit


class AppManager {
    static let shared = AppManager()
    var window: UIWindow?
    private init() {}
}
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
         window = UIWindow(frame: UIScreen.main.bounds)
         AppManager.shared.window = self.window
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController")
        let rootnavigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = rootnavigationController
        window?.makeKeyAndVisible()
//        if UserDefaults.standard.bool(forKey: "IsLoginIn") == true {
//            window?.rootViewController = MainTabBarController()
//            window?.makeKeyAndVisible()
//        } else {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController")
//            let rootnavigationController = UINavigationController(rootViewController: viewController)
//            window?.rootViewController = rootnavigationController
//            window?.makeKeyAndVisible()
//        }
      
        
        return true
    }
}


