//
//  User.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 1.03.2025.
//
import Firebase

struct Restaurant {
    var restaurantId : String
    var ownerName : String
    var ownerSurname : String
    var email : String
    var phone : String
    var address : String
    var companyName : String
    var location : Location
    var createdAt: Date
    
    
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
struct Location {
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
