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
    let TAG = "ProfileViewController"
    var customer: Customer?
    var idCustomer: Int = 0
    var isLogin = false    // false = 顯示登入頁面， true = 顯示會員頁面
    var editPageInfo: Customer?
    let customerAuth = DownloadAuth.shared
    var orderRoomDetails: [OrderRoomDetail]?
    var orderInstantDetails: [OrderInstantDetail]?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        
        if isLogin == true {
            showCustomerInfo()
        }
        
    }
    
    
    //登入，取得server資料
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        let customerTask = CustomerAuth()
        let orderDetails = OrderRoomDB()
        let email: String = loginEmailText.text!
        let password: String = loginPasswordText.text!
        guard email.count != 0 && password.count != 0 else {
            self.showAlert(message: "帳號或密碼不可空白")
            return
        }
        
        let customerValid =  ["action": "userValid", "email": email, "password": password] as [String : String]
        customerTask.isCorrectUser(customerValid).then { (idCustomer) -> Promise<Customer?> in
            let customerProfile = ["action": "findById", "IdCustomer": idCustomer] as [String : String]
            guard idCustomer.count > 0 || idCustomer != "0" || (Int(idCustomer) != nil)  else {
                self.showAlert(message: "帳號或密碼不正確，請重新輸入")
                return customerTask.getCustomerInfo(["action": "findById", "IdCustomer": "0"])
            }
            self.idCustomer = Int(idCustomer)!
            self.idCustomerLabel.text = "\(idCustomer)"
            return customerTask.getCustomerInfo(customerProfile)
            }.then { (customer) -> Promise<[OrderRoomDetail]> in
                guard let customer = customer else {
                    self.showAlert(message: "帳號或密碼不正確 \n請重新輸入")
                    return orderDetails.getRoomPayDetailById(["":""])
                }
                self.customer = customer
                if customer.idCustomer != 0 {
                    self.isLogin = true
                }
                self.userlogin()
                self.nameCustomer.text = customer.name
                self.emailCustomer.text = customer.email
                self.phoneCustomer.text = customer.phone
                let parameters = ["action":"getRoomPayDetailById", "idCustomer":"\(self.idCustomer)"]
                return orderDetails.getRoomPayDetailById(parameters)
            }.then { rooms -> Promise<[OrderInstantDetail]> in
                self.orderRoomDetails = rooms
                let parameters = ["action":"getInstantPayDetail", "idCustomer":"\(self.idCustomer)"]
                return orderDetails.getInstantPayDetail(parameters)
            }.done { instants in
                self.isLogin = true
                self.showCustomerInfo()
                self.orderInstantDetails = instants
            }.catch { (error) in
                assertionFailure("Login Error: \(error)")
        }
    }
    
    func showCustomerInfo() {
        guard let idCustomer = customer?.idCustomer else {
            print("idCustomer 解包錯誤")
            return
        }
        customerAuth.getCustomerInfoById(idCustomer: idCustomer) { (result, error) in
            if let error = error {
                print("Customer Info download error: \(error)")
                return
            }
            guard let result = result else {
                print("result is nil.")
                return
            }
            print("Retrive customer Info is OK.")
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
                else  {
                    printHelper.println(tag: self.TAG, line: #line, "Fail to generate jsonData.")
                    return
            }
            let decoder = JSONDecoder()
            guard let resultObject = try? decoder.decode(Customer.self, from: jsonData) else {
                printHelper.println(tag: self.TAG, line: #line, "Fail to decoder jsonData.")
                return
            }
            self.customer = resultObject
            print(self.customer)
            guard let reFreshidCustmoer = self.customer?.idCustomer else {
                printHelper.println(tag: self.TAG, line: #line, "idCustomer解包錯誤")
                return
            }
            self.idCustomerLabel.text = "\(reFreshidCustmoer)"
            self.nameCustomer.text = self.customer?.name
            self.emailCustomer.text = self.customer?.email
            self.phoneCustomer.text = self.customer?.phone
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
        case "toOrderList":
            let NAVController = segue.destination as? UINavigationController
            let tableViewController = NAVController?.viewControllers.first as! RoomOrderTableViewController
            tableViewController.orders = self.orderRoomDetails!
            tableViewController.instants = self.orderInstantDetails!
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
        switch segue.identifier {
        case "toProfilePage":
            guard let roomOrderTableView = segue.source as? RoomOrderDetailViewController, let rooms = roomOrderTableView.rooms else {
                print("error")
                return
            }
            self.orderRoomDetails = rooms
        default:
            break
        }
    }
    
}
