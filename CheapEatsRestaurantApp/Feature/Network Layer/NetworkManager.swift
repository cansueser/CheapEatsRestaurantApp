//
//  NetworkManager.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 26.02.2025.
//

import Firebase
import FirebaseAuth

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    let db = Firestore.firestore()
    
    func addProduct(product: Product, completion: @escaping (Result<Void, Error>) -> Void) {
        let productRef = db.collection("products").document()
        var productData = product
        productData.productId = productRef.documentID
        
        productRef.setData(productData.toDictionary()) { error in
            if let error = error {
                completion(.failure(error))
            }else{
                completion(.success(()))
            }
        }
    }
    
    func registerRestaurant(restaurant: Restaurant, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        var restaurant = restaurant
        Auth.auth().createUser(withEmail: restaurant.email, password: password) { result, error in
            if let id = result?.user.uid {
                restaurant.restaurantId = id
                self.saveRestaurant(restaurant: restaurant)
                completion(.success(()))
            }else if let error = error{
                completion(.failure(error))
            }
        }
    }
    
    private func saveRestaurant(restaurant: Restaurant) {
        db.collection("restaurants").document(restaurant.restaurantId).setData(restaurant.toDictionary()) { error in
            if let error = error {
                print("Error: \(error)")
            }else {
                print("Success")
            }
        }
    }
    
    func login(user : UserLogin, password: String ,completion: @escaping (Result<Void, Error>) -> Void) {
        var user = user
        Auth.auth().signIn(withEmail: user.email , password: password){ authResult, error in
            if let error = error{
                completion(.failure(error))
                print("giriş hatalı")

            }else{
                completion(.success(()))
                print("giriş başarılı")
            }
        }
    }
}

