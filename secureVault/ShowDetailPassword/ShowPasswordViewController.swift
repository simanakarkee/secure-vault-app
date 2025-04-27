//
//  ShowPasswordViewController.swift
//  secureVault
//
//  Created by Simana Karkee on 08/04/2025.
//

import UIKit
import LocalAuthentication

class ShowPasswordViewController: UITableViewController {
    
    @IBOutlet weak var imgSocial: UIImageView!
    @IBOutlet weak var appNAme: UILabel!
    @IBOutlet weak var sitename: UILabel!
    @IBOutlet weak var siteurl: UILabel!
    @IBOutlet weak var siteusername: UILabel!
    @IBOutlet weak var sitePassword: UITextField!
    
    struct SocialSiteDetail {
        var socialImage: UIImage?
        var username: String?
        var url: String?
        var password: String?
        var sitename: String?
    }
    var modal: SocialSiteDetail?
    
    
    @IBAction func eyeBtn(_ sender: Any) {
        if sitePassword.isSecureTextEntry {
            let context = LAContext()
            var error:NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Authenticate to view your saved password"
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                    DispatchQueue.main.async {
                        if success {
                            self.sitePassword.isSecureTextEntry = false
                        } else {
                            let alert = UIAlertController(title: "Authentication Failed", message: "Face ID could not authenticate you.", preferredStyle: .alert)
                               alert.addAction(UIAlertAction(title: "OK", style: .default))
                               self.present(alert, animated: true)
                        }
                    }
                }
            } else {
                let alert = UIAlertController(title: "Unavailable", message: "Face ID not available on this device.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default))
                self.present(alert, animated: true)
            }
        } else {
            self.sitePassword.isSecureTextEntry = true
        }
           
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sitePassword.text = "12345"
        self.show()
        // Do any additional setup after loading the view.
    }
    
    func show() {
        self.imgSocial.image = modal?.socialImage
        self.appNAme.text = modal?.sitename
        self.siteurl.text = modal?.url
        self.sitename.text = modal?.sitename
        self.siteusername.text = modal?.username
    }


    

}
