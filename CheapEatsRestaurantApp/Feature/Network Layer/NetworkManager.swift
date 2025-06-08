//
//  NetworkManager.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 26.02.2025.
//
import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore


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
            } else {
                completion(.success(()))
            }
        }
    }
    
    func updateProduct(product: Product, completion: @escaping (Result<Void, Error>) -> Void) {
        let productRef = db.collection("products").document(product.productId)
        productRef.setData(product.toDictionary(), merge: true) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // Restoran kaydı
    func registerRestaurant(restaurant: Restaurant, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        var restaurant = restaurant
        Auth.auth().createUser(withEmail: restaurant.email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let id = result?.user.uid {
                restaurant.restaurantId = id
                self.db.collection("restaurants").document(id).setData(restaurant.toDictionary()) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            }
        }
    }
    
    // Çıkış yapma fonksiyonu
    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    // Giriş
    func login(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func getRestaurantInfo(uid: String, completion: @escaping (Restaurant?) -> Void) {
        let restaurantRef = db.collection("restaurants").document(uid)
        restaurantRef.getDocument { document, _ in
            guard let document = document, document.exists, let data = document.data(), let restaurant = Restaurant(data: data) else {
                completion(nil)
                return
            }
            RestaurantManager.shared.restaurant = restaurant
            completion(restaurant)
        }
    }
    // MARK: - Orders
    func fetchOrders(completion: @escaping ([Orders]) -> Void) {
        let restaurantId = RestaurantManager.shared.getRestaurantId()
        
        db.collection("orders").whereField("restaurantId", isEqualTo: restaurantId).getDocuments { snapshot, error in
            if let error = error {
                print("Siparişleri çekerken hata oluştu: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion([])
                return
            }
            
            let orders = documents.compactMap { document in
                return Orders(dictionary: document.data(), documentId: document.documentID)
            }
            
            completion(orders)
        }
    }
    
    func updateOrderStatus(orderId: String, newStatus: OrderStatus, completion: @escaping (Bool) -> Void) {
        let orderRef = db.collection("orders").document(orderId)
        orderRef.updateData([
            "status": newStatus.rawValue
        ]) { error in
            if let error = error {
                print("Sipariş durumu güncellenirken hata oluştu: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            completion(true)
        }
    }
    
    // MARK: - Products
    func fetchRestaurantProducts(comletion: @escaping(Result<[Product], Error>) -> Void) {
        let restaurantId = RestaurantManager.shared.getRestaurantId()
        
        db.collection("products")
            .whereField("restaurantId", isEqualTo: restaurantId)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    comletion(.failure(error))
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    comletion(.success([]))
                    return
                }
                
                var products: [Product] = []
                
                for document in documents {
                    let data = document.data()
                    if let product = Product(dictionary: data) {
                        products.append(product)
                    }
                }
                
                comletion(.success(products))
            }
    }
    
    func fetchProduct(withId productId: String, completion: @escaping (Product?) -> Void) {
        db.collection("products").document(productId).getDocument { snapshot, error in
            if let error = error {
                print("Ürün çekerken hata: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let snapshot = snapshot, snapshot.exists, let data = snapshot.data() else {
                print("Ürün bulunamadı: \(productId)")
                completion(nil)
                return
            }

            var productData = data
            if productData["productId"] == nil {
                productData["productId"] = productId
            }
            
            if let product = Product(dictionary: productData) {
                completion(product)
            } else {
                print("Ürün verisi dönüştürülemedi: \(productId)")
                completion(nil)
            }
        }
    }
    

}
enum NetworkError: Error {
    case updateFailed
    case passwordChangeFailed
}
