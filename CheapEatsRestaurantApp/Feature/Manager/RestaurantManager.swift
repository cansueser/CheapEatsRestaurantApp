//
//  RestaurantManager.swift
//  CheapEatsRestaurantApp
//
//  Created by EmreYlr on 7.06.2025.
//

import Foundation

final class RestaurantManager {
    static let shared = RestaurantManager()
    private init() {}
    var restaurant: Restaurant?
    
    func signOut() {
        restaurant = nil
    }
    
    func getRestaurantId() -> String {
        return restaurant?.restaurantId ?? ""
    }
    
    func getRestaurantName() -> String {
        return restaurant?.companyName ?? ""
    }
    
    func updateRestaurantAddress(address: String, location: Location) {
        guard restaurant != nil else { 
            print("RestaurantManager'da restaurant nil!")
            return 
        }
        
        print("Güncelleme öncesi address: \(restaurant?.address ?? "nil")")
        
        restaurant?.address = address
        restaurant?.location = location
        
        print("Güncelleme sonrası address: \(restaurant?.address ?? "nil")")
        print("RestaurantManager güncellendi - Address: \(address)")
        print("RestaurantManager güncellendi - Location: lat=\(location.latitude), lon=\(location.longitude)")
        
        // Doğrulama
        if let updatedRestaurant = restaurant {
            print("Doğrulama: RestaurantManager'daki güncel address: \(updatedRestaurant.address)")
        }
    }
}
