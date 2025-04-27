//
//  ViewController.swift
//  secureVault
//
//  Created by Simana Karkee on 18/11/2024.
//

import UIKit
import LocalAuthentication
import Security

class ViewController: UIViewController {

    @IBOutlet weak var twofactorview: UIView!
    @IBOutlet weak var signinfaceit: UIButton!
    @IBOutlet weak var txtfield_email: UITextField!
    @IBOutlet weak var txtfield_password: UITextField!
    @IBOutlet weak var activityindicator: UIActivityIndicatorView!
    @IBOutlet weak var btnLogin: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = ""
        txtfield_email.delegate = self
        activityindicator.isHidden = true
        twofactorview.isHidden = true
        signinfaceit.isHidden = false
//        if let faceid = UserDefaults.standard.object(forKey: "biometric") as? Bool {
//            if faceid {
//                signinfaceit.isHidden = false
//            } else {
//                signinfaceit.isHidden = true
//            }
//        } else {
//            signinfaceit.isHidden = true
//        }
    }

    @IBAction func btnfaceid(_ sender: UIButton) {
        let context = LAContext()
        var error:NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Login with Face ID") { success, error in
                    DispatchQueue.main.async {
                        if success {
                            UserDefaults.standard.set(true, forKey: "IsLoginIn")
                            print("Face ID authenticated successfully")
                            let mainvc = MainTabBarController()
                            AppManager.shared.window?.rootViewController = mainvc
                            UIView.transition(with: AppManager.shared.window!, duration: 0.5, options: .curveEaseInOut, animations: nil, completion: nil)
                        } else {
                            let alertVC = UIAlertController(title: "Login Error", message: "Face ID Failed", preferredStyle: .alert)
                            let action = UIAlertAction(title: "Ok", style: .cancel) { _ in
                                self.twofactorview.isHidden = false
                                UserDefaults.standard.set(nil, forKey: "LoginDetail")
                            }
                            alertVC.addAction(action)
                            self.present(alertVC, animated: true)
                            
                        }
                    }
                }
            }
        }
    
    @IBAction func btn_continue(_ sender: UIButton) {
        // api
        guard let email = txtfield_email.text, let password = txtfield_password.text else {
            self.alert(message: "Email address and Password required")
            return
        }
        if !is_Valid_Email(email: email) {
            self.alert(message: "invalid Email address")
            return
        }
        self.activityindicator.isHidden = false
        self.activityindicator.startAnimating()
        self.btnLogin.isEnabled = false
        let dataDict = [
            "email": email,
            "password": password
        ]
        ApiService.shared.request(route: .login, method: "POST",parameters: dataDict) { data, response, error in
            if let err = error {
                DispatchQueue.main.async {
                    self.activityindicator.stopAnimating()
                    self.activityindicator.isHidden = true
                    self.btnLogin.isEnabled = true
                    self.alert(message: err.localizedDescription)
                }
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }
           if let data = data {
                   do {
                       let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                       if dict?.keys.first == "error" {
                           DispatchQueue.main.async{
                               self.activityindicator.stopAnimating()
                               self.activityindicator.isHidden = true
                               self.btnLogin.isEnabled = true
                               self.alert(message: dict?.values.first as? String ?? "")
                           }
                       } else {
                           if httpResponse.statusCode == 200 {
                               
                               if let faceid = UserDefaults.standard.object(forKey: "biometric") as? Bool {
                                           if faceid {
                                               UserDefaults.standard.set(dict, forKey: "LoginDetail")
                                               self.twofactorview.isHidden = false
                                           } else {
                                               if let loginDetail = dict {
                                                   UserDefaults.standard.set(loginDetail, forKey: "LoginDetail")
                                                   UserDefaults.standard.set(true, forKey: "IsLoginIn")
                                                   DispatchQueue.main.async {
                                                           self.activityindicator.stopAnimating()
                                                           self.activityindicator.isHidden = true
                                                           self.btnLogin.isEnabled = true
                                                       AppManager.shared.window?.rootViewController = MainTabBarController()
                                                       UIView.transition(with: AppManager.shared.window!, duration: 0.5, options: .curveEaseInOut, animations: nil, completion: nil)
                                                       
                                                   }
                                                  
                                               }
                                           }
                                       } else {
                                           
                                           if let loginDetail = dict {
                                               UserDefaults.standard.set(loginDetail, forKey: "LoginDetail")
                                               UserDefaults.standard.set(true, forKey: "IsLoginIn")
                                               DispatchQueue.main.async {
                                                       self.activityindicator.stopAnimating()
                                                       self.activityindicator.isHidden = true
                                                       self.btnLogin.isEnabled = true
                                                   AppManager.shared.window?.rootViewController = MainTabBarController()
                                                   UIView.transition(with: AppManager.shared.window!, duration: 0.5, options: .curveEaseInOut, animations: nil, completion: nil)
                                                   
                                               }
                                              
                                           }
                                       }
                           
                           }
                       }
                   } catch {
                       DispatchQueue.main.async {
                           self.alert(message: error.localizedDescription)
                       }
                   }

               
            }
        }
//        if txtfield_email.text == "user@email.com" {
//           
//            AppManager.shared.window?.rootViewController = MainTabBarController()
//            UIView.transition(with: AppManager.shared.window!, duration: 0.5, options: .curveEaseInOut, animations: nil, completion: nil)
//        } else {
//            let alertVC = UIAlertController(title: "Error", message: "Wrong email", preferredStyle: .alert)
//            let btn_ok = UIAlertAction(title: "ok", style: .default)
//            alertVC.addAction(btn_ok)
//            self.present(alertVC, animated: true)
//        }
    }
    @IBAction func BtnCreateAccount(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "CreateAccount", bundle: nil)
        let createAccountVC = storyboard.instantiateViewController(withIdentifier: "CreateAccount")
        self.navigationController?.pushViewController(createAccountVC, animated: true)
    }
    func is_Valid_Email(email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let validEmail = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return validEmail.evaluate(with: email)
    }
    func is_Strong_Pass(word: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*])[A-Za-z\\d!@#$%^&*]{8,}$"
        let validPassword = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return validPassword.evaluate(with: word)
    }
    func alert(message : String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


//func saveToKeychain(key: String, value: String) {
//    if let data = value.data(using: .utf8) {
//        let query: [String: Any] = [
//            kSecClass as String: kSecClassGenericPassword,
//            kSecAttrAccount as String: key,
//            kSecValueData as String: data
//        ]
//        
//        // Delete any existing item with same key
//        SecItemDelete(query as CFDictionary)
//        
//        // Add new item
//        let status = SecItemAdd(query as CFDictionary, nil)
//        
//        if status == errSecSuccess {
//            print("Saved successfully!")
//        } else {
//            print("Error saving to Keychain: \(status)")
//        }
//    }
//}
//func getFromKeychain(key: String) -> String? {
//    let query: [String: Any] = [
//        kSecClass as String: kSecClassGenericPassword,
//        kSecAttrAccount as String: key,
//        kSecReturnData as String: true,
//        kSecMatchLimit as String: kSecMatchLimitOne
//    ]
//    
//    var dataTypeRef: AnyObject?
//    let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
//    
//    if status == errSecSuccess {
//        if let data = dataTypeRef as? Data,
//           let value = String(data: data, encoding: .utf8) {
//            return value
//        }
//    }
//    
//    return nil
//}
//func deleteFromKeychain(key: String) {
//    let query: [String: Any] = [
//        kSecClass as String: kSecClassGenericPassword,
//        kSecAttrAccount as String: key
//    ]
//    
//    let status = SecItemDelete(query as CFDictionary)
//    
//    if status == errSecSuccess {
//        print("Deleted successfully!")
//    } else {
//        print("Error deleting from Keychain: \(status)")
//    }
//}
