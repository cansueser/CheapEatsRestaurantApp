//
//  Restaurant.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 1.03.2025.
//

import Firebase
import FirebaseFirestore

struct Restaurant: Codable {
    var restaurantId : String
    var ownerName : String
    var ownerSurname : String
    var email : String
    var phone : String
    var address : String
    var companyName : String
    var location : Location
    var createdAt: Date
  
    var ownerFullName: String {
        return "\(ownerName) \(ownerSurname)"
    }
    
    init?(data: [String: Any]) {
        self.restaurantId = data["restaurantId"] as? String ?? ""
        self.companyName = data["companyName"] as? String ?? ""
        self.ownerName = data["ownerName"] as? String ?? ""
        self.ownerSurname = data["ownerSurname"] as? String ?? ""
        self.address = data["address"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.phone = data["phone"] as? String ?? ""
        
        if let geoPoint = data["location"] as? GeoPoint {
            self.location = Location(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
        } else {
            self.location = Location(latitude: 0.0, longitude: 0.0)
        }
        if let timestamp = data["createdAt"] as? Timestamp {
            self.createdAt = timestamp.dateValue()
        } else {
            self.createdAt = Date()
        }
    }
    
    init(ownerName: String, ownerSurname: String, email: String, phone: String, address: String, companyName: String, location: Location) {
        self.restaurantId = ""
        self.ownerName = ownerName
        self.ownerSurname = ownerSurname
        self.email = email
        self.phone = phone
        self.address = address
        self.companyName = companyName
        self.location = location
        self.createdAt = Date()
    }
    
    // Firestore'a gönderilecek dictionary
    func toDictionary() -> [String: Any] {
        return [
            "restaurantId": restaurantId,
            "ownerName": ownerName,
            "ownerSurname": ownerSurname,
            "email": email,
            "phone": phone,
            "address": address,
            "companyName": companyName,
            "location": location.toGeoPoint,
            "createdAt": Timestamp(date: createdAt)
         ]
    }
}

struct Location: Codable {
    var latitude: Double
    var longitude: Double
    var toGeoPoint: GeoPoint {
        return GeoPoint(latitude: latitude, longitude: longitude)
    }
}


enum EmailValidationError: Error {
    case empty
    case invalidFormat
    case domainNotAllowed
}
