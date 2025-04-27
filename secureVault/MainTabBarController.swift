//
//  MainTabBarController.swift
//  secureVault
//
//  Created by Simana Karkee on 11/12/2024.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        // Do any additional setup after loading the view.
        
    }
    func setupViewController() {
        let vaultStoryboard = UIStoryboard(name: "Vault", bundle: nil)
        let vaultVC = vaultStoryboard.instantiateViewController(withIdentifier: "VaultViewController")
        vaultVC.tabBarItem.title = "Vault"
        vaultVC.tabBarItem.image = UIImage(named: "password")
        let vaultNavVC = UINavigationController(rootViewController: vaultVC)
      
        
        
        let profilestoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileVC = profilestoryboard.instantiateViewController(withIdentifier: "ProfileViewController")
        profileVC.tabBarItem.title = "Profile"
        profileVC.tabBarItem.image = UIImage(named: "lock")
        let profileNavVC = UINavigationController(rootViewController: profileVC)
        
        let settingboard = UIStoryboard(name: "Setting", bundle: nil)
        let settingVC = settingboard.instantiateViewController(withIdentifier: "SettingViewController")
        settingVC.tabBarItem.title = "Setting"
        settingVC.tabBarItem.image = UIImage(named: "setting")
        let settingNavVC = UINavigationController(rootViewController: settingVC)
        
        let passwordboard = UIStoryboard(name: "Password", bundle: nil)
        let passwordVC = passwordboard.instantiateViewController(withIdentifier: "PasswordViewController")
        passwordVC.tabBarItem.title = "Password Generator"
        passwordVC.tabBarItem.image = UIImage(named: "bio")
        let passwordNavVC = UINavigationController(rootViewController: passwordVC)
        
        let pawnedPassword = UIStoryboard(name: "PawnedPassword", bundle: nil)
        let pawnedPasswordVC = pawnedPassword.instantiateViewController(withIdentifier: "PawnedViewController")
        pawnedPasswordVC.tabBarItem.title = "Security"
        pawnedPasswordVC.tabBarItem.image = UIImage(named: "security")
        let pawnedPasswordNavVC = UINavigationController(rootViewController: pawnedPasswordVC)
        
        viewControllers = [vaultNavVC,passwordNavVC,pawnedPasswordNavVC,profileNavVC,settingNavVC]
        
    }
   

   

}
