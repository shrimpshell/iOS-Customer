//
//  LogInViewController.swift
//  iOS-Customer
//
//  Created by Una Lee on 2018/10/10.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit
import PromiseKit

class ProfileViewController: UIViewController {
    var customer: Customer?
    var idCustomer: Int = 0
    var isLogin = false

    @IBOutlet weak var profilePageView: UIScrollView!
    @IBOutlet weak var loginPageView: UIScrollView!
    @IBOutlet weak var logInView: UIScrollView!
    @IBOutlet weak var settingBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var loginEmailText: UITextField!
    @IBOutlet weak var loginPasswordText: UITextField!
    @IBOutlet weak var nameCustomer: UILabel!
    @IBOutlet weak var idCustomerLabel: UILabel!
    @IBOutlet weak var imageCustomer: UIImageView!
    @IBOutlet weak var emailCustomer: UILabel!
    @IBOutlet weak var phoneCustomer: UILabel!
    @IBOutlet weak var titleNavigationItem: UINavigationItem!
    
    //var idCustomer: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userlogin()
    }
    
    

    @IBAction func loginBtnPressed(_ sender: UIButton) {
        let customerTask = CustomerAuth()
        var email: String = loginEmailText.text!
        var password: String = loginPasswordText.text!
        guard email.count != 0 && password.count != 0 else {
            let alertController = UIAlertController(title: "蝦殼大飯店", message: "帳號或密碼不可留空", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        let customerExist = ["action": "userExist", "email": email] as [String : String]
        let customerValid =  ["action": "userValid", "email": email, "password": password] as [String : String]
        customerTask.isValidUser(customerExist).then { (isValid) -> Promise<String> in
            guard isValid == "true" else {
                self.showAlert(message: "帳號不存在")
                return customerTask.isCorrectUser(["action": "userValid", "email": "", "password": ""])
            }
            
             return customerTask.isCorrectUser(customerValid)
            }.then { (idCustomer) -> Promise<Customer?> in
                let customerProfile = ["action": "findById", "IdCustomer": idCustomer] as [String : String]
                guard idCustomer.count > 0 || idCustomer != "0" || (Int(idCustomer) != nil)  else {
                    self.showAlert(message: "帳號或密碼不正確，請重新輸入")
                    return customerTask.getCustomerInfo(["action": "findById", "IdCustomer": ""])
                }
                
                print("idCustomer: \(idCustomer)")
                self.idCustomerLabel.text = "\(idCustomer)"
                return customerTask.getCustomerInfo(customerProfile)
            }.done { (customer) in
                self.customer = customer
                if customer?.idCustomer != 0 {
                self.isLogin = true
                } else {
                    self.showAlert(message: "帳號或密碼不正確 \n請重新輸入")
                }
                self.userlogin()
                print(": \(customer)")
                self.nameCustomer.text = customer?.name
                self.emailCustomer.text = customer?.email
                self.phoneCustomer.text = customer?.phone
                
            }.catch { (error) in
                assertionFailure("Login Error: \(error)")
        }
    }
    
    func userlogin() {
        if  isLogin == true {
            loginPageView.isHidden = true
            profilePageView.isHidden = false
            titleNavigationItem.title = "會員資料"
            settingBarButtonItem.title = "Setting"
            settingBarButtonItem.isEnabled = true
        } else {
            titleNavigationItem.title = ""
            profilePageView.isHidden = true
            settingBarButtonItem.title = ""
            settingBarButtonItem.isEnabled = false
        }
    }
}
