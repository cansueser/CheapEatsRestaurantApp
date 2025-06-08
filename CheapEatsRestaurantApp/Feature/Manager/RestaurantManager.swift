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
}
