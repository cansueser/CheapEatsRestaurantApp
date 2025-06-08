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

//    
//    var restaurant: Restaurant?
//    private let db = Firestore.firestore()
//    
//    private init() {}
//    
//    func fetchRestaurantData(completion: @escaping (Result<Restaurant, Error>) -> Void) {
//        guard let currentUser = Auth.auth().currentUser else {
//            completion(.failure(NSError(domain: "RestaurantManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı oturum açmamış"])))
//            return
//        }
//        
//        // Kullanıcının email'i ile restoranı bulma
//        let userEmail = currentUser.email ?? ""
//        
//        db.collection("restaurants").whereField("email", isEqualTo: userEmail).getDocuments { [weak self] (snapshot, error) in
//            if let error = error {
//                print("Firestore error: \(error.localizedDescription)")
//                completion(.failure(error))
//                return
//            }
//            
//            guard let documents = snapshot?.documents, !documents.isEmpty else {
//                completion(.failure(NSError(domain: "RestaurantManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Restoran bulunamadı"])))
//                return
//            }
//            
//            // İlk eşleşen restoranı al
//            let restaurantData = documents[0].data()
//            
//            // Firestore'dan gelen veriyi Restaurant nesnesine dönüştür
//            guard let ownerName = restaurantData["ownerName"] as? String,
//                  let ownerSurname = restaurantData["ownerSurname"] as? String,
//                  let email = restaurantData["email"] as? String,
//                  let phone = restaurantData["phone"] as? String,
//                  let address = restaurantData["address"] as? String,
//                  let companyName = restaurantData["companyName"] as? String,
//                  let locationData = restaurantData["location"] as? [String: Any],
//                  let latitude = locationData["latitude"] as? Double,
//                  let longitude = locationData["longitude"] as? Double else {
//                completion(.failure(NSError(domain: "RestaurantManager", code: 400, userInfo: [NSLocalizedDescriptionKey: "Restoran verisi eksik veya hatalı"])))
//                return
//            }
//            
//            let location = Location(latitude: latitude, longitude: longitude)
//            
//            var restaurant = Restaurant(
//                ownerName: ownerName,
//                ownerSurname: ownerSurname,
//                email: email,
//                phone: phone,
//                address: address,
//                companyName: companyName,
//                location: location
//            )
//            
//            // Firestore belge ID'sini kaydet
//            restaurant.restaurantId = documents[0].documentID
//            
//            // Cache için kaydet
//            self?.restaurant = restaurant
//            
//            completion(.success(restaurant))
//        }
//    }
//    
//    func updateRestaurantInfo(restaurant: Restaurant, completion: @escaping (Result<Void, Error>) -> Void) {
//        // Boş ID kontrolü
//        if restaurant.restaurantId.isEmpty {
//            completion(.failure(NSError(domain: "RestaurantManager", code: 400, userInfo: [NSLocalizedDescriptionKey: "Restoran ID bulunamadı"])))
//            return
//        }
//        
//        let restaurantId = restaurant.restaurantId
//        
//        // Restaurant nesnesini Firestore belgesine dönüştür
//        let restaurantData: [String: Any] = [
//            "ownerName": restaurant.ownerName,
//            "ownerSurname": restaurant.ownerSurname,
//            "email": restaurant.email,
//            "phone": restaurant.phone,
//            "address": restaurant.address,
//            "companyName": restaurant.companyName,
//            "location": [
//                "latitude": restaurant.location.latitude,
//                "longitude": restaurant.location.longitude
//            ]
//        ]
//        
//        // Firestore belgesini güncelle
//        db.collection("restaurants").document(restaurantId).updateData(restaurantData) { [weak self] error in
//            if let error = error {
//                print("Firestore update error: \(error.localizedDescription)")
//                completion(.failure(error))
//                return
//            }
//            
//            // Başarılı güncelleme, cache'i güncelle
//            self?.restaurant = restaurant
//            completion(.success(()))
//        }
//    }
//  
}
enum NetworkError: Error {
    case updateFailed
    case passwordChangeFailed
}
