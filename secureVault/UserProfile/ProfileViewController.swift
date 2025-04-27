//
//  ProfileViewController.swift
//  secureVault
//
//  Created by Simana Karkee on 11/12/2024.
//

import UIKit

class ProfileViewController: UITableViewController {

    @IBOutlet weak var profileuser: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let logindetail = UserDefaults.standard.object(forKey: "LoginDetail") as? [String: Any] else {
            return
        }
        profileuser.text = logindetail["email"] as? String
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
