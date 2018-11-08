//
//  JoinTableViewController.swift
//  iOS-Customer
//
//  Created by Una Lee on 2018/10/9.
//  Copyright © 2018 Hsin Hwang. All rights reserved.
//

import UIKit

class JoinTableViewController: UITableViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var rePasswordField: UITextField!
    @IBOutlet weak var genderSegmented: UISegmentedControl!
    @IBOutlet weak var birthdayLable: UILabel!
    @IBOutlet weak var birthdayDatePicker: UIDatePicker!
    @IBOutlet weak var phoneField: UIView!
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
    
   
    //Gender Select
    @IBAction func genderTypeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            let gender = "female"
        case 1:
            let gender = "male"
            
        default:
            break
        }
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
        formateer.dateFormat = "yyyy/MM/dd"
        let dateString = formateer.string(from: date)
        birthdayLable.text = dateString
    }
    
    
    @IBAction func joinButton(_ sender: Any) {
        
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "蝦殼飯店", message: "取消註冊", preferredStyle: .alert)
        let ok = UIAlertAction(title: "確定", style: .destructive){
            (action) in
            
            
//            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let homePage = mainStoryboard.instantiateViewController(withIdentifier: "HomePage")
//            self.navigationController?.pushViewController(homePage, animated: true)
//            let home = Ho
//            self.present(home, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "取消", style: .default)
        alert.addAction(cancel)
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
    }
    
    
   
    
    

}