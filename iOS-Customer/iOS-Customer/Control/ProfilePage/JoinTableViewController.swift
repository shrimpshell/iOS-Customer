//
//  JoinTableViewController.swift
//  iOS-Customer
//
//  Created by Una Lee on 2018/10/9.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit

class JoinTableViewController: UITableViewController {
    
    let customerTask = CustomerAuth()
    var email = ""
    
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var rePasswordField: UITextField!
    @IBOutlet weak var genderSegmented: UISegmentedControl!
    @IBOutlet weak var birthdayLable: UILabel!
    @IBOutlet weak var birthdayDatePicker: UIDatePicker!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    
    let birthdayTitle = IndexPath(row: 0, section: 5)
    
    var birthdayShow = false {
        didSet {
            birthdayDatePicker.isHidden = !birthdayShow
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    //BirthdayPicker Hidden Change
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case birthdayTitle:
            tableView.beginUpdates()
            birthdayShow = !birthdayShow
            tableView.endUpdates()
            
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Birthday Heigh Change
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let birthdayPickerIndexPath = IndexPath(row: 1, section: 5)
        if indexPath == birthdayPickerIndexPath{
            if birthdayShow {
                return 216.0
            } else {
                return 0.0
            }
        }
        return 44.0
    }
    
    //Birthday
    
    @IBAction func birthdayPicker(_ sender: UIDatePicker) {
        let date = sender.date
        let  formateer = DateFormatter()
        formateer.dateFormat = "yyyy-MM-dd"
        let dateString = formateer.string(from: date)
        birthdayLable.text = dateString
    }
    
    // 判斷資料庫中是否已有相同Email存在
    @IBAction func emailExistCheck(_ sender: UITextField) {
        email = emailField.text!
        let customerExist = ["action": "userExist", "email": email] as [String : String]
        customerTask.userExist(customerExist).done { (reuslt) in
            if reuslt == "true" {
                self.emailField.text = ""
                self.showAlert(message: "Email已存在\n請輸入其他Email")
            }
        }
        
    }
    
    
    @IBAction func joinButton(_ sender: Any) {
        
        
        let name: String = nameField.text!
        let password: String = passwordField.text!
        var _: String = rePasswordField.text!
        var gender: String
        if genderSegmented.selectedSegmentIndex == 0   {
                gender = "female"
            } else {
                gender = "male"
            }
        let birthday: String = birthdayLable.text!
        let phone: String =  phoneField.text!
        let address: String = addressField.text!
        let customer =  Customer(idCustomer: 0, customerID: email, name: name, email: email, password: password, gender: gender, birthday: birthday, phone: phone, address: address, discount: 0)
        print("customer: \(customer)")
        let customerData = try! JSONEncoder().encode(customer)
        let customerString = String(data: customerData, encoding: .utf8)
        let joinCustomer = ["action": "customerInsert", "customer": customerString] as! [String:Any]
        customerTask.joinCustomer(joinCustomer).done {
            (result) in
            if result != "0" {
                print("加入成功 \(result)")
                self.performSegue(withIdentifier: "goToProfilePage", sender: self.joinButton)
 
            } else {
                self.showAlert(message: "加入失敗")
            }
        }
    }
    
    
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "蝦殼飯店", message: "取消註冊", preferredStyle: .alert)
        let ok = UIAlertAction(title: "確定", style: .destructive){
            (action) in
            self.performSegue(withIdentifier: "goToHomePage", sender: action)
        }
        let cancel = UIAlertAction(title: "取消", style: .default)
        alert.addAction(cancel)
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
    }
    
    
   
    
    

}
