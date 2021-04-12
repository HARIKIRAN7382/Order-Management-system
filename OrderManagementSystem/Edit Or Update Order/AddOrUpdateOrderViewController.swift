//
//  EditOrUpdateOrderViewController.swift
//  OrderManagementSystem
//
//  Created by iOS Developer on 12/04/21.
//

import UIKit

class AddOrUpdateOrderViewController: UIViewController {
    
    @IBOutlet weak var customerNameTF: UITextField!
    @IBOutlet weak var customerAddressTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var orderIdTF: UITextField!
    @IBOutlet weak var dueAmountTF: UITextField!
    @IBOutlet weak var selectDueDateButton: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    var userId:String?
    var isEditingExistantOrder:Bool?
    var selecteOrder:Order?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).orderDetailsPersistentContainer.viewContext
    
    let date = Date()
    let formatter = DateFormatter()
    var keyBoardHeight:CGFloat?
    
    // MARK:- Picker View to combine done and date picker.
    lazy var pickerView:UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        return view
    }()
    
    lazy var doneButton:UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        button.setTitleColor(UIColor(red: 188/255, green: 0, blue: 19/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(onPickerViewDoneBtnTouchUpInside(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var picker:UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = UIDatePicker.Mode.date
        picker.preferredDatePickerStyle = .wheels
        picker.addTarget(self, action: #selector(dueDateChanged(_:)), for: UIControl.Event.valueChanged)
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "dd-MM-yyyy"
        self.title = "Add New Order"
        selectDueDateButton.setTitle( "  \(formatter.string(from: date))" , for: .normal)
        
        customerNameTF.addPreviousNextDoneToolbar()
        customerAddressTF.addPreviousNextDoneToolbar()
        phoneNumberTF.addPreviousNextDoneToolbar()
        orderIdTF.addPreviousNextDoneToolbar()
        dueAmountTF.addPreviousNextDoneToolbar()
        
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShow),name: UIResponder.keyboardWillShowNotification,object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if let isEditingExistantOrder = isEditingExistantOrder, isEditingExistantOrder {
            customerNameTF.text = selecteOrder?.customer_name
            customerAddressTF.text = selecteOrder?.customer_address
            phoneNumberTF.text = selecteOrder?.customer_phone
            orderIdTF.text = selecteOrder?.order_number
            dueAmountTF.text = selecteOrder?.total_amount
            selectDueDateButton.setTitle(selecteOrder?.order_due_date, for: .normal)
            saveBtn.setTitle("Update", for: .normal)
            self.title = "Update Order Details"
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func selectDueDateBtnTouchUpInside(_ sender: UIButton) {
        self.view.addSubview(pickerView)
        configPickerViewConstraints()
    }
    
    
    @IBAction func registerBtnTouchUpInside(_ sender: UIButton) {
        if let customerName = customerNameTF.text, let address = customerAddressTF.text, let phoneNum = phoneNumberTF.text, let orderId = orderIdTF.text, let dueAmount = dueAmountTF.text,!customerName.replacingOccurrences(of: " ", with: "").isEmpty,!address.replacingOccurrences(of: " ", with: "").isEmpty,!phoneNum.replacingOccurrences(of: " ", with: "").isEmpty,!orderId.replacingOccurrences(of: " ", with: "").isEmpty,!dueAmount.replacingOccurrences(of: " ", with: "").isEmpty{
            if(sender.titleLabel?.text == "Update"){
                selecteOrder?.customer_name = customerName
                selecteOrder?.customer_address = address
                selecteOrder?.customer_phone = phoneNum
                selecteOrder?.order_number = orderId
                selecteOrder?.order_due_date = (selectDueDateButton.titleLabel?.text ?? "").replacingOccurrences(of: " ", with: "")
                selecteOrder?.total_amount = dueAmount
                selecteOrder?.user_id = userId
                do{
                    try context.save()
                    DispatchQueue.main.async {
                        self.showAlertWithMsg(message: "Order is updated successsfully.", navigateToOrdersList: false, isUpdatingExistantOrder: true)
                    }
                }catch let error{
                    print(error.localizedDescription)
                }
            }else{
                let order = Order(context: self.context)
                order.customer_name = customerName
                order.customer_address = address
                order.customer_phone = phoneNum
                order.order_number = orderId
                order.order_due_date = (selectDueDateButton.titleLabel?.text ?? "").replacingOccurrences(of: " ", with: "")
                order.total_amount = dueAmount
                order.user_id = userId
                do{
                    try context.save()
                    DispatchQueue.main.async {
                        self.showAlertWithMsg(message: "Ordered saved successfully. Do you want add one more order?", navigateToOrdersList: true, isUpdatingExistantOrder: false)
                    }
                }catch let error{
                    print(error.localizedDescription)
                }
            }
        }else{
            showAlertWithMsg(message: "Please enter all required input fields.", navigateToOrdersList: false, isUpdatingExistantOrder: false)
        }
    }
    
    // MARK:- Config For Pickview for Done button and Date Picker
    func configPickerViewConstraints(){
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        configDatePicker()
    }
    
    // MARK:- Config Done Button and Date Picker
    func configDatePicker(){
        
        // MARK:- Config Done Button
        pickerView.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: pickerView.topAnchor,constant: 5),
            doneButton.trailingAnchor.constraint(equalTo: pickerView.trailingAnchor, constant: -50)
        ])
        
        // MARK:- Config DatePicker
        pickerView.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            picker.topAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 5),
            picker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            picker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            picker.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
    @objc func onPickerViewDoneBtnTouchUpInside(_ sender:UIButton){
        pickerView.removeFromSuperview()
    }
    
    @objc  func dueDateChanged(_ sender:UIDatePicker){
        selectDueDateButton.setTitle( "  \(formatter.string(from: sender.date))", for: .normal)
    }
}

// MARK:- Keyboard Notification

extension AddOrUpdateOrderViewController{
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyBoardHeight = keyboardRectangle.height
        }
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue  {
            if(self.view.frame.origin.y == 0 && dueAmountTF.isFirstResponder){
                self.view.frame.origin.y -= keyboardSize.height / 2
            }else{
                self.view.frame.origin.y = 0
            }
        }
        
    }
    
    @objc func keyboardWillHide(_ sender: NSNotification) {
        if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyBoardHeight = keyboardRectangle.height
            self.view.frame.origin.y = 0
        }
    }
    
    func showAlertWithMsg(message:String,navigateToOrdersList:Bool,isUpdatingExistantOrder:Bool){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        if navigateToOrdersList {
            self.customerNameTF.text = ""
            self.customerAddressTF.text = ""
            self.phoneNumberTF.text = ""
            self.orderIdTF.text = ""
            self.dueAmountTF.text = ""
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
                self.selectDueDateButton.setTitle("  \(self.formatter.string(from: self.date))", for: .normal)
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }))
        }else if isUpdatingExistantOrder{
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }))
        }else{
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
            }))
        }
        present(alert, animated: true, completion: nil)
    }
}

extension AddOrUpdateOrderViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == phoneNumberTF || textField == orderIdTF){
            let maxLength = 10
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
       return true
    }
}
