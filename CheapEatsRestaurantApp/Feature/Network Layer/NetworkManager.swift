//
//  NetworkManager.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 26.02.2025.
//
import Firebase
import FirebaseAuth
import FirebaseFirestore


final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    let db = Firestore.firestore()
    
    // Ürün ekleme (doküman id'sini productId olarak kaydediyor)
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
    
    // Restoran kaydı
    func registerRestaurant(restaurant: Restaurant, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        var restaurant = restaurant
        Auth.auth().createUser(withEmail: restaurant.email, password: password) { result, error in
            if let id = result?.user.uid {
                restaurant.restaurantId = id
                self.saveRestaurant(restaurant: restaurant)
                completion(.success(()))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    private func saveRestaurant(restaurant: Restaurant) {
        db.collection("restaurants").document(restaurant.restaurantId).setData(restaurant.toDictionary()) { error in
            if let error = error {
                print("Error: \(error)")
            } else {
                print("Success")
            }
        }
    }
    
    // Giriş
    func login(user: UserLogin, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: user.email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    // MARK: - Orders
    
    func fetchOrders(completion: @escaping ([Orders]) -> Void) {
        //TODO: -resturantID gelecek(Singleton)
        db.collection("orders").whereField("restaurantId", isEqualTo: "WXJ5I0rRDYfWaJSfwF3d").getDocuments { snapshot, error in
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
            
            print("Çekilen siparişler: \(orders.count)")
            for order in orders {
                print("Sipariş ID: \(order.orderId), Ürün ID: \(order.productId)")
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
    
    // Tek bir ürünü çek - belge ID'si ile
    func fetchProduct(withId productId: String, completion: @escaping (Product?) -> Void) {
        // ÖNEMLİ DEĞİŞİKLİK: productId'yi belge ID'si olarak kullan
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
            
            // Belge verisine belge ID'sini ekle, çünkü Product init'i bunu bekliyor olabilir
            var productData = data
            // Eğer productId alanı eksikse, belge ID'sini kullan
            if productData["productId"] == nil {
                productData["productId"] = productId
            }
            
            if let product = Product(dictionary: productData) {
                print("Ürün bulundu: \(product.name)")
                completion(product)
            } else {
                print("Ürün verisi dönüştürülemedi: \(productId)")
                completion(nil)
            }
        }
    }
    
    // Birden fazla ürünü ID listesiyle çek - belge ID'leri ile
    func fetchProductsByIds(_ productIds: [String], completion: @escaping ([Product]) -> Void) {
        guard !productIds.isEmpty else {
            print("Ürün ID listesi boş")
            completion([])
            return
        }
        
        print("Çekilecek ürün ID'leri: \(productIds)")
        
        var allProducts: [Product] = []
        let dispatchGroup = DispatchGroup()
        
        // Her bir belge ID'sini ayrı ayrı çekelim
        for productId in productIds {
            dispatchGroup.enter()
            
            fetchProduct(withId: productId) { product in
                if let product = product {
                    allProducts.append(product)
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            print("Bulunan ürün sayısı: \(allProducts.count)")
            completion(allProducts)
        }
    }
}
