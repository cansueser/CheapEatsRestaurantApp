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
    
    func updateRestaurantInfo(restaurant: Restaurant, completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        let restaurantRef = db.collection("restaurants").document(restaurant.restaurantId)
        let data = restaurant.toDictionary()
        
        restaurantRef.updateData(data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                RestaurantManager.shared.restaurant = restaurant
                completion(.success(()))
            }
        }
    }
    
    func updateAddress(restaurantId: String, address: String, location: Location, completion: @escaping (Result<Void, Error>) -> Void) {
        let restaurantRef = db.collection("restaurants").document(restaurantId)
        let updateData: [String: Any] = [
            "address": address,
            "location": location.toGeoPoint
        ]
        
        restaurantRef.updateData(updateData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                if RestaurantManager.shared.restaurant != nil {
                    RestaurantManager.shared.updateRestaurantAddress(address: address, location: location)
                } else {
                }
                completion(.success(()))
            }
        }
    }
    
    func updatePassword(currentPassword: String, newPassword: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser,
              let email = currentUser.email else {
            return
        }
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        currentUser.reauthenticate(with: credential) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            currentUser.updatePassword(to: newPassword) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(()))
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
    func fetchOrders(completion: @escaping (Result<[Orders], Error>) -> Void) {
        let restaurantId = RestaurantManager.shared.getRestaurantId()
        
        db.collection("orders").whereField("restaurantId", isEqualTo: restaurantId).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(.success([]))
                return
            }
            
            let orders = documents.compactMap { (document) -> Orders? in
                let data = document.data()
                return Orders(dictionary: data, documentId: document.documentID)
            }
            
            completion(.success(orders))
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
    
    func fetchRestaurntOrders(completion: @escaping ([Orders]) -> Void) {
        let restaurantId = RestaurantManager.shared.getRestaurantId()
        
        db.collection("orders")
            .whereField("restaurantId", isEqualTo: restaurantId)
            .whereField("status", notIn: ["Teslim Edildi", "İptal Edildi"])
            .getDocuments { snapshot, error in
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
    
    func listenOrder(onNewOrder: @escaping (Orders) -> Void) -> ListenerRegistration? {
        let restaurantId = RestaurantManager.shared.getRestaurantId()
        var isInitialLoad = true
        
        let listener = db.collection("orders")
            .whereField("restaurantId", isEqualTo: restaurantId)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Siparişleri dinlerken hata oluştu: \(error.localizedDescription)")
                    return
                }
                
                guard let snapshot = snapshot else { return }
                
                if isInitialLoad {
                    isInitialLoad = false
                    return
                }
                
                for diff in snapshot.documentChanges {
                    if diff.type == .added {
                        if let newOrder = Orders(dictionary: diff.document.data(), documentId: diff.document.documentID) {
                            onNewOrder(newOrder)
                        }
                    }
                }
            }
        return listener
    }
    
    // MARK: - Products
    func fetchRestaurantProducts(comletion: @escaping(Result<[Product], Error>) -> Void) {
        let restaurantId = RestaurantManager.shared.getRestaurantId()
        
        db.collection("products")
            .whereField("restaurantId", isEqualTo: restaurantId)
            .whereField("quantity", isGreaterThan: 0)
            .whereField("status", isEqualTo: false)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Firestore Error:", error)
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
    
    func fetchSelectedProduct(productIds: [String], completion: @escaping (Result<[Product], Error>) -> Void) {
        db.collection("products")
            .whereField(FieldPath.documentID(), in: productIds)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error getting documents: \(error)")
                    completion(.failure(error))
                } else {
                    var products: [Product] = []
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        let productId = document.documentID
                        if let product = Product(dictionary: data, documentId: productId) {
                            products.append(product)
                        }
                    }
                    completion(.success(products))
                }
            }
    }
    
    func deleteProduct(productId: String, completion: @escaping (Bool) -> Void) {
        let productRef = db.collection("products").document(productId)
        productRef.updateData([
            "status": true
        ]) { error in
            if let error = error {
                print("Ürün durumu güncellenirken hata oluştu: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    //MARK: -Customer
    func fetchUsers(completion: @escaping (Result<[Customer], Error>) -> Void) {
        db.collection("users").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                completion(.success([]))
                return
            }
            
            let users = documents.compactMap { document -> Customer? in
                Customer(dictionary: document.data(), documentId: document.documentID)
            }
            completion(.success(users))
        }
    }
    
    //MARK: -Coupon
    func fetchCouponById(id: String, completion: @escaping (Result<Coupon, Error>) -> Void) {
        db.collection("coupon").document(id).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists, let data = document.data() else {
                let notFoundError = NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Kupon bulunamadı."])
                completion(.failure(notFoundError))
                return
            }
            
            if let coupon = Coupon(dictionary: data, documentId: document.documentID) {
                completion(.success(coupon))
            } else {
                let parseError = NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Kupon verisi parse edilemedi."])
                completion(.failure(parseError))
            }
        }
    }
    
}
enum NetworkError: Error {
    case updateFailed
    case passwordChangeFailed
}
