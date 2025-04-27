//
//  AddItemTableViewController.swift
//  secureVault
//
//  Created by Simana Karkee on 18/11/2024.
//

import UIKit

class AddItemTableViewController: UITableViewController {

    
    @IBOutlet weak var sitenametxt: UITextField!
    @IBOutlet weak var usernametxt: UITextField!
    @IBOutlet weak var pwdtxt: UITextField!
    @IBOutlet weak var urltxt: UITextField!
    
    
    @IBAction func saveDetails(_ sender: UIButton) {
        guard let sitename = sitenametxt.text, let username = usernametxt.text, let pwd = pwdtxt.text, let url = urltxt.text else {
            self.alert(message: "All Fields are required")
            return
        }
        guard let dict = UserDefaults.standard.object(forKey: "LoginDetail") as? [String: Any] else {
            self.alert(message: "Something went wrong!!")
            return
        }
        guard let uid = dict["uid"] as? Int else {
            self.alert(message: "Something went wrong!!")
            return
        }
        
        let parameters:[String: Any] = [
            "sitename": sitename,
            "uname": username,
            "password": pwd,
            "url": "http://\(url)",
            "uid": "\(uid)"
        ]
        ApiService.shared.request(route: .savePassword,method: "POST", parameters: parameters) { data, response, error in
            if let err = error {
                DispatchQueue.main.async {
                    self.alert(message: err.localizedDescription)
                    return
                }
            }
            if let dat = data {
                do {
                    if let dict = try JSONSerialization.jsonObject(with: dat) as? [String: Any] {
                        if dict.keys.contains("error") {
                            let msg = dict["error"] as? String
                            DispatchQueue.main.async {
                                self.erralert(message: msg ?? "")
                                return
                            }
                        }
                        if dict.keys.contains("success") {
                            let msg = dict["success"] as? String
                            DispatchQueue.main.async {
                                self.alert(message: msg ?? "")
                                
                            }
                       
                        }
                    }
                }catch {
                    DispatchQueue.main.async {
                        self.alert(message: error.localizedDescription)
                    }
                    
                }
            }
                    
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [sitenametxt,
        usernametxt,
        pwdtxt,
         urltxt].forEach {
            $0?.delegate = self
        }
    }
    func erralert(message : String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    func alert(message : String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
  

}
extension AddItemTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
