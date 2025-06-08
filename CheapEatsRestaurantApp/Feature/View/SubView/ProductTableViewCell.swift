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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .white
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10))
        configureView(contentView, cornerRadius: 10, borderColor: .clear, borderWidth: 0)
        configureView(foodImage, cornerRadius: 10, borderColor: .clear, borderWidth: 0)
        setShadow(with: contentView.layer, shadowOffset: true)
    }
    
    func configureView(_ view: UIView, cornerRadius: CGFloat, borderColor: UIColor?, borderWidth: CGFloat) {
        view.layer.cornerRadius = cornerRadius
        view.layer.borderColor = borderColor?.cgColor
        view.layer.borderWidth = borderWidth
        view.layer.masksToBounds = true
    }
    
    // MARK: - Ürün gösterme
    func configureCell(wtih product: Product) {
        foodImage.kf.setImage(with: URL(string: product.imageUrl))
        orderNoLabel.isHidden = true
        foodNameLabel.text = product.name
        newAmountLabel.text = "\(product.newPrice) TL"
        
        stateLabel.text = "Beklemede"
        stateLabel.textColor = .systemYellow
        stateImage.tintColor = .systemYellow
        stepperNumber.text = "\(product.quantity) Adet"
    }
    
    // MARK: - Sipariş ve ürün gösterme
    func configureWithOrder(order: Orders, product: Product) {
        if !product.imageUrl.isEmpty {
            foodImage.kf.setImage(with: URL(string: product.imageUrl), placeholder: UIImage(named: "Logo"))
        } else {
            foodImage.image = UIImage(named: "Logo")
        }
        
        foodNameLabel.text = product.name.isEmpty ? "İsimsiz Ürün" : product.name
        orderNoLabel.text = "#\(order.orderNo)"
        newAmountLabel.text = "\(product.newPrice) TL"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateLabel.text = dateFormatter.string(from: order.orderDate)
        dateLabel.isHidden = false
        
        stepperNumber.text = "\(order.quantity) Adet"
        
        configureStateIndicators(with: order.status)
    }
    
    // MARK: - Sadece sipariş gösterme (ürün yoksa)
    func configureWithOrderOnly(order: Orders) {
        // Varsayılan görsel
        foodImage.image = UIImage(named: "Logo")
        
        // Ürün bulunamadığını belirt
        foodNameLabel.text = "Ürün bulunamadı"
        
        // Sipariş no göster
        orderNoLabel.text = "#\(order.orderNo)"
        
        // Fiyat bilgisi yok
        newAmountLabel.text = "-"
        
        // Sipariş saati göster
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateLabel.text = dateFormatter.string(from: order.orderDate)
        dateLabel.isHidden = false
        
        // Miktar göster
        stepperNumber.text = "\(order.quantity) Adet"
        
        // Durum gösterge resmini ve yazısını ayarla
        configureStateIndicators(with: order.status)
    }
    
    // MARK: - Durum göstergeleri yapılandırma
    private func configureStateIndicators(with status: OrderStatus) {
        // Durum metni
        stateLabel.text = status.description
        
        // Durum renkleri
        var stateColor: UIColor
        
        switch status {
        case .preparing:
            stateColor = UIColor(named: "AccentColor") ?? .systemYellow
        case .delivered:
            stateColor = UIColor(named: "ButtonColor") ?? .systemGreen
        case .canceled:
            stateColor = UIColor(named: "Cutcolor") ?? .systemRed
        }
        
        // Metin rengini ayarla
        stateLabel.textColor = stateColor
        
        // Durum görselini göster ve rengini ayarla
        stateImage.isHidden = false
        stateImage.tintColor = stateColor
        
    }
    
    // MARK: - Gölge efekti
    func setShadow(with layer: CALayer, shadowOffset: Bool) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4
        if shadowOffset {
            layer.shadowOffset = CGSize(width: 0, height: 2)
        } else {
            layer.shadowOffset = .zero
        }
    }
    
    
}
