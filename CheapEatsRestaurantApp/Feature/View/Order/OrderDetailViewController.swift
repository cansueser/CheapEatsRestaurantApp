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
    @IBOutlet weak var customerView: UIView!
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
    
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var customerMailLabel: UILabel!
    @IBOutlet weak var customerSurnameLabel: UILabel!
    @IBOutlet weak var customerTelLabel: UILabel!
    
    @IBOutlet weak var updateStatusButton: UIButton!
    var orderDetailViewModel: OrderDetailViewModelProtocol = OrderDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initConfigureView()
        initScreen()
        orderDetailViewModel.getCoupon()
        checkDeliveryType()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .button
    }
    
    private func initConfigureView() {
        scrollView.delegate = self
        configureView(detailImageView, cornerRadius: 5, borderColor: .gray, borderWidth: 0.5)
        configureView(orderDetailView, cornerRadius: 5)
        configureView(orderDetailExtView, cornerRadius: 5)
        configureView(customerView, cornerRadius: 5)
        configureView(paymentDetailView, cornerRadius: 5)
        setBorder(with: orderDetailView.layer)
        setBorder(with: orderDetailExtView.layer)
        setBorder(with: customerView.layer)
        setBorder(with: paymentDetailView.layer)
        setShadow(with: orderDetailExtView.layer , shadowOffset: true)
        setShadow(with: orderDetailView.layer, shadowOffset: false)
        setShadow(with: customerView.layer, shadowOffset: true)
        setShadow(with: paymentDetailView.layer, shadowOffset: true)
        paymentDetailView.lineYPosition = totalLabel.frame.origin.y - 10
        paymentDetailView.setNeedsDisplay()
        updateStatusButton.layer.cornerRadius = 5
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
            case .pending:
                orderStatusLabel.textColor = .systemGray
            case .preparing:
                orderStatusLabel.textColor = .systemOrange
            case .ready:
                orderStatusLabel.textColor = .title
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
            
            customerNameLabel.text = order.user.firstName
            customerSurnameLabel.text = order.user.lastName
            customerMailLabel.text = order.user.email
            customerTelLabel.text = order.user.phoneNumber
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
    
    
    @IBAction func updateStatusButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Sipariş Durumunu Seç", message: nil, preferredStyle: .actionSheet)
        for status in OrderStatus.allCases {
            alert.addAction(UIAlertAction(title: status.rawValue, style: .default, handler: { [weak self] _ in
                self?.orderDetailViewModel.updateOrderStatus(newStatus: status)
            }))
        }
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
}
extension OrderDetailViewController: OrderDetailViewModelOutputProtocol {
    func couponUpdated() {
        guard let couponId = orderDetailViewModel.coupon else {
            couponLabel.isHidden = true
            couponStateLabel.isHidden = true
            return
        }
        couponLabel.isHidden = false
        couponStateLabel.isHidden = false
        couponStateLabel.text = "Kupon(\(couponId.code))"
        couponLabel.text = "-\(couponId.discountValue) TL"
        totalLabel.text = "\(formatDouble(orderDetailViewModel.totalAmount)) TL"
        
    }
    
    func errorCoupon() {
        couponLabel.isHidden = true
        couponStateLabel.isHidden = true
    }
    
    func update() {
        guard let order = orderDetailViewModel.order else { return }
        orderStatusLabel.text = "\(order.userOrder.status)"
        switch order.userOrder.status {
        case .pending:
            orderStatusLabel.textColor = .systemGray
        case .preparing:
            orderStatusLabel.textColor = .systemOrange
        case .ready:
            orderStatusLabel.textColor = .title
        case .delivered:
            orderStatusLabel.textColor = .button
        case .canceled:
            orderStatusLabel.textColor = .cut
        }
        showOneButtonAlert(title: "Başarılı", message: "Durum değiştirme işlemi başarılı.")
    }
    
    func error() {
        print("error")
    }
}
