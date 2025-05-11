//
//  Customer.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 11.05.2025.
//


import Foundation
import FirebaseFirestore

struct Customer: Codable {
    var uid: String
    let firstName: String
    let lastName: String
    let email: String
    let phoneNumber: String

}
