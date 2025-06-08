//
//  UserModel.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 7.06.2025.
//

import Foundation

struct UserModel {
    var firstName: String
    var lastName: String
    var email: String
    var phoneNumber: String
    var restaurantName: String
    var password: String
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
}
