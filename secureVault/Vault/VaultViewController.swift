//
//  VaultViewController.swift
//  secureVault
//
//  Created by Simana Karkee on 11/12/2024.
//

import UIKit

class VaultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var passwordModals:[PasswordModal]? {
        didSet{
            self.tableview.reloadData()
        }
    }

    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self
       
        let rightBarItem = UIBarButtonItem(image: UIImage.add, style: .done, target: self, action: #selector(add))
        self.navigationItem.rightBarButtonItem = rightBarItem
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }
    func loadData() {
        guard let loginDetail = UserDefaults.standard.object(forKey: "LoginDetail") as? [String: Any] else {
            return
        }
        let uid = loginDetail["uid"] as! Int
        let dict = [
            "uid": uid
        ]
        ApiService.shared.request(route: .getAllPasswords,method: "POST", parameters: dict) { data, response, error in
            if let err = error {
                DispatchQueue.main.async {
                    self.alert(message: err.localizedDescription)
                }
                return
            }
            if let dat = data {
                do {
                    let passwordModal = try JSONDecoder().decode([PasswordModal].self, from: dat)
                    DispatchQueue.main.async {
                        self.passwordModals = passwordModal
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.alert(message: "Unable to decode the modal!!")
                    }
                }
            }
        }
    }
    
    func alert(message : String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func add() {
        let addItemstory = UIStoryboard(name: "AddItem", bundle: nil)
        let addItemVC = addItemstory.instantiateViewController(withIdentifier: "AddItemTableViewController")
        self.navigationController?.pushViewController(addItemVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.passwordModals?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableViewCell = self.tableview.dequeueReusableCell(withIdentifier: "PasswordListTableViewCell", for: indexPath) as? PasswordListTableViewCell else {
            return UITableViewCell()
        }
        tableViewCell.lblName.text = self.passwordModals?[indexPath.row].sitename ?? ""
        tableViewCell.lblemail.text = self.passwordModals?[indexPath.row].url ?? ""
        tableViewCell.lblimageview.image = ApiService.SocialSite(logo: (self.passwordModals?[indexPath.row].sitename)?.lowercased() ?? "")?.image
        return tableViewCell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Edit") { action, view, completion in
            let storyboard = UIStoryboard(name: "EditPassword", bundle: nil)
            let editVC = storyboard.instantiateViewController(withIdentifier: "EditPasswordViewController") as! EditPasswordViewController
            editVC.passModal = self.passwordModals?[indexPath.row]
            self.navigationController?.pushViewController(editVC, animated: true)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "ShowPassword", bundle: nil)
        guard let showPasswordVC = storyboard.instantiateViewController(withIdentifier: "ShowPasswordViewController") as? ShowPasswordViewController else {
            self.alert(message: "didnot show the showPasswordVC")
            return
        }
        showPasswordVC.modal = ShowPasswordViewController.SocialSiteDetail(socialImage: ApiService.SocialSite(logo: (self.passwordModals?[indexPath.row].sitename)?.lowercased() ?? "")?.image ?? UIImage(),
                                                                            username: self.passwordModals?[indexPath.row].username ?? "",
                                                                           url: self.passwordModals?[indexPath.row].url ?? "",
                                                                           password: self.passwordModals?[indexPath.row].password ?? "",
                                                                           sitename: self.passwordModals?[indexPath.row].sitename ?? "")
        self.navigationController?.pushViewController(showPasswordVC, animated: true)
        
    }
}

struct PasswordModal: Codable {
    var id: Int?
    var sitename: String?
    var username: String?
    var password: String?
    var url: String?
}
