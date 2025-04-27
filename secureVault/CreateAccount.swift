//
//  CreateAccount.swift
//  secureVault
//
//  Created by Simana Karkee on 18/11/2024.
//

import UIKit

class CreateAccount: UIViewController {

    @IBOutlet weak var btnCreateAccount: UIButton!
    @IBOutlet weak var imgCheckView: UIImageView!
    @IBOutlet weak var agreeView: UIView!
    
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var retypePassword: UITextField!
    
    @IBOutlet weak var activityindicator: UIActivityIndicatorView!
    var byDefault: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        self.imgCheckView.image = nil
        btnCreateAccount.isEnabled = false
        activityindicator.isHidden = true
        self.emailAddress.delegate = self
        self.password.delegate = self
        self.retypePassword.delegate = self
//        let rightBarButton = UIBarButtonItem(
//               title: "Create Account",
//               style: .plain,
//               target: self,
//               action: #selector(handleButtonTap)
//           )
//        self.navigationItem.rightBarButtonItem = rightBarButton
        // Do any additional setup after loading the view.
    }
    
//    @objc func handleButtonTap() {
//        let alert = UIAlertController(title: "success", message: "Saved", preferredStyle: .alert)
//         let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alert.addAction(action)
//        self.present(alert, animated: true)
//    }
    
    @IBAction func btncreate(_ sender: UIButton) {
        guard let email = emailAddress.text, let password = password.text, let retypePassword = retypePassword.text else {
            self.alert(message: "Email address and Password required")
            return
        }
        if !is_Valid_Email(email: email) {
            self.alert(message: "invalid Email address")
            return
        }
        if !is_Strong_Pass(word: password) {
            self.alert(message: "invalid password")
            return
        }
        if password != retypePassword {
            self.alert(message: "Password not matched")
            return
        }
        self.activityindicator.isHidden = false
        self.activityindicator.startAnimating()
        self.btnCreateAccount.isEnabled = false
        let dataDict = [
            "email": email,
            "master_password": password
        ]
        ApiService.shared.request(route: .register, method: "POST",parameters: dataDict) { data, response, error in
            if let err = error {
                DispatchQueue.main.async {
                    self.activityindicator.stopAnimating()
                    self.activityindicator.isHidden = true
                    self.btnCreateAccount.isEnabled = true
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
                               self.btnCreateAccount.isEnabled = true
                               self.alert(message: dict?.values.first as? String ?? "")
                           }
                       } else {
                           if httpResponse.statusCode == 201 {
                               if dict?.keys.first == "success" {
                                   DispatchQueue.main.async {
                                       let alert = UIAlertController(title: "Success", message: dict?.values.first as? String ?? "", preferredStyle: .alert)
                                       let action = UIAlertAction(title: "Ok", style: .default) { _ in
                                           self.activityindicator.stopAnimating()
                                           self.activityindicator.isHidden = true
                                           self.btnCreateAccount.isEnabled = true
                                           self.navigationController?.popViewController(animated: true)
                                       }
                                       alert.addAction(action)
                                       self.present(alert, animated: true)
                                   }
                                  
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
    @IBAction func btnAgree(_ sender: UIButton) {
        if byDefault == false {
            imgCheckView.image = UIImage(named: "check")
            self.byDefault = true
            btnCreateAccount.isEnabled = true
        } else {
            imgCheckView.image = nil
            self.byDefault = false
            btnCreateAccount.isEnabled = false
        }
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
extension CreateAccount: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
