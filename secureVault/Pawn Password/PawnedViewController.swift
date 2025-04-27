//
//  PawnedViewController.swift
//  secureVault
//
//  Created by Simana Karkee on 12/04/2025.
//

import UIKit

class PawnedViewController: UITableViewController {

    @IBOutlet weak var activityindicator: UIActivityIndicatorView!
    
    @IBOutlet weak var pawnedtxtfield: UITextField!
    
    @IBAction func checkbtn(_ sender: UIButton) {
        guard let text = pawnedtxtfield.text else {
            self.alert(message: "Text field is empty")
            return }
        self.activityindicator.isHidden = false
        self.activityindicator.startAnimating( )
        sender.isEnabled = false
        let data:[String:Any] = [
            "password":text
        ]
        ApiService.shared.request(route: .pawnedPasswords,method: "POST", parameters: data) { data, response, error in
            DispatchQueue.main.async {
                self.activityindicator.isHidden = true
                self.activityindicator.stopAnimating( )
                sender.isEnabled = true
            }
            if error != nil {
                DispatchQueue.main.async {
                   
                    self.alert(message: error?.localizedDescription ?? "something went wrong in pawned check")
                }
            } else {
                if let pawnedData = data {
                    let jsonData = try! JSONSerialization.jsonObject(with: pawnedData) as? [String: Any]
                   guard let condition = jsonData?.keys.contains("Yes") else {
                       DispatchQueue.main.async {
                         
                           self.alert(message: "Something went wrong on serialization while pawned")
                       }
                       return
                    }
                    if condition {
                        DispatchQueue.main.async {
                           
                            self.alert(message: "Password is pawned choose another password")
                        }
                    } else {
                        DispatchQueue.main.async {
                           
                            self.alert(message: "Password is not pawned good to go")
                        }
                      
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityindicator.isHidden = true
    }

    func alert(message : String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
  
}
