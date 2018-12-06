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
     var customer: Customer?
    var pageNumber = 0
    var email: String = ""
    var phone: String = ""
    
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var rePasswordField: UITextField!
    @IBOutlet weak var genderSegmented: UISegmentedControl!
    @IBOutlet weak var birthdayLable: UILabel!
    @IBOutlet weak var birthdayDatePicker: UIDatePicker!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var checkBtn: UIBarButtonItem!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    let birthdayTitle = IndexPath(row: 0, section: 5)
    
    var birthdayShow = false {
        didSet {
            birthdayDatePicker.isHidden = !birthdayShow
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("pageNumber: \(pageNumber)")
        switch pageNumber {
        case 0:
            checkBtn.title = "Join"
            navigationTitle.title = "會員註冊"
            birthdayLable.isUserInteractionEnabled = true
            genderSegmented.isEnabled = true
            emailField.isUserInteractionEnabled = true
        case 2:
            navigationTitle.title = "會員資料修改"
            checkBtn.title = "Editing"
            showCustomerInfo()
        default:
            break
        }
    }
    
    //BirthdayPicker Hidden Change
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if pageNumber == 0 {
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
        switch pageNumber {
        case 0:
            
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
            phone =  phoneField.text!
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
            
        case 2:
            
            guard  let idCustomer = customer?.idCustomer else {
                print("idCustomer 解包錯誤")
                return
            }
            let email = customer?.email
            
            var name = nameField.text
            if name?.count == 0 {
                name = customer?.name
            }
            
            var password = passwordField.text
            if password?.count == 0  {
                password = customer?.password
            }
            
            let gender = customer?.gender
            let birthday = birthdayLable.text
            
            phone = phoneField.text!
            
            var address = addressField.text
            if address?.count == 0 {
                address = customer?.address
            }
            let editCustomer = Customer(idCustomer: idCustomer, customerID: email!, name: name!, email: email!, password: password!, gender: gender!, birthday: birthday!, phone: phone, address: address!)
            customer = editCustomer
            let editCustomerData = try! JSONEncoder().encode(editCustomer)
            let customerString = String(data: editCustomerData, encoding: .utf8)
            let joinCustomer = ["action": "update", "customer": customerString] as! [String:Any]
            customerTask.joinCustomer(joinCustomer).done {
                (result) in
                if result != "0" {
                    print("會員資料修改成功 \(result)")
                    self.performSegue(withIdentifier: "goToProfilePage", sender: self.joinButton)
                    
                } else {
                    self.showAlert(message: "會員資料修改失敗")
                }
            }
        default:
            break
        }
        
    }
    
    @IBAction func checkPhoneCount(_ sender: UITextField) {
        phone = phoneField.text!
        if phone.count < 10 {
            showAlert(message: "手機號碼輸入錯誤，\n請再輸入一次")
            phoneField.text = ""
        }
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        switch pageNumber {
        case 0:     //JoinBtn進入
            let alert = UIAlertController(title: "蝦殼飯店", message: "取消註冊", preferredStyle: .alert)
            let ok = UIAlertAction(title: "確定", style: .destructive){
                (action) in
                self.performSegue(withIdentifier: "goToHomePage", sender: action)
            }
            let cancel = UIAlertAction(title: "取消", style: .default)
            alert.addAction(cancel)
            alert.addAction(ok)
            
            present(alert, animated: true, completion: nil)
            
        case 2:     //EditingBtn進入
            let alert = UIAlertController(title: "蝦殼飯店", message: "取消修改", preferredStyle: .alert)
            let ok = UIAlertAction(title: "確定", style: .destructive){
                (action) in
                self.performSegue(withIdentifier: "goToProfilePage", sender: action)
            }
            let cancel = UIAlertAction(title: "取消", style: .default)
            alert.addAction(cancel)
            alert.addAction(ok)
            
            present(alert, animated: true, completion: nil)
        default:
            break
        }
    }
    
    //已登入，修改會員資料頁面
    func showCustomerInfo() {
        nameField.text = customer?.name
        emailField.text = customer?.email
        emailField.isUserInteractionEnabled = false
        passwordField.text = customer?.password
        rePasswordField.text = customer?.password
        genderSegmented.isEnabled = false
        if customer?.gender == "female" {
            genderSegmented.selectedSegmentIndex = 0
        } else {
            genderSegmented.selectedSegmentIndex = 1
        }
        birthdayLable.text = customer?.birthday
        birthdayLable.isUserInteractionEnabled = false
        phoneField.text = customer?.phone
        addressField.text = customer?.address
    }
    
   
    
    

}
