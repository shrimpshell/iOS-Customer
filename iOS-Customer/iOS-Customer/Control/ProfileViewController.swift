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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "toOrderList" {
            let NAVController = segue.destination as? UINavigationController
            let tableViewController = NAVController?.viewControllers.first as! RoomOrderTableViewController
            tableViewController.orders = self.orderRoomDetails!
            tableViewController.instants = self.orderInstantDetails!
        }
    }

    @IBAction func loginBtnPressed(_ sender: UIButton) {
        let customerTask = CustomerAuth()
        let orderDetails = OrderRoomDB()
        let email: String = loginEmailText.text!
        let password: String = loginPasswordText.text!
        guard email.count != 0 && password.count != 0 else {
            let alertController = UIAlertController(title: "蝦殼大飯店", message: "帳號或密碼不可留空", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
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
                self.orderInstantDetails = instants
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
