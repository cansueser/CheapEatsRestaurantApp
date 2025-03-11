//
//  LocationModel.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 10.03.2025.
//
import Foundation

struct MapLocation {
    var latitude: Double
    var longitude: Double
    var city: String = ""
    var district: String = ""
    var neighbourhood: String = ""
    var street: String = ""
    var buildingNumber: String = ""
    var directions: String = ""
    var country: String = ""
    
    func getAddress() -> String {
        var address: String = ""
        
        if !buildingNumber.isEmpty {
            address += "\(buildingNumber), "
        }
        if !neighbourhood.isEmpty {
            address += "\(neighbourhood), "
        }
        if !street.isEmpty {
            address += "\(street), "
        }
        if !district.isEmpty {
            address += "\(district)/"
        }
        if !city.isEmpty {
            address += "\(city) "
        }
        if !directions.isEmpty {
            address += "(\(directions))"
        }
        return address
    }
}
