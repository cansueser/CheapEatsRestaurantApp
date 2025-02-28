//
//  Product.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 23.12.2024.
//

import Foundation
import Firebase

struct Product {
    var productId: String
    var name: String
    var description: String
    var oldPrice: Int
    var newPrice: Int
    var restaurantId: String
    var category: [String]
    var imageUrl: String
    var deliveryType: DeliveryType
    var endDate: String
    var status: Bool
    var createdAt: Date

    init(
        name: String,
        description: String,
        oldPrice: Int,
        newPrice: Int,
        endDate: String,
        deliveryType: DeliveryType,
        restaurantId: String,
        category: [String],
        imageUrl :String
    ) {
        self.productId = ""
        self.name = name
        self.description = description
        self.oldPrice = oldPrice
        self.newPrice = newPrice
        self.endDate = endDate
        self.status = false
        self.deliveryType = deliveryType
        self.restaurantId = restaurantId
        self.category = category
        self.imageUrl = imageUrl
        self.createdAt = Date()
    }
    // Firestore'a gönderilecek dictionary
    
    func toDictionary() -> [String: Any] {
        return [
            "productId": productId,
            "name": name,
            "description": description,
            "oldPrice": oldPrice,
            "newPrice": newPrice,
            "endDate": endDate,
            "status": status,
            "deliveryType": deliveryType.rawValue,
            "restaurantId": restaurantId,
            "category": category,
            "imageUrl" : imageUrl,
            "createdAt": Timestamp(date: createdAt)
        ]
        
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
