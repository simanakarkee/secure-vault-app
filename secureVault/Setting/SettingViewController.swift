//
//  SettingViewController.swift
//  secureVault
//
//  Created by Simana Karkee on 11/12/2024.
//

import UIKit

class SettingViewController: UITableViewController {

    
    @IBOutlet weak var darkmodebtn: UISwitch!
    
    @IBAction func btnSwitchDarkMode(_ sender: Any) {
        if darkmodebtn.isOn {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
    }
    
    @IBAction func biometricbtn(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: "biometric")
        } else {
            UserDefaults.standard.set(false, forKey: "biometric")
        }
        
    }
    @IBAction func btnLogout(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "LoginDetail")
        UserDefaults.standard.set(false, forKey: "IsLoginIn")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "ViewController")
        let rootNavigationController = UINavigationController(rootViewController: vc)
        AppManager.shared.window?.rootViewController = rootNavigationController
        AppManager.shared.window?.makeKeyAndVisible()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        darkmodebtn.isOn = false
        
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 && indexPath.row == 0 {
            // delete account
            self.delete()
        } else if indexPath.section == 2 && indexPath.row == 1 {
            // reset master password
            let updateStoryboard = UIStoryboard(name: "UpdatePassword", bundle: nil)
            guard let updatePwdVC = updateStoryboard.instantiateViewController(withIdentifier: "UpdateMasterPasswordController") as? UpdateMasterPasswordController else {
                print("Error on updateMasterPasswordController")
                return
            }
            self.navigationController?.pushViewController(updatePwdVC, animated: true)
            
        }
    }
    func delete(){
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete ? Deleting account will delete all your data", preferredStyle: .alert)
        let okbtn = UIAlertAction(title: "OK", style: .default) { btn in
            guard let loginDetail = UserDefaults.standard.object(forKey: "LoginDetail") as? [String: Any] else {
                return
            }
            let uid = loginDetail["uid"] as! Int
            let param = [
                "uid": uid
            ]
            ApiService.shared.request(route: .deleteAccount, method: "POST", parameters: param) { data, response, error in
                if let err = error {
                    DispatchQueue.main.async {
                        self.alert(message: err.localizedDescription)
                    }
                }
                if let dat = data {
                    do {
                        let dict = try JSONSerialization.jsonObject(with: dat) as! [String: String]
                        if dict.keys.contains( "error" ) {
                            DispatchQueue.main.async {
                                self.alert(message: dict["error"] ?? "")
                            }
                        } else {
                            DispatchQueue.main.async {
                                UserDefaults.standard.set(nil, forKey: "LoginDetail")
                                UserDefaults.standard.set(false, forKey: "IsLoginIn")
                                let main = UIStoryboard(name: "Main", bundle: nil)
                                let vc = main.instantiateViewController(withIdentifier: "ViewController")
                                AppManager.shared.window?.rootViewController = UINavigationController(rootViewController: vc)
                                AppManager.shared.window?.makeKeyAndVisible()
                            }
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self.alert(message: error.localizedDescription)
                        }
                    }
                }
            }
        }
        let cancelbtn = UIAlertAction(title: "cancel", style: .cancel)
        alert.addAction(okbtn)
        alert.addAction(cancelbtn)
        self.present(alert, animated: true)
    }
    func alert(message : String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}
