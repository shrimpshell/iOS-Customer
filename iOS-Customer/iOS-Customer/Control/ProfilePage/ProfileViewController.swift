//
//  LogInViewController.swift
//  iOS-Customer
//
//  Created by Una Lee on 2018/10/10.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit
import PromiseKit
import Starscream


class ProfileViewController: UIViewController, WebSocketDelegate {
    
    let TAG = "ProfileViewController"
    var customer: Customer?
    var idCustomer: Int = 0
    var isLogin = false   // false = 顯示登入頁面， true = 顯示會員頁面
    var editPageInfo: Customer?
    let customerAuth = DownloadAuth.shared
    var socket: WebSocket!
   
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(socketConnect), name: .notificationConnectName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(socketDisConnect), name: .notificationDisConnectName, object: nil)
        
        userlogin()
        
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        
        if isLogin == true {
            showCustomerInfo()
        }
        
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if isLogin == false {
            socketDisConnect()
        }
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
                
                guard let userId = self.customer?.idCustomer?.description else {
                    return
                }
                self.socketConnect(userId: userId, groupId: "0")
                
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
            print("resultObject: \(resultObject)")
            self.customer = resultObject
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
        case "toRatingList":
            let ratingListPage = segue.destination as! RatingListTableViewController
            ratingListPage.customer = customer
            
        case "toReceiptList":
            let receiptListPage = segue.destination as! ReceiptTableViewController
            receiptListPage.customer = customer
        
        case "toEditingPage":
            let editingPage = segue.destination as! EditingTableViewController
            editingPage.customer = customer
        
        case "toInstantServicePage":
            let tabBarVC = segue.destination as! UITabBarController
            let nivagationVC = tabBarVC.viewControllers![0] as! UINavigationController
            let instantServiceVC = nivagationVC.topViewController as! ServiceItemCollectionViewController
            instantServiceVC.customer = customer
    
        default:
            break
        }
    }
        
    
    @IBAction func unwindToProfilePage(_ segue: UIStoryboardSegue) {
        
    }
    
    @objc func socketConnect(userId: String, groupId: String) {
        socket = WebSocket(url: URL(string: Common.SOCKET_URL + userId + "/" + groupId)!)
        socket.delegate = self
        socket.connect()
    }
    
    @objc func socketDisConnect() {
        socket.disconnect()
    }
    
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("ProfileView websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("ProfileView websocket is disconnected: \(error!.localizedDescription)")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("ProfileView got some text: \(text)")
        instantNotifications(text: text)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("ProfileView got some data: \(data.count)")
    }
    
}

extension Notification.Name {
    static let notificationConnectName = Notification.Name("socketConnect")
    static let notificationDisConnectName = Notification.Name("socketdisConnect")
}
