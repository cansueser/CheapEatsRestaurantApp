//
//  TableViewCellAdded.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 9.12.2024.
//

import UIKit
import Kingfisher

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var orderNoLabel: UILabel!
    @IBOutlet weak var newAmountLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var stateImage: UIImageView!
    @IBOutlet weak var siparisBackView: UIView!
    @IBOutlet weak var priceBackView: UIView!
    @IBOutlet weak var stateBackView: UIView!
    @IBOutlet weak var stepperNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .white
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10))
        configureView(contentView, cornerRadius: 10, borderColor: .title, borderWidth: 1)
        configureView(foodImage, cornerRadius: 10, borderColor: .title, borderWidth: 1)
        setShadow(with:contentView.layer, shadowOffset: true)
        
    } 
    func configureView(_ view: UIView, cornerRadius: CGFloat, borderColor: UIColor?, borderWidth: CGFloat) {
        view.layer.cornerRadius = cornerRadius
        view.layer.borderColor = borderColor?.cgColor
        view.layer.borderWidth = borderWidth
        view.layer.masksToBounds = true
    }
    
    func configureCell(wtih order: Product) {
        foodImage.kf.setImage(with: URL(string: order.imageUrl))
        foodNameLabel.text = order.name
        newAmountLabel.text = "\(order.newPrice) TL"
        stateLabel.text = order.status.description
        dateLabel.text = "\(order.endDate)"
        stepperNumber.text = "\(order.quantity.description) Adet"
    }
    func fakeconfigureCell() {
        foodImage.image = UIImage(named: "Logo")
        foodNameLabel.text = "Tavuk Döner"
        newAmountLabel.text = "150 TL"
        stateLabel.text = "Hazırlanıyor"
        dateLabel.text = "12:30"
        stepperNumber.text = "5 Adet"
    }
    
}
