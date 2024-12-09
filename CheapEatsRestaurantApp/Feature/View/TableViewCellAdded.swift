//
//  TableViewCellAdded.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 9.12.2024.
//

import UIKit

class TableViewCellAdded: UITableViewCell {

    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var orderNoLabel: UILabel!
    @IBOutlet weak var oldAmountLabel: UILabel!
    @IBOutlet weak var newAmountLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var stateImage: UIImageView!
    
    @IBOutlet weak var siparisBackView: UIView!
    
    @IBOutlet weak var priceBackView: UIView!
    
    @IBOutlet weak var stateBackView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .textWhite
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10))
        contentView.roundCorners(corners: [.allCorners], radius: 10, borderColor: UIColor(named: "ButtonColor"), borderWidth: 2)
        foodImage.roundCorners(corners: [.allCorners], radius: 10, borderColor: UIColor(named: "ButtonColor"), borderWidth: 1)
       
    }
    
}
