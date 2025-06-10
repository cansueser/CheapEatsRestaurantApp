//
//  Coupon.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 10.06.2025.
//

import Foundation
import Firebase

struct Coupon {
    var couponId: String
    let code: String
    let discountValue: Int
    let startDate: Date
    let endDate: Date
    let isActive: Bool
    let createdAt: Date
    
    init?(dictionary: [String: Any], documentId: String) {
        guard
            let code = dictionary["code"] as? String,
            let discountValue = dictionary["discountValue"] as? Int,
            let startTimestamp = dictionary["startDate"] as? Timestamp,
            let endTimestamp = dictionary["endDate"] as? Timestamp,
            let isActive = dictionary["isActive"] as? Bool,
            let createdTimestamp = dictionary["createdAt"] as? Timestamp
        else {
            return nil
        }
        
        self.couponId = documentId
        self.code = code
        self.discountValue = discountValue
        self.startDate = startTimestamp.dateValue()
        self.endDate = endTimestamp.dateValue()
        self.isActive = isActive
        self.createdAt = createdTimestamp.dateValue()
    }
}
