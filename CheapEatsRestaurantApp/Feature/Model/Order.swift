//
//  Product.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 23.12.2024.
//

import Foundation
//YENİ
import UIKit

struct Order {
    var name: String
    var description: String
    var oldPrice: Int
    var newPrice: Int
    var deliveryType: Int
    var discountType: Int
    var startTime: Date
    var endTime: Date
    var foodImage: UIImage?
    var orderStatus: OrderStatus
    init(name: String, description: String, oldPrice: Int, newPrice: Int, deliveryType: Int, discountType: Int, startTime: Date, endTime: Date, foodImage: UIImage?, orderStatus: OrderStatus) {
         self.name = name
         self.description = description
         self.oldPrice = oldPrice
         self.newPrice = newPrice
         self.deliveryType = deliveryType
         self.discountType = discountType
         self.startTime = startTime
         self.endTime = endTime
         self.foodImage = foodImage
         self.orderStatus = orderStatus
     }
}
enum OrderStatus: String, CaseIterable, CustomStringConvertible {
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

