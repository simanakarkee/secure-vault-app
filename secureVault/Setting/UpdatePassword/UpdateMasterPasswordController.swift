//
//  UpdateMasterPasswordController.swift
//  secureVault
//
//  Created by Simana Karkee on 22/04/2025.
//

import UIKit

class UpdateMasterPasswordController: UIViewController {

    @IBOutlet weak var txtMasterPassword: UITextField!
    
    @IBAction func showpwd(_ sender: UIButton) {
        txtMasterPassword.isSecureTextEntry.toggle()
    }
    
    @IBAction func resetBtn(_ sender: UIButton) {
        guard let password = self.txtMasterPassword.text else {
            return
        }
        if !is_Strong_Pass(word: password) {
            self.alert(message: "Password not in correct format", title: "Error")
            return
        }
        guard let detail = UserDefaults.standard.object(forKey: "LoginDetail") as? [String:Any] else {
            return
        }
        let uid = detail["uid"] as! Int
        let param:[String: Any] = [
            "password":password,
            "uid": uid
        ]
        ApiService.shared.request(route: .updatePassword, method: "POST", parameters: param) { data, response, error in
            guard let dat = data else {return}
            guard let dict = try? JSONSerialization.jsonObject(with: dat, options: []) as? [String:Any] else {return}
            if dict.keys.contains("success"){
                self.alert(message: "Master password changed successfully", title: "Success")
            } else {
                self.alert(message: "Something went wrong with the updation process", title: "Error")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let detail = UserDefaults.standard.object(forKey: "LoginDetail") as? [String: Any] else {
            return
        }
        txtMasterPassword.text = detail["password"] as? String ?? ""
    }
    
    func is_Strong_Pass(word: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*])[A-Za-z\\d!@#$%^&*]{8,}$"
        let validPassword = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return validPassword.evaluate(with: word)
    }
    func alert(message : String, title : String = "") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

}
