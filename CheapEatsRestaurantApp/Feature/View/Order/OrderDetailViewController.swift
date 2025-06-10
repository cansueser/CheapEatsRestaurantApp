//
//  OrderDetailViewController.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 10.06.2025.
//


import UIKit

final class OrderDetailViewController: UIViewController {
    //MARK: -Variables
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var orderDetailView: UIView!
    @IBOutlet weak var orderDetailExtView: UIView!
    @IBOutlet weak var paymentDetailView: CustomLineView!
    @IBOutlet weak var adressDetailView: UIView!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var orderNo: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var orderStatusLabel: UILabel!
    @IBOutlet weak var deliveryTypeLabel: UILabel!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var oldAmountLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var couponLabel: UILabel!
    @IBOutlet weak var newAmountLabel: UILabel!
    @IBOutlet weak var couponStateLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    
    var orderDetailViewModel: OrderDetailViewModelProtocol = OrderDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initConfigureView()
        initScreen()
        //orderDetailViewModel.getCoupon()
        checkDeliveryType()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = UIColor(named: "ButtonColor")
    }
    
    private func initConfigureView() {
        scrollView.delegate = self
        configureView(detailImageView, cornerRadius: 5, borderColor: .gray, borderWidth: 0.5)
        configureView(orderDetailView, cornerRadius: 5)
        configureView(orderDetailExtView, cornerRadius: 5)
        configureView(adressDetailView, cornerRadius: 5)
        configureView(paymentDetailView, cornerRadius: 5)
        setBorder(with: orderDetailView.layer)
        setBorder(with: orderDetailExtView.layer)
        setBorder(with: adressDetailView.layer)
        setBorder(with: paymentDetailView.layer)
        setShadow(with: orderDetailExtView.layer , shadowOffset: true)
        setShadow(with: orderDetailView.layer, shadowOffset: false)
        setShadow(with: adressDetailView.layer, shadowOffset: true)
        setShadow(with: paymentDetailView.layer, shadowOffset: true)
        paymentDetailView.lineYPosition = totalLabel.frame.origin.y - 10
        paymentDetailView.setNeedsDisplay()
        
    }
    
    private func initScreen() {
        orderDetailViewModel.delegate = self
        
        if let order = orderDetailViewModel.order {
            companyLabel.text = RestaurantManager.shared.getRestaurantName()
            foodLabel.text = "\(order.product.name)"
            totalPriceLabel.text = "\(formatDouble(order.product.newPrice)) TL"
            orderNo.text = "#\(order.userOrder.orderNo)"
            dateLabel.text = "\(dateFormatter(with: order.userOrder.orderDate))"
            orderStatusLabel.text = "\(order.userOrder.status)"
            switch order.userOrder.status {
            case .preparing:
                orderStatusLabel.textColor = .systemOrange
            case .delivered:
                orderStatusLabel.textColor = .button
            case .canceled:
                orderStatusLabel.textColor = .cut
            }
            cardNumberLabel.text = "**** **** **** \(order.userOrder.cardInfo)"
            let oldAmount = Double(order.product.oldPrice)
            let newAmount = Double(order.product.newPrice)
            oldAmountLabel.text = "\(formatDouble(order.product.oldPrice)) TL"
            discountLabel.text = "-\(formatDouble(oldAmount - newAmount)) TL"
            newAmountLabel.text = "\(formatDouble(order.product.newPrice)) TL"
            totalLabel.text = "\(formatDouble(newAmount)) TL"
        }
    }
    
    func checkDeliveryType() {
        if orderDetailViewModel.checkDeliveryType() {
            deliveryLabel.text = "(Kurye Ücreti: 20 TL)"
            deliveryLabel.isHidden = false
            deliveryTypeLabel.text = "Kurye"
            totalLabel.text = "\(formatDouble(orderDetailViewModel.totalAmount)) TL"
        } else {
            deliveryLabel.isHidden = true
            deliveryTypeLabel.text = "Gel-Al"
        }
    }
    
}
extension OrderDetailViewController: OrderDetailViewModelOutputProtocol {
    func couponUpdated() {
//        guard let couponId = orderDetailViewModel.coupon else {
//            couponLabel.isHidden = true
//            couponStateLabel.isHidden = true
//            return
//        }
//        couponLabel.isHidden = false
//        couponStateLabel.isHidden = false
//        couponStateLabel.text = "Kupon(\(couponId.code))"
//        couponLabel.text = "-\(couponId.discountValue) TL"
//        totalLabel.text = "\(formatDouble(orderDetailViewModel.totalAmount)) TL"
//        
    }
    
    func errorCoupon() {
        couponLabel.isHidden = true
        couponStateLabel.isHidden = true
    }
    
    func update() {
        print("update")
    }
    
    func error() {
        print("error")
    }
}
