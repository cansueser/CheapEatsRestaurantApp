//
//  OrderDetailViewModel.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 10.06.2025.
//

import Foundation
import MapKit
import UIKit

protocol OrderDetailViewModelProtocol {
    var delegate: OrderDetailViewModelOutputProtocol? { get set}
    var order: OrderDetail? { get set }
    //var coupon: Coupon? { get set }
    var totalAmount: Double { get set }
    //func getCoupon()
    func checkDeliveryType() -> Bool
}

protocol OrderDetailViewModelOutputProtocol: AnyObject {
    func update()
    func couponUpdated()
    func errorCoupon()
    func error()
}

final class OrderDetailViewModel {
    weak var delegate: OrderDetailViewModelOutputProtocol?
    var order: OrderDetail?
    //var coupon: Coupon?
    var totalAmount: Double = 0.0
    
//    func getCoupon() {
//        totalAmount = order?.productDetail.product.newPrice ?? 0.0
//        guard let id = order?.userOrder.couponId, !id.isEmpty else {
//            self.delegate?.errorCoupon()
//            return
//        }
//        NetworkManager.shared.fetchCouponById(id: id) { result in
//            switch result {
//            case .success(let coupon):
//                self.coupon = coupon
//                self.totalAmount -= Double(coupon.discountValue)
//                self.delegate?.couponUpdated()
//            case .failure(_):
//                self.delegate?.errorCoupon()
//            }
//        }
//    }
    
    func checkDeliveryType() -> Bool {
        guard let order = order else {
            return false
        }
        switch order.userOrder.selectedDeliveryType {
        case .delivery:
            return false
        case .takeout:
            self.totalAmount += 20.0
            return true
        case .all:
            return false
        }
    }
}

extension OrderDetailViewModel: OrderDetailViewModelProtocol {}
