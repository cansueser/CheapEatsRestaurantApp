//
//  ProfileModel.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 5.06.2025.
//

import Foundation

struct ProfileModel: Codable {
    var restaurantName: String
    var ownerName: String
    var ownerSurname: String
    var email: String
    var phone: String
    
    init(restaurantName: String = "",
         ownerName: String = "",
         ownerSurname: String = "",
         email: String = "",
         phone: String = "") {
        self.restaurantName = restaurantName
        self.ownerName = ownerName
        self.ownerSurname = ownerSurname
        self.email = email
        self.phone = phone
    }
}
