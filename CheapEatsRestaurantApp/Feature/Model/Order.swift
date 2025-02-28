//
//  Order.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 28.02.2025.
//
import UIKit

struct Order {
    
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
