//
//  PasswordViewController.swift
//  secureVault
//
//  Created by Simana Karkee on 11/12/2024.
//

import UIKit

class PasswordViewController: UITableViewController {
    var isAtZSet = false
    var isatzSet = false
    var is0t9Set = false
    var isuniqueCharSet = false
    var isNepalWordSet = false
    var defaultPasswordLength = 10
    var defaultPowerWord = 2
    var paraphraseIncludeNumber = false
    let nepaliWords = ["Mero","Timi","Hajur", "Bagmati", "Lalitpur", "Everest", "Kathmandu", "Pokhara", "Chitwan", "KHA", "GHAR", "TA", "TI", "TA"]
    @IBOutlet weak var lbl_password: UILabel!
    @IBOutlet weak var sth_uqichar: UISwitch!
    @IBOutlet weak var sth_AtZ: UISwitch!
    @IBOutlet weak var sth_atz: UISwitch!
    @IBOutlet weak var sth_0t9: UISwitch!
    @IBOutlet weak var sth_nepword: UISwitch!
    @IBOutlet weak var lbl_length: UILabel!
    
    @IBOutlet weak var wordcountSlider: UISlider!
    @IBOutlet weak var lbl_paraphrasewordCounter: UILabel!
    @IBOutlet weak var lbl_generatedParaphrasePassword: UILabel!
    @IBOutlet weak var switchNumberinword: UISwitch!
    
    @IBAction func paraphrasewordNumberswitch(_ sender: UISwitch) {
        if sender.isOn {
            self.paraphraseIncludeNumber = true
        }
    }
    
    @IBAction func wordCountSlider(_ sender: UISlider) {
        defaultPowerWord = Int(sender.value)
        lbl_paraphrasewordCounter.text = "\(defaultPowerWord)"
        
    }
    
    @IBAction func btnGenerateParaphrasePassword(_ sender: UIButton) {
        var generatedPassword = ""
        let words = Array(nepaliWords.shuffled().prefix(defaultPowerWord))
        if paraphraseIncludeNumber {
            generatedPassword = words.reduce("") { $0 + $1 + String(Int.random(in: 0...9)) + String("!@#$%^&*()_+-=[]{}|;:,.<>?".randomElement()!)}
        } else {
            generatedPassword = words.reduce("") { $0 + $1 + String("!@#$%^&*()_+-=[]{}|;:,.<>?".randomElement()!)}
        }
        self.lbl_generatedParaphrasePassword.text = generatedPassword
    }
    
    @IBAction func btnCopyParaphasePassword(_ sender: Any) {
        UIPasteboard.general.string = self.lbl_generatedParaphrasePassword.text
    }
    
    @IBAction func sliderchanged(_ sender: UISlider) {
        lbl_length.text = "\(Int(sender.value))"
        defaultPasswordLength = Int(sender.value)
    }
    @IBAction func toggleswitch(_ sender: UISwitch) {
        if sender.tag == 0 {
            if sender.isOn {
                isAtZSet = true
            } else {
                isAtZSet = false
            }
        } else if sender.tag == 1 {
            if sender.isOn {
                isatzSet = true
            } else {
                isatzSet = false
            }
        } else if sender.tag == 2 {
            if sender.isOn {
                is0t9Set = true
            } else {
                is0t9Set = false
            }
        } else if sender.tag == 3 {
            if sender.isOn {
                isuniqueCharSet = true
            } else {
                isuniqueCharSet = false
            }
        } else {
            if sender.isOn {
                isNepalWordSet = true
            } else {
                isNepalWordSet = false
            }
        }
    }
    
    @IBAction func btn_copy(_ sender: UIButton) {
        UIPasteboard.general.string = lbl_password.text
    }
    
    @IBAction func btn_regererate(_ sender: UIButton) {
        if !isatzSet && !isAtZSet && !is0t9Set && !isNepalWordSet && !isuniqueCharSet {
            self.lbl_password.text = "generated password"
            let alert = UIAlertController(title: "Error", message: "Select atleast one option to generate a strong password", preferredStyle: .alert)
             let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true)

        } else {
            var generatedPassword = [String]()
            var compositepassword = ""
           
            if isAtZSet {
                compositepassword += "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
            }
            if isatzSet {
                compositepassword += "abcdefghijklmnopqrstuvwxyz"
            }
            if is0t9Set {
                compositepassword += "01234567890"
            }
            if isuniqueCharSet {
                compositepassword += "!@#$%^&*()_+-=[]{}|;:,.<>?"
            }
            if isNepalWordSet {
                if is0t9Set || isatzSet || isAtZSet || isuniqueCharSet {
                    let validWord = nepaliWords.filter({ $0.count <= defaultPasswordLength})
                    if let nepaliword = validWord.randomElement() {
                        generatedPassword.append(nepaliword)
                    }
                } else {
                    let alert = UIAlertController(title: "Error", message: "Select atleast one option to generate a strong nepali word password", preferredStyle: .alert)
                     let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                    return
                }
               
            }
            if !compositepassword.isEmpty {
                let remainingLen = max(0,defaultPasswordLength - generatedPassword.reduce(0){ $0 + $1.count})
                for _ in 0..<remainingLen {
                    if let word = compositepassword.randomElement() {
                        generatedPassword.append(String(word))
                    }
                }
            }
            self.lbl_password.text = generatedPassword.shuffled().joined()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sth_AtZ.isOn = false
        sth_atz.isOn = false
        sth_0t9.isOn = false
        sth_nepword.isOn = false
        sth_uqichar.isOn = false
        switchNumberinword.isOn = false
        // Do any additional setup after loading the view.
    }
}
