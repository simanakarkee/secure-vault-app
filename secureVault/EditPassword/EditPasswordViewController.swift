//
//  EditPasswordViewController.swift
//  secureVault
//
//  Created by Simana Karkee on 12/04/2025.
//

import UIKit

class EditPasswordViewController: UITableViewController {
    var passModal: PasswordModal?
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var uname: UITextField!
    @IBOutlet weak var sitename: UITextField!
    @IBOutlet weak var url: UITextField!
    
    @IBAction func btn_update(_ sender: UIButton) {
        guard let pwd = password.text else {
            self.alert(msg: "Password Required", title: nil)
            return }
        guard let uname = uname.text else {
            self.alert(msg: "Username Required", title: nil)
            return }
        guard let sitename = sitename.text else {
            self.alert(msg: "Sitename Required", title: nil)
            return }
        guard let url = url.text else {
            self.alert(msg: "URL Required", title: nil)
            return }
        guard let id = passModal?.id else {
            self.alert(msg: "Something went wrong", title: "Error")
            return
        }
        let param:[String: Any] = [
            "password":pwd,
            "uname":uname,
            "sitename":sitename,
            "url":url,
            "uid":id
        ]
        ApiService.shared.request(route: .editPassword, method: "POST", parameters: param) { data, response, error in
            guard error != nil else {
                self.alert(msg: error?.localizedDescription ?? "", title: "error")
                return
            }
            guard let dat = data else {
                self.alert(msg: "error in server response", title: "error")
                return
            }
            let jsond = try! JSONSerialization.jsonObject(with: dat, options: []) as! [String: Any]
            if jsond["status"] as! String == "success" {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        password.text = passModal?.password
        uname.text = passModal?.username
        sitename.text = passModal?.sitename
        url.text = passModal?.url
    }
    func alert(msg: String, title: String?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
    }

}
