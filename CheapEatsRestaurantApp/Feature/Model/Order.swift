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
    var productId: String?
    var name: String
    var description: String
    var oldPrice: Int
    var newPrice: Int
    var restaurantId: String?
    var category: [String] //enuma çevir
    var imageUrl: String?
    //var deliveryTypeTitle: String //enuma çevir+
    var deliveryType: DeliveryType
    var discountType: Int
    var endTime: Date // adını createdAt
    //var endDate: String
    var orderStatus: OrderStatus //bool şeklinde yapılacak

    init(
        productId: String? = nil,
        name: String,
        description: String,
        oldPrice: Int,
        newPrice: Int,
        discountType: Int,
        endTime: Date,
        orderStatus: OrderStatus,
        deliveryType: DeliveryType,
        restaurantId: String? = nil,
        category: [String],
        imageUrl :String
    ) {
        self.productId = productId
        self.name = name
        self.description = description
        self.oldPrice = oldPrice
        self.newPrice = newPrice
        self.discountType = discountType
        self.endTime = endTime
        self.orderStatus = orderStatus
        self.deliveryType = deliveryType
        self.restaurantId = restaurantId
        self.category = category
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
              let deliveryTypeString = document["deliveryType"] as? String,
              let deliveryType = DeliveryType(rawValue: deliveryTypeString),
              let imageUrl = document["imageUrl"] as? String?,
              let restaurantId = document["restaurantId"] as? String?,
              let category = document["category"] as? [String] else {
            return nil
        }
        
        self.productId = document["productId"] as? String
        self.name = name
        self.description = description
        self.oldPrice = oldPrice
        self.newPrice = newPrice
        self.discountType = discountType
        self.endTime = endTime.dateValue()
        self.orderStatus = orderStatus
        self.deliveryType = deliveryType
        self.imageUrl = imageUrl
        self.restaurantId = document["restaurantId"] as? String
        self.category = category
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
            "deliveryType": deliveryType.rawValue,
            "restaurantId": restaurantId ?? "1327",
            "category": category,
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
//burayı kodun içinde değiştir
enum DeliveryType: String, CaseIterable {
    case all = "Hepsi"
    case delivery = "Gel-Al"
    case takeout = "Kurye"
    
    var title: String {
        return self.rawValue
    }
    
    init?(index: Int) {
        switch index {
        case 0: self = .all
        case 1: self = .delivery
        case 2: self = .takeout
        default: return nil
        }
    }
    
    var index: Int {
        switch self {
        case .all: return 0
        case .delivery: return 1
        case .takeout: return 2
        }
    }
}
enum Category: String, CaseIterable, CustomStringConvertible {
    case burger = "Burger"
    case doner = "Döner"
    case tatlı = "Tatlı"
    case pizza = "Pizza"
    case tavuk = "Tavuk"
    case kofte = "Köfte"
    case evYemek = "Ev Yemekleri"
    case pastane = "Pastane & Fırın"
    case kebap = "Kebap"
    case kahvaltı = "Kahvaltı"
    case vegan = "Vegan"
    case corba = "Çorba"
    
    var description: String {
        return self.rawValue
    }
    
    static func getAllCategories() -> [Category] {
        return Array(Category.allCases)
    }
    
    static func getAllCategoriesNames() -> [String] {
        return Array(Category.allCases.map{$0.rawValue})
    }
}
