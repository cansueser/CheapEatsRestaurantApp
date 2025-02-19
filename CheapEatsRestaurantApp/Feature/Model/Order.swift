//
//  Product.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 23.12.2024.
//

import Foundation
import UIKit
import FirebaseFirestore
import Firebase

struct Order {
    var id: String?
    var name: String
    var description: String
    var oldPrice: Int
    var newPrice: Int
    var discountType: Int
    var endTime: Date
    var orderStatus: OrderStatus
    var deliveryTypeTitle: String
    var mealTypes: [String]
    var imageUrl: String?

    init(
        id: String? = nil,
        name: String,
        description: String,
        oldPrice: Int,
        newPrice: Int,
        discountType: Int,
        endTime: Date,
        orderStatus: OrderStatus,
        deliveryTypeTitle: String,
        mealTypes: [String],
        imageUrl :String
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.oldPrice = oldPrice
        self.newPrice = newPrice
        self.discountType = discountType
        self.endTime = endTime
        self.orderStatus = orderStatus
        self.deliveryTypeTitle = deliveryTypeTitle
        self.mealTypes = mealTypes
        self.imageUrl = imageUrl
    }


    // Firestore'dan veri alırken kullanılacak init
    init?(document: [String: Any]) {
        guard let name = document["name"] as? String,
              let description = document["description"] as? String,
              let oldPrice = document["oldPrice"] as? Int,
              let newPrice = document["newPrice"] as? Int,
              let discountType = document["discountType"] as? Int,
              let endTime = document["endTime"] as? Timestamp,
              let statusString = document["orderStatus"] as? String,
              let orderStatus = OrderStatus(rawValue: statusString),
              let deliveryTypeTitle = document["deliveryTypeTitle"] as? String,
              let imageUrl = document["imageUrl"] as? String?,
              let mealTypes = document["mealTypes"] as? [String] else {
            return nil
        }
        
        self.id = document["id"] as? String
        self.name = name
        self.description = description
        self.oldPrice = oldPrice
        self.newPrice = newPrice
        self.discountType = discountType
        self.endTime = endTime.dateValue()
        self.orderStatus = orderStatus
        self.deliveryTypeTitle = deliveryTypeTitle
        self.mealTypes = mealTypes
        self.imageUrl = imageUrl
    }
    
    // Firestore'a gönderilecek dictionary
    func toDictionary() -> [String: Any] {
        return [
            "name": name,
            "description": description,
            "oldPrice": oldPrice,
            "newPrice": newPrice,
            "discountType": discountType,
            "endTime": Timestamp(date: endTime),
            "orderStatus": orderStatus.rawValue,
            "deliveryTypeTitle": deliveryTypeTitle,
            "mealTypes": mealTypes,
            "imageUrl" : imageUrl ?? ""
        ]
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
