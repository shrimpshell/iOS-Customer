//
//  EditingTableViewController.swift
//  iOS-Customer
//
//  Created by Una Lee on 2018/11/12.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit
import Alamofire

class EditingTableViewController: UITableViewController {
    
    var customer: Customer?
    var phone: String = ""
    let customerAuth = DownloadAuth.shared
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var rePasswordField: UITextField!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       showCustomerInfo()

    }
    
    // 把TabBar藏起來
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }

    func customerInfoLoading() {
        
    }

    @IBAction func checkEditing(_ sender: Any) {
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
        
        let birthday = birthdayLabel.text
        
        phone = phoneField.text!
        
        var address = addressField.text
        if address?.count == 0 {
            address = customer?.address
        }

        let editCustomer = Customer(idCustomer: idCustomer, customerID: email!, name: name!, email: email!, password: password!, birthday: birthday!, phone: phone, address: address!)
        print("editCustomer: \(editCustomer)")
        
        customerAuth.editCustomerInfo(customer: editCustomer) { (result, error) in
            if let error = error {
                print("Editing customerInfo update error\(error)")
                return
            }
            print("Uptade new customerInfo is OK: \(result)")
        }
        self.performSegue(withIdentifier: "goToProfilePage", sender: checkEditing)
    }
    
    
    @IBAction func cancelBtnPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "蝦殼飯店", message: "取消修改", preferredStyle: .alert)
        let ok = UIAlertAction(title: "確定", style: .destructive){
            (action) in
            self.performSegue(withIdentifier: "goToProfilePage", sender: action)
        }
        let cancel = UIAlertAction(title: "取消", style: .default)
        alert.addAction(cancel)
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func checkPhoneNumber(_ sender: UITextField) {
        if phone.count < 10 {
            showAlert(message: "手機號碼輸入錯誤，\n請再輸入一次")
            phoneField.text = ""
    }
    }
    
    func showCustomerInfo() {
        nameField.text = customer?.name
        emailLabel.text = customer?.email
        passwordField.text = customer?.password
        rePasswordField.text = customer?.password
        birthdayLabel.text = customer?.birthday
        phoneField.text = customer?.phone
        addressField.text = customer?.address
    }
    
    
}
