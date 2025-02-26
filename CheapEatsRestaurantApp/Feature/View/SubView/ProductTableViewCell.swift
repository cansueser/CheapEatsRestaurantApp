//
//  TableViewCellAdded.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 9.12.2024.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
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
        contentView.backgroundColor = .white
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10))
        configureView(contentView, cornerRadius: 10, borderColor: .yeşil, borderWidth: 2)
        configureView(foodImage, cornerRadius: 10, borderColor: .yeşil, borderWidth: 1)
        
        
    } 
    func configureView(_ view: UIView, cornerRadius: CGFloat, borderColor: UIColor?, borderWidth: CGFloat) {
        view.layer.cornerRadius = cornerRadius
        view.layer.borderColor = borderColor?.cgColor
        view.layer.borderWidth = borderWidth
        view.layer.masksToBounds = true
    }
    
    func configureCell(wtih order: Order) {
        foodNameLabel.text = order.name
        oldAmountLabel.text = "\(order.oldPrice) TL"
        newAmountLabel.text = "\(order.newPrice) TL"
        stateLabel.text = order.orderStatus.description
        stateLabel.textColor = order.orderStatus.textColor
        dateLabel.text = dateFormatter().string(from: order.endTime)
    }
    
    private func dateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }
    
}
