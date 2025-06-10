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

    init?(dictionary: [String: Any], documentId: String) {
        self.uid = documentId
        self.firstName = dictionary["firstName"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.phoneNumber = dictionary["phoneNumber"] as? String ?? ""
    }
}
