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
    var discountType: Int
    var endTime: Date
    var foodImage: UIImage?
    var orderStatus: OrderStatus
    var deliveryTypeTitle: String
   // var id: String? // Firestore document ID
  //  var imageURL: String // Firebase Storage URL
    var mealTypes: [String]
    init(name: String, description: String, oldPrice: Int, newPrice: Int, deliveryTypeTitle: String, discountType: Int, endTime: Date, foodImage: UIImage?, orderStatus: OrderStatus,mealTypes : [String]) {
        self.name = name
        self.description = description
        self.oldPrice = oldPrice
        self.newPrice = newPrice
        self.deliveryTypeTitle = deliveryTypeTitle
        self.discountType = discountType
        self.endTime = endTime
        self.foodImage = foodImage
        self.orderStatus = orderStatus
        self.mealTypes = mealTypes
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

