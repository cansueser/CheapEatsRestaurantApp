//
//  Order.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 28.02.2025.
//
import UIKit
import Firebase

struct Orders {
    var orderId: String
    var orderDate: Date
    var orderNo: String
    var productId: String
    var status: OrderStatus
    var userId: String
    var cardInfo: String
    var selectedDeliveryType: DeliveryType
    
    init?(dictionary: [String: Any], documentId: String) {
        self.orderId = documentId
        if let timestamp = dictionary["orderDate"] as? Timestamp {
            self.orderDate = timestamp.dateValue()
        } else {
            self.orderDate = Date()
        }
        self.orderNo = dictionary["orderNo"] as? String ?? ""
        self.cardInfo = dictionary["cardInfo"] as? String ?? ""
        self.productId = dictionary["productId"] as? String ?? ""
        let statusString = dictionary["status"] as? String ?? OrderStatus.delivered.rawValue
        self.status = OrderStatus(rawValue: statusString) ?? .preparing
        self.userId = dictionary["userId"] as? String ?? ""
        let selectedDeliveryTypeString = dictionary["selectedDeliveryType"] as? String ?? DeliveryType.delivery.rawValue
        self.selectedDeliveryType = DeliveryType(rawValue: selectedDeliveryTypeString) ?? .delivery
    }
    
    init(productId: String, userId: String, selectedDeliveryType: DeliveryType) {
        self.orderId = ""
        self.orderDate = Date()
        self.orderNo = ""
        self.productId = productId
        self.status = .preparing
        self.userId = userId
        self.cardInfo = ""
        self.selectedDeliveryType = selectedDeliveryType
    }
}

enum OrderStatus: String, Codable, CaseIterable, CustomStringConvertible {
    case preparing = "Hazırlanıyor"
    case delivered = "Teslim Edildi"
    case canceled = "İptal Edildi"
    
    var description: String {
        return self.rawValue
    }
    
    var textColor: UIColor {
        switch self {
        case .preparing: return .systemYellow
        case .delivered: return .systemGreen
        case .canceled: return .systemRed
        }
    }
}
