//
//  ViewController.swift
//  OrderManagementSystem
//
//  Created by iOS Developer on 12/04/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var rememberMeCheckBtn: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).userPersistentContainer.viewContext
    var users:[User]?
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchUsers()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func fetchUsers(){
        do{
            users =  try context.fetch(User.fetchRequest())
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    @IBAction func loginBtnTouchUpInside(_ sender: UIButton) {
        var isUserExist = false
        if let userName = usernameTF.text, let password = passwordTF.text, !userName.replacingOccurrences(of: " ", with: "").isEmpty,!password.replacingOccurrences(of: " ", with: "").isEmpty{
            for user in users ?? [] {
                if(user.username == userName && user.passsword == password){
                    isUserExist = true
                    let orderListVC = storyboard?.instantiateViewController(identifier: "OrderListViewController") as! OrderListViewController
                    orderListVC.userId = user.userId
                    self.navigationController?.pushViewController(orderListVC, animated: true)
                }
            }
            if !isUserExist {
                showAlertWith(message: "Invalid user. Please enter valid user credentials.")
            }
        }else{
            showAlertWith(message: "Please enter username and password.")
        }
    }
    
    @IBAction func checkBoxBtnTouchUpInside(_ sender: UIButton) {
        if(sender.tag == 0){
            sender.setBackgroundImage(#imageLiteral(resourceName: "selectedcheckbox1x"), for: .normal)
            sender.tag = 1
        }else{
            sender.setBackgroundImage(#imageLiteral(resourceName: "checkbox1x"), for: .normal)
            sender.tag = 0
        }
    }
    
    @IBAction func registerBtnTouchUpInside(_ sender: UIButton) {
        let registerVC = storyboard?.instantiateViewController(identifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    func showAlertWith(message:String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
            self.usernameTF.text = ""
            self.passwordTF.text = ""
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

// MARK:- Text Field Delegate on return button clicked
extension LoginViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == usernameTF){
            passwordTF.becomeFirstResponder()
        }else{
            passwordTF.resignFirstResponder()
            loginBtnTouchUpInside(loginBtn)
        }
        return true
    }
    
}
