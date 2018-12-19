//
//  LogInViewController.swift
//  iOS-Customer
//
//  Created by Una Lee on 2018/10/10.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit
import PromiseKit
import Photos
import MobileCoreServices
import Alamofire


class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    let TAG = "ProfileViewController"
    var customer: Customer?
    var idCustomer: Int = 0
    static var isLogin = false   // false = 顯示登入頁面， true = 顯示會員頁面
    var isFromCheckBooking = false // false is not come from CheckBooking.
    var editPageInfo: Customer?
    let customerTask = CustomerAuth()    //使用promiseKit方法
    let customerAuth = DownloadAuth.shared       //使用Alamofirez方法
    var orderRoomDetails: [OrderRoomDetail]?
    var orderInstantDetails: [OrderInstantDetail]?
    let userID = UserDefaults()
    var joinSuccess = false
    
    
    
    
    @IBOutlet weak var profilePageView: UIScrollView!
    @IBOutlet weak var loginPageView: UIScrollView!
    @IBOutlet weak var logInView: UIScrollView!
    @IBOutlet weak var loginEmailText: UITextField!
    @IBOutlet weak var loginPasswordText: UITextField!
    @IBOutlet weak var nameCustomer: UILabel!
    @IBOutlet weak var idCustomerLabel: UILabel!
    @IBOutlet weak var imageCustomer: UIImageView!
    @IBOutlet weak var emailCustomer: UILabel!
    @IBOutlet weak var phoneCustomer: UILabel!
    @IBOutlet weak var titleNavigationItem: UINavigationItem!
    @IBOutlet weak var settingItemBtn: UIBarButtonItem!
    @IBOutlet weak var checkInTitleLabel: UILabel!
    @IBOutlet weak var checkInDateLabel: UILabel!
    @IBOutlet weak var roomNumberLabel: UILabel!
    @IBOutlet weak var checkInfomation: UIStackView!
    @IBOutlet weak var serviceBtn: UIButton!
    @IBOutlet weak var roomNumberTitleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginEmailText.clearButtonMode = .unlessEditing
        loginPasswordText.clearButtonMode = .unlessEditing
        userlogin()
        
        //修image邊角
        cornerRadius(view: imageCustomer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        guard let idCustomer = userID.object(forKey: "userID") else {
            print("idCustomer 解包錯誤")
            return
        }
        self.tabBarController?.tabBar.isHidden = false
        hideKeyboard()
        checkInTitleLabel.isHidden = true
        checkInfomation.isHidden = true
        if ProfileViewController.isLogin == true {
            showCustomerInfo(idCustomer: idCustomer as! Int)
        }
        if isFromCheckBooking == true {
            tabBarController?.tabBar.isHidden = true
            print(isFromCheckBooking)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if joinSuccess == true {
            showToast(message: "會員加入成功")
            joinSuccess = false
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
        customerTask.isCorrectUser(customerValid).done { (idCustomer) in
            
            guard idCustomer != "0" else {
                self.showAlert(message: "帳號或密碼不正確，請重新輸入")
                return
            }
            let id = Int(idCustomer)
            self.userID.set(id, forKey: "userID")
            self.idCustomer = Int(idCustomer)!
            self.idCustomerLabel.text = "\(idCustomer)"
            DispatchQueue.main.async {
                self.showCustomerInfo(idCustomer: self.idCustomer)
            }
        }.catch { (error) in
            assertionFailure("Login Error: \(error)")
        }
    }
    
    //SHOW~!!! CustomerInformation~!
    func showCustomerInfo(idCustomer: Int) {
        let customerTask = CustomerAuth()
        let orderDetails = OrderRoomDB()
        guard let idCustomer = userID.object(forKey: "userID") else {
            print("idCustomer 解包錯誤")
            return
        }
        
        let customerProfile = ["action": "findById", "IdCustomer": "\(idCustomer)"]
        customerTask.getCustomerInfo(customerProfile).then {
            (customer) -> Promise<[OrderRoomDetail]> in
            guard let customer = customer else {
                self.showAlert(message: "帳號或密碼不正確 \n請重新輸入")
                return orderDetails.getRoomPayDetailById(["":""])
            }
            self.customer = customer
            if customer.idCustomer != 0 {
                ProfileViewController.isLogin = true
            }
            
            self.userlogin()
            self.userID.synchronize()
            self.idCustomerLabel.text = "\(customer.idCustomer!)"
            self.nameCustomer.text = customer.name
            self.emailCustomer.text = customer.email
            self.phoneCustomer.text = customer.phone
            self.customerAuth.getUserRoomReservationStatus(idCustomer: idCustomer as! Int) {
                (result, error) in
                if let error = error {
                    printHelper.println(tag: "ProfileViewController", line: #line, "RoomReservationStatuse error: \(error)")
                    return
                }
                guard var result = result else {
                    assertionFailure("ProfielViewController - RoomReservationStatuse result is nil")
                    return
                }
                
                if result  is NSNull {
                    self.checkInTitleLabel.isHidden = false
                    self.checkInTitleLabel.text = "你沒有訂房紀錄喔\n快加入我們吧～！"
                    self.checkInfomation.isHidden = true
                    self.serviceBtn.isEnabled = false
                    return
                }
                printHelper.println(tag: "ProfileViewController", line: #line, "RoomReservationStatuse Info is OK.")
                
                guard let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted) else  {
                    assertionFailure("ProfielViewController - Fail to generate jsonData")
                    return
                }
                let decoder = JSONDecoder()
                guard let resultObject = try? decoder.decode(CheckInInfo?.self, from: jsonData) else {
                    print("ProfielViewController - Download RoomReservationStatuse - Fail to decoder jsonData.")
                    return
                }
                
                guard let checkInInfo = resultObject else {
                    return
                }
                
                if checkInInfo.roomReservationStatus == "1" {
                    self.checkInTitleLabel.isHidden = false
                    self.checkInfomation.isHidden = false
                    self.checkInTitleLabel.text = "入住資訊"
                    let endOfSentence = checkInInfo.checkInDate!.firstIndex(of: " ")!
                    let firstSentence =  checkInInfo.checkInDate![...endOfSentence]
                    self.checkInDateLabel.text = "\(firstSentence)"
                    self.roomNumberTitleLabel.text = "房號"
                    self.checkInDateLabel.textColor = .black
                    self.roomNumberLabel.text = checkInInfo.roomNumber
                    let roomNumber = checkInInfo.roomNumber as! String
                    self.userID.set(roomNumber, forKey: "roomNumber")
                    print(roomNumber)
                    self.serviceBtn.isEnabled = true
                } else {
                    self.checkInTitleLabel.isHidden = false
                    self.checkInfomation.isHidden = false
                    self.checkInTitleLabel.text = "預約入住資訊"
                    let endOfSentence = checkInInfo.checkInDate!.firstIndex(of: " ")!
                    let firstSentence =  checkInInfo.checkInDate![...endOfSentence]
                    self.checkInDateLabel.text = "\(firstSentence)"
                    self.checkInDateLabel.textColor = .red
                    self.roomNumberTitleLabel.text = "期待您的入住"
                    self.roomNumberLabel.text = ""
                    self.serviceBtn.isEnabled = false
                }
            }
            let parameters = ["action":"getRoomPayDetailById", "idCustomer":"\(idCustomer)"]
            return orderDetails.getRoomPayDetailById(parameters)
        }.then { rooms -> Promise<[OrderInstantDetail]> in
            self.orderRoomDetails = rooms
            print("orderRoomDetails: \(self.orderRoomDetails!)")
            let parameters = ["action":"getInstantPayDetail", "idCustomer":"\(idCustomer)"]
            return orderDetails.getInstantPayDetail(parameters)
        }.then {
            instants -> Promise<Data?> in
            self.orderInstantDetails = instants
            print("orderInstantDetails: \(self.orderInstantDetails!)")
            ProfileViewController.isLogin = true
            let getCustomerImage: [String : Any] = ["action": "getImage", "IdCustomer": idCustomer]
            return customerTask.getCustomerImage(getCustomerImage)
        }.done {
            data in
            if !(data?.isEmpty)! {
                DispatchQueue.main.async() {
                    self.imageCustomer.image = UIImage(data: data!)
                }
            } else {
                self.imageCustomer.image = UIImage(named: "picture")
                self.imageCustomer.backgroundColor = .white
            }
            
           
        }.catch { (error) in
            assertionFailure("Login Error: \(error)")
        }
        
        customerAuth.getCustomerInfoById(idCustomer: idCustomer as! Int) { (result, error) in
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
            self.userID.synchronize()
            self.idCustomerLabel.text = "\(reFreshidCustmoer)"
            self.nameCustomer.text = self.customer?.name
            self.emailCustomer.text = self.customer?.email
            self.phoneCustomer.text = self.customer?.phone
        }
        
        let getCustomerImage: [String : Any] = ["action": "getImage", "IdCustomer": idCustomer]
        customerTask.getCustomerImage(getCustomerImage).done { (data) in
            if (data?.count)! > 0 {
                DispatchQueue.main.async() {
                    self.imageCustomer.image = UIImage(data: data!)
                }
            } else {
                self.imageCustomer.image = UIImage(named: "person128.png")
                self.imageCustomer.backgroundColor = .white
            }
            }.catch { (error) in
                assertionFailure("CheckoutTableViewController Error: \(error)")
        }
    
        customerAuth.getUserRoomReservationStatus(idCustomer: idCustomer as! Int) {
            (result, error) in
            if let error = error {
                printHelper.println(tag: "ProfileViewController", line: #line, "RoomReservationStatuse error: \(error)")
                return
            }
            guard var result = result else {
                assertionFailure("ProfielViewController - RoomReservationStatuse result is nil")
                return
            }

            if result  is NSNull {
                self.checkInTitleLabel.isHidden = false
                self.checkInTitleLabel.text = "你沒有訂房紀錄喔\n快加入我們吧～！"
                self.checkInfomation.isHidden = true
                self.serviceBtn.isEnabled = false
                return
            }
            printHelper.println(tag: "ProfileViewController", line: #line, "RoomReservationStatuse Info is OK.")

            guard let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted) else  {
                    assertionFailure("ProfielViewController - Fail to generate jsonData")
                    return
            }
            let decoder = JSONDecoder()
            guard let resultObject = try? decoder.decode(CheckInInfo?.self, from: jsonData) else {
                print("ProfielViewController - Download RoomReservationStatuse - Fail to decoder jsonData.")
                return
            }

            guard let checkInInfo = resultObject else {
                return
            }

            if checkInInfo.roomReservationStatus == "1" {
                self.checkInTitleLabel.isHidden = false
                self.checkInfomation.isHidden = false
                self.checkInTitleLabel.text = "入住資訊"
                let endOfSentence = checkInInfo.checkInDate!.firstIndex(of: " ")!
                let firstSentence =  checkInInfo.checkInDate![...endOfSentence]
                self.checkInDateLabel.text = "\(firstSentence)"
                self.roomNumberTitleLabel.text = "房號"
                self.checkInDateLabel.textColor = .black
                self.roomNumberLabel.text = checkInInfo.roomNumber
                let roomNumber = checkInInfo.roomNumber as! String
                self.userID.set(roomNumber, forKey: "roomNumber")
                print(roomNumber)
                self.serviceBtn.isEnabled = true
            } else {
                self.checkInTitleLabel.isHidden = false
                self.checkInfomation.isHidden = false
                self.checkInTitleLabel.text = "預約入住資訊"
                let endOfSentence = checkInInfo.checkInDate!.firstIndex(of: " ")!
                let firstSentence =  checkInInfo.checkInDate![...endOfSentence]
                self.checkInDateLabel.text = "\(firstSentence)"
                self.checkInDateLabel.textColor = .red
                self.roomNumberTitleLabel.text = "期待您的入住"
                self.roomNumberLabel.text = ""
                self.serviceBtn.isEnabled = false
            }
        }
    }
    
    
    
    @IBAction func chungPicBtnPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Please choose source:", message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.launchPicker(source: .camera)
        }
        let library = UIAlertAction(title: "Photo library", style: .default) { (action) in
            self.launchPicker(source: .photoLibrary)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(camera)
        alert.addAction(library)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    func launchPicker(source: UIImagePickerController.SourceType)  {
        guard UIImagePickerController.isSourceTypeAvailable(source)
            else {
                print("Invalid source type")
                return
        }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.mediaTypes = [kUTTypeImage] as [String]
        picker.sourceType = source
        picker.allowsEditing = true     //可裁切正方形的照片
        
        present(picker, animated: true)
    }
    
    
    //選取照片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        printHelper.println(tag: "ProfileViewController", line: #line, "info: \(info)")
        guard let type = info[UIImagePickerController.InfoKey.mediaType] as? String
            else {
                assertionFailure("Invalid type")
                return
        }
        // user 選到照片時
        if type == (kUTTypeImage as String) {
            guard let originalImage = info[.originalImage] as? UIImage
                else {
                    assertionFailure("originalImage is nil.")
                    return
            }
            //照片上傳
            let resizedImage = originalImage.resize(maxEdge: 1024)!
            let jpgData = resizedImage.jpegData(compressionQuality: 0.8)
            //let pngData = resizedImage.pngData()
            
            let imageDataString = jpgData?.base64EncodedString(options: .lineLength64Characters)
            let parameters = ["action":"updateImage", "IdCustomer":"\(idCustomer)", "imageBase64": imageDataString]
            customerTask.updateCustomerImage(parameters as [String : Any]).done { data in
                if data != "0" {
                    self.imageCustomer.image = UIImage(data: jpgData!)
                }
            }
        }
        // 要記得把picker收起來～！
        picker.dismiss(animated: true)    // Important!
        
    }
    
    
    
    
    //登出
    @IBAction func logOutBtnPressed(_ sender: UIButton) {
        //idCustomer = 0
        customer = nil
        ProfileViewController.isLogin = false
        isFromCheckBooking = false
        checkInTitleLabel.isHidden = true
        checkInfomation.isHidden = true
        self.userID.set("", forKey: "roomNumber")
        self.userID.set(0, forKey: "userID")
        self.userID.synchronize()
        imageCustomer.image = UIImage(named: "")
        userlogin()
        print("Log Out")
    }
    
    //去
    @IBAction func toOrderListPageButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "toOrderList", sender: nil)
    }
    
    //帶資料
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let customer = self.customer else {
            return
        }
        switch segue.identifier {
        case "toOrderList":
            let NAVController = segue.destination as? UINavigationController
            let tableViewController = NAVController?.viewControllers.first as! RoomOrderTableViewController
            print("orderRoomDetails: \(self.orderRoomDetails!), orderInstantDetails: \(self.orderInstantDetails!)")
            tableViewController.orders = self.orderRoomDetails!
            tableViewController.instants = self.orderInstantDetails!
            tableViewController.idCustomer = self.idCustomer
            
        case "toRatingList":
            let NAVController = segue.destination as? UINavigationController
            let ratingListPage = NAVController?.viewControllers.first as! AllRatingsTableViewController
            ratingListPage.customer = customer
            ratingListPage.pageNumber = 2
            
        case "toEditingPage":
            let NAVController = segue.destination as? UINavigationController
            let editingPage = NAVController?.viewControllers.first as! JoinTableViewController
            editingPage.customer = customer
            editingPage.pageNumber = 2
            
        case "toJoinPage":
            let NAVController = segue.destination as? UINavigationController
            let joinPage = NAVController?.viewControllers.first as! JoinTableViewController
            if isFromCheckBooking == true {
                let joinVC = segue.destination as! JoinTableViewController
                joinVC.pageNumber = 1
            }
            print("goto Join")
            
        case "toInstantServicePage":
            let tabBarVC = segue.destination as! UITabBarController
            let nivagationVC = tabBarVC.viewControllers![0] as! UINavigationController
            let instantServiceVC = nivagationVC.topViewController as! ServiceItemCollectionViewController
            instantServiceVC.customer = customer
            
        default:
            break
        }
    }
    
    //使用isLogin切換會員頁面與登入頁面
    func userlogin() {
        if  ProfileViewController.isLogin == true {
            if self.isFromCheckBooking == false {
                navigationItem.rightBarButtonItem?.image = UIImage(named: "settings")
                navigationItem.rightBarButtonItem?.isEnabled = true
                loginPageView.isHidden = true
                profilePageView.isHidden = false
                titleNavigationItem.title = "會員資料"
            } else {
                navigationItem.rightBarButtonItem?.image = UIImage(named: "settings")
                navigationItem.rightBarButtonItem?.isEnabled = true
                loginPageView.isHidden = true
                profilePageView.isHidden = false
                titleNavigationItem.title = "會員資料"
                self.isFromCheckBooking = false
                self.performSegue(withIdentifier: "backToBookingCheck", sender: nil)
            }
        } else {
            loginPageView.isHidden = false
            titleNavigationItem.title = ""
            profilePageView.isHidden = true
            navigationItem.rightBarButtonItem?.image = nil
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    @IBAction func unwindToProfilePage(_ segue: UIStoryboardSegue) {
        if segue.identifier == "toProfilePage" {
            let orderDetails = OrderRoomDB()
            let roomParameters = ["action":"getRoomPayDetailById", "idCustomer":"\(self.idCustomer)"]
            orderDetails.getRoomPayDetailById(roomParameters).then {
                rooms -> Promise<[OrderInstantDetail]> in
                self.orderRoomDetails = rooms
                let detailParameters = ["action":"getInstantPayDetail", "idCustomer":"\(self.idCustomer)"]
                return orderDetails.getInstantPayDetail(detailParameters)
            }.done {
                instants in
                self.showCustomerInfo(idCustomer: self.idCustomer)
                self.orderInstantDetails = instants
            }.catch {
                (error) in
                assertionFailure("Login Error: \(error)")
            }
        }
        
    }
    
    //藏鍵盤
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func hideKeyboard() {
        loginEmailText.delegate = self
        loginPasswordText.delegate = self
    }
    
}

