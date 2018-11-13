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
    var isLogin = false    // false = 顯示登入頁面， true = 顯示會員頁面
    
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
    
    
    
    //登入，取得server資料
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        let customerTask = CustomerAuth()
        var email: String = loginEmailText.text!
        var password: String = loginPasswordText.text!
        guard email.count != 0 && password.count != 0 else {
            self.showAlert(message: "帳號或密碼不可空白")
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
                
                return customerTask.getCustomerInfo(customerProfile)
            }.done { (customer) in
                guard let customer = customer else {
                    self.showAlert(message: "帳號或密碼不正確 \n請重新輸入")
                    return
                }
                print("idCustomerInfo: \(customer.idCustomer)")
                self.customer = customer
                self.isLogin = true
                self.userlogin()
                print("self.customer: \(self.customer)")
                guard let idCustomer = customer.idCustomer else {
                    print("會員頁面idCustomer解包錯誤")
                    return
                }
                self.idCustomerLabel.text = "\(idCustomer)"
                self.nameCustomer.text = customer.name
                self.emailCustomer.text = customer.email
                self.phoneCustomer.text = customer.phone
                
            }.catch { (error) in
                assertionFailure("Login Error: \(error)")
        }
    }
    
    //使用isLogin切換會員頁面與登入頁面
    func userlogin() {
        if  isLogin == true {
            loginPageView.isHidden = true
            profilePageView.isHidden = false
            titleNavigationItem.title = "會員資料"
            settingBarButtonItem.title = "Setting"
            settingBarButtonItem.isEnabled = true
            
        } else {
            loginPageView.isHidden = false
            titleNavigationItem.title = ""
            profilePageView.isHidden = true
            settingBarButtonItem.title = ""
            settingBarButtonItem.isEnabled = false
        }
    }
    
    //登出
    @IBAction func logOutBtnPressed(_ sender: UIButton) {
        idCustomer = 0
        isLogin = false
        userlogin()
        print("Log Out")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let customer = self.customer else {
            return
        }
        switch segue.identifier {
        case "toRatingList":
            let ratingListPage = segue.destination as! RatingListTableViewController
            ratingListPage.customer = customer
            
        case "toReceiptList":
            let receiptListPage = segue.destination as! ReceiptTableViewController
            receiptListPage.customer = customer
            
            case "toEditingPage":
            let editingPage = segue.destination as! EditingTableViewController
            editingPage.customer = customer
            
        default:
            break
        }
    }
        
    
    @IBAction func unwindToProfilePage(_ segue: UIStoryboardSegue){
        
    }
    
}
