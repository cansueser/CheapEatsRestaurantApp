//
//  UserDefaultManager.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 8.06.2025.
//

import Foundation

final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    private init() {}
    
    // MARK: - Keys
    struct Keys {
        static let isUserLoggedIn = "isUserLoggedIn"
        static let currentUser = "currentUser"
    }
    
    // MARK: - User Methods
    func saveUser(_ restaurant: Restaurant) {
        do {
            let encoder = JSONEncoder()
            let userData = try encoder.encode(restaurant)
            UserDefaults.standard.set(userData, forKey: Keys.currentUser)
            UserDefaults.standard.set(true, forKey: Keys.isUserLoggedIn)
        } catch {
            print("Error encoding user: \(error.localizedDescription)")
        }
    }
    
    func getUser() -> Restaurant? {
        guard let userData = UserDefaults.standard.data(forKey: Keys.currentUser) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let restaurant = try decoder.decode(Restaurant.self, from: userData)
            return restaurant
        } catch {
            print("Error decoding user: \(error.localizedDescription)")
            return nil
        }
    }
    
    func isUserLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: Keys.isUserLoggedIn)
    }
    
    func clearUserData() {
        UserDefaults.standard.removeObject(forKey: Keys.currentUser)
        UserDefaults.standard.removeObject(forKey: Keys.isUserLoggedIn)
    }
}
