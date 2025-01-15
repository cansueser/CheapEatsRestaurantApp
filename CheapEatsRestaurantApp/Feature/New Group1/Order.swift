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
    var oldPrice: Double
    var newPrice: Double
    var deliveryType: Int
    var discountType: Int
    var startTime: Date
    var endTime: Date
    var foodImage: UIImage
    var orderStatus: OrderStatus
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
        print("update")

    }
}

