//
//  JoinTableViewController.swift
//  iOS-Customer
//
//  Created by Una Lee on 2018/10/9.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit

class JoinTableViewController: UITableViewController, UITextFieldDelegate {
    
    let customerTask = CustomerAuth()
     var customer: Customer?
    var pageNumber = 0
    var name = "", email = "", phone = "", password = "", rePassword = "", birthday = "", address = ""
    
    var isNameOK = false, isEmailOK = false, isPasswordOK = false, isPhoneOK = false
    var joinSuccess = 0
    let userID = UserDefaults()
    let now = Date()
    
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
        hideKeyboard()
        switch pageNumber {
        case 0:
            checkBtn.title = "加入"
            navigationTitle.title = "會員註冊"
            birthdayLable.isUserInteractionEnabled = true
            genderSegmented.isEnabled = true
            emailField.isUserInteractionEnabled = true
            
        case 2:
            navigationTitle.title = "會員資料修改"
            checkBtn.title = "編輯"
            showCustomerInfo()
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        birthdayDatePicker.maximumDate = now
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
    
    @IBAction func checkNameCount(_ sender: UITextField) {
        name = nameField.text!
        if name.count == 0 {
            errorAction(textField: nameField, message: "請輸入姓名")
        } else {
            isNameOK = true
            nameField.layer.borderColor = UIColor.clear.cgColor
            print("isNameOK")
        }
    }
    
    
    // 判斷資料庫中是否已有相同Email存在
    @IBAction func emailExistCheck(_ sender: UITextField) {
        switch pageNumber {
        case 0:
            email = emailField.text!
            if isEmail(emailString: email) == true {
                let customerExist = ["action": "userExist", "email": email] as [String : String]
                customerTask.userExist(customerExist).done { (reuslt) in
                    if reuslt == "true" {
                        self.emailField.text = ""
                        self.showAlert(message: "Email已存在\n請輸入其他Email")
                    } else {
                        self.isEmailOK = true
                        self.emailField.layer.borderColor = UIColor.clear.cgColor
                    }
                }
            } else  {
                errorAction(textField: emailField, message: "請輸入正確Email")
            }
        default:
            break
        }
    }
    
    @IBAction func checkPasswordCount(_ sender: UITextField) {
         password = passwordField.text!
        if password.count < 4 {
            errorAction(textField: passwordField, message: "不符合密碼長度，最少四位數")
        }
    }
    
    
    @IBAction func rePasswordCheck(_ sender: UITextField) {
        rePassword = rePasswordField.text!
        if password != rePassword {
            errorAction(textField: passwordField, message: "與確認密碼不相符，請再次確認")
            errorAction(textField: rePasswordField, message: "與確認密碼不相符，請再次確認")
        } else {
            isPasswordOK = true
            passwordField.layer.borderColor = UIColor.clear.cgColor
            rePasswordField.layer.borderColor = UIColor.clear.cgColor
            print("isPasswordOK")
        }
    }
    
    @IBAction func checkPhoneCount(_ sender: UITextField) {
        phone = phoneField.text!
        if phone.count < 10 {
            errorAction(textField: phoneField, message: "手機號碼長度不夠，請再輸入一次")
        } else {
            isPhoneOK = true
            phoneField.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    
    @IBAction func joinButton(_ sender: Any) {
        switch pageNumber {
        case 0:
            phoneField.resignFirstResponder()
            print("\(isNameOK), \(isEmailOK), \(isPasswordOK), \(isPhoneOK)")
            if isNameOK == true && isEmailOK == true && isPasswordOK == true && isPhoneOK == true {
                var gender: String
                if genderSegmented.selectedSegmentIndex == 0   {
                    gender = "female"
                } else {
                    gender = "male"
                }
                birthday = birthdayLable.text!
                if birthday.count < 1 {
                    birthday = "1997-01-01"
                }
                address = addressField.text!
                if address.count < 1 {
                    address = ""
                }
                let customer =  Customer(idCustomer: 0, customerID: email, name: name, email: email, password: password, gender: gender, birthday: birthday, phone: phone, address: address, discount: 0)
                print("customer: \(customer)")
                let customerData = try! JSONEncoder().encode(customer)
                let customerString = String(data: customerData, encoding: .utf8)
                let joinCustomer = ["action": "customerInsert", "customer": customerString] as! [String:Any]
                customerTask.joinCustomer(joinCustomer).done {
                    (result) in
                    if result != "0" {
                        print("加入成功 \(result)")
                        self.joinSuccess = Int(result)!
                        self.userID.set(result, forKey: "userID")
                        self.performSegue(withIdentifier: "goToProfilePage", sender: self.joinButton)
                        
                    } else {
                        self.showAlert(message: "加入失敗")
                    }
                }
            } else {
                showAlert(message: "資料輸入不完整，請再次確認")
            }
            
        case 1:
            performSegue(withIdentifier: "goToLogin", sender: nil)
            tabBarController?.tabBar.isHidden = true
            
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
            print("customer: \(customer)")
            let editCustomerData = try! JSONEncoder().encode(customer)
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
        emailField.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        emailField.isUserInteractionEnabled = false
        passwordField.text = customer?.password
        rePasswordField.text = customer?.password
        genderSegmented.isEnabled = false
        if customer?.gender == "female" {
            genderSegmented.selectedSegmentIndex = 0
        } else {
            genderSegmented.selectedSegmentIndex = 1
        }
        genderSegmented.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        birthdayLable.text = customer?.birthday
        birthdayLable.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cornerRadius(view: birthdayLable)
        birthdayLable.isUserInteractionEnabled = false
        phoneField.text = customer?.phone
        addressField.text = customer?.address
    }
    
    func errorAction(textField: UITextField, message: String) {
        textField.text = ""
        textField.placeholder = message
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.red.cgColor
    }
    
    //確認Email是否正確
    func isEmail(emailString: String) -> Bool {
        // Sample regex for email - You can use your own regex for email
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailString)
    }
    
    //藏鍵盤
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func hideKeyboard() {
        nameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        rePasswordField.delegate = self
        phoneField.delegate = self
        addressField.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "goToProfilePage":
            let profilePage = segue.destination as! ProfileViewController
            profilePage.joinSuccess = joinSuccess
            if joinSuccess != 0 {
                ProfileViewController.isLogin = true
                profilePage.isFromCheckBooking = true
            }
            break
            
        
        default:
            break
        }
    }
}
