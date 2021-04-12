//
//  OrderDetailsTableViewCell.swift
//  OrderManagementSystem
//
//  Created by iOS Developer on 12/04/21.
//

import UIKit

class OrderDetailsTableViewCell: UITableViewCell {
    
    static let identifier = "OrderDetailsTableViewCell"

    @IBOutlet weak var cardbackgroundView: UIView!
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var dueAmountLabel: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
