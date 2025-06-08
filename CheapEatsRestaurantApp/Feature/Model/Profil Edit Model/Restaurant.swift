//
//  Restaurant.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 7.06.2025.
//

import Foundation


struct Restaurant {
    var restaurantId: String
    var companyName: String
    var ownerName: String
    var ownerSurname: String
    var email: String
    var phone: String
    var address: String
    var location: [Double]?  // [latitude, longitude]
    var createdAt: Date
    
    var ownerFullName: String {
        return "\(ownerName) \(ownerSurname)"
    }
}
