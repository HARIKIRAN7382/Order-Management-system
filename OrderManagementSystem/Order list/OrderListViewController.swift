//
//  OrderedListViewController.swift
//  OrderManagementSystem
//
//  Created by iOS Developer on 12/04/21.
//

import UIKit

class OrderListViewController: UIViewController {
    
    @IBOutlet weak var ordersTableView: UITableView!
    @IBOutlet weak var noOrdersView: UIView!
    @IBOutlet weak var noOrdersLabel: UILabel!
    @IBOutlet weak var noOrderLabelHeightContraint: NSLayoutConstraint!
    
    
    var userId:String?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).orderDetailsPersistentContainer.viewContext
    var orders:[Order]?
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchOrders()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Orders"
        self.navigationItem.setHidesBackButton(true, animated: true)
        let addNewOrderBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "add"), style: .done, target: self, action: #selector(addNewOrder(_:)))
        self.navigationItem.rightBarButtonItem = addNewOrderBarButton
    }
    
    @objc func addNewOrder( _ sender:UIBarButtonItem){
        let addOrEditOrderVC = (storyboard?.instantiateViewController(identifier: "AddOrUpdateOrderViewController"))! as AddOrUpdateOrderViewController
        addOrEditOrderVC.userId = self.userId
        navigationController?.pushViewController(addOrEditOrderVC, animated: true)
    }
    
    func fetchOrders(){
        do{
            let tempOrders = try context.fetch(Order.fetchRequest())
            orders = tempOrders.filter { ($0 as! Order).user_id == self.userId } as? [Order]
            if((orders?.count ?? 0) > 0){
                DispatchQueue.main.async {
                    self.noOrdersView.isHidden = true
                    self.noOrdersLabel.isHidden = true
                    self.noOrderLabelHeightContraint.constant = 0
                    self.ordersTableView.isHidden = false
                    self.ordersTableView.reloadData()
                }
            }else{
                DispatchQueue.main.async {
                    self.noOrdersView.isHidden = false
                    self.noOrdersLabel.isHidden = false
                    self.noOrderLabelHeightContraint.constant = 46
                    self.ordersTableView.isHidden = true
                }
            }
          
        }catch let error{
            print(error.localizedDescription)
        }
    }

}


//MARK:- Table View Delegate Methods
extension OrderListViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! OrderDetailsTableViewCell).cardbackgroundView.layer.cornerRadius = 20.0
        (cell as! OrderDetailsTableViewCell).cardbackgroundView.layer.shadowColor = UIColor.gray.cgColor
        (cell as! OrderDetailsTableViewCell).cardbackgroundView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        (cell as! OrderDetailsTableViewCell).cardbackgroundView.layer.shadowRadius = 6.0
        (cell as! OrderDetailsTableViewCell).cardbackgroundView.layer.shadowOpacity = 0.3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderDetailsTableViewCell.identifier,for: indexPath) as!  OrderDetailsTableViewCell
        cell.orderIdLabel.text = orders?[indexPath.row].order_number
        cell.dueDateLabel.text = orders?[indexPath.row].order_due_date
        cell.nameLabel.text = orders?[indexPath.row].customer_name
        cell.addressLabel.text = orders?[indexPath.row].customer_address
        cell.phoneNumberLabel.text = orders?[indexPath.row].customer_phone
        cell.dueAmountLabel.text = orders?[indexPath.row].total_amount
        cell.deleteBtn.tag = indexPath.row
        cell.editBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(deleteOrderFromList(_:)), for: .touchUpInside)
        cell.editBtn.addTarget(self, action: #selector(editOrderFormList(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func deleteOrderFromList(_ sender:UIButton){
        let alert = UIAlertController(title: "Alert", message: "Are you sure to delete this order?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
            if let orderNeedToRemove = self.orders?[sender.tag] {
                self.context.delete(orderNeedToRemove)
                self.fetchOrders()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.navigationController?.present(alert, animated: true, completion: nil)
      
    }
    
    @objc func editOrderFormList(_ sender:UIButton){
        let addOrEditOrderVC = (storyboard?.instantiateViewController(identifier: "AddOrUpdateOrderViewController"))! as AddOrUpdateOrderViewController
        addOrEditOrderVC.userId = self.userId
        addOrEditOrderVC.isEditingExistantOrder = true
        addOrEditOrderVC.selecteOrder = self.orders?[sender.tag]
        navigationController?.pushViewController(addOrEditOrderVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
