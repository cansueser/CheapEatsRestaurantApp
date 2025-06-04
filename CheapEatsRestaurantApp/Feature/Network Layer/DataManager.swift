//
//  DataManager.swift
//  CheapEatsRestaurantApp
//
//  Created by EmreYlr on 02.06.2025.
//

import Foundation
import FirebaseFirestore

class DataManager {
    
    static let shared = DataManager()
    
    private init() {}
    
    // Veri kaynağı modu
    var isUsingMockData: Bool = true
    
    private let db = Firestore.firestore()
    private var mockOrders: [Orders] = []
    private var mockProducts: [Product] = []
    
    // MARK: - Orders Methods
    
    // Siparişleri getir
    func getOrders(completion: @escaping ([Orders], [Product], [String: Orders]) -> Void) {
        if isUsingMockData {
            // Sahte veriler kullan
            let products = createMockProducts()
            let orders = createMockOrders(from: products)
            var productOrderMap: [String: Orders] = [:]
            
            // Ürün-sipariş eşleştirme haritası oluştur
            for order in orders {
                productOrderMap[order.productId] = order
            }
            
            self.mockProducts = products
            self.mockOrders = orders
            
            completion(orders, products, productOrderMap)
        } else {
            // Firebase'den gerçek verileri getir
            let ordersRef = db.collection("orders")
            
            ordersRef.getDocuments { [weak self] snapshot, error in
                guard let self = self, let snapshot = snapshot, error == nil else {
                    completion([], [], [:])
                    return
                }
                
                var orders: [Orders] = []
                var productIds: [String] = []
                
                // Siparişleri oku
                for document in snapshot.documents {
                    let data = document.data()
                    if let order = Orders(dictionary: data, documentId: document.documentID) {
                        orders.append(order)
                        productIds.append(order.productId)
                    }
                }
                
                // İlgili ürünleri getir
                self.getProductsById(productIds: productIds) { products in
                    var productOrderMap: [String: Orders] = [:]
                    
                    // Ürün-sipariş eşleştirme haritası oluştur
                    for order in orders {
                        productOrderMap[order.productId] = order
                    }
                    
                    completion(orders, products, productOrderMap)
                }
            }
        }
    }
    
    // Ürünleri ID'lerine göre getir
    private func getProductsById(productIds: [String], completion: @escaping ([Product]) -> Void) {
        if isUsingMockData {
            let filteredProducts = mockProducts.filter { productIds.contains($0.productId) }
            completion(filteredProducts)
        } else {
            let productsRef = db.collection("products")
            
            // ID listesine göre ürünleri sorgula
            productsRef.whereField("productId", in: productIds).getDocuments { snapshot, error in
                guard let snapshot = snapshot, error == nil else {
                    completion([])
                    return
                }
                
                var products: [Product] = []
                
                for document in snapshot.documents {
                    // Firestore belgesinden Product oluştur
                    if let product = self.createProductFromFirestore(data: document.data()) {
                        products.append(product)
                    }
                }
                
                completion(products)
            }
        }
    }
    
    // Sipariş durumunu güncelle
    func updateOrderStatus(orderId: String, newStatus: OrderStatus, completion: @escaping (Bool) -> Void) {
        if isUsingMockData {
            // Sahte verilerde güncelleme
            if let index = mockOrders.firstIndex(where: { $0.orderId == orderId }) {
                mockOrders[index].status = newStatus
                completion(true)
            } else {
                completion(false)
            }
        } else {
            // Firebase'de güncelleme
            let orderRef = db.collection("orders").document(orderId)
            orderRef.updateData(["status": newStatus.rawValue]) { error in
                completion(error == nil)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    // Sahte ürünler oluştur
    private func createMockProducts() -> [Product] {
        return [
            Product(
                name: "Tavuk Döner",
                description: "Özel baharatlarla hazırlanmış lezzetli tavuk döner",
                oldPrice: 120,
                newPrice: 80,
                endDate: "18:00",
                deliveryType: .delivery,
                restaurantId: "restoran123",
                category: ["Döner", "Tavuk"],
                imageUrl: "https://images.immediate.co.uk/production/volatile/sites/30/2020/08/chorizo-mozarella-gnocchi-bake-cropped-9ab73a3.jpg?quality=90&resize=556,505",
                quantity: 5
            ),
            Product(
                name: "İskender Kebap",
                description: "Özel soslu ve tereyağlı iskender kebap",
                oldPrice: 180,
                newPrice: 150,
                endDate: "20:00",
                deliveryType: .takeout,
                restaurantId: "restoran123",
                category: ["Kebap"],
                imageUrl: "https://images.immediate.co.uk/production/volatile/sites/30/2020/08/chorizo-mozarella-gnocchi-bake-cropped-9ab73a3.jpg?quality=90&resize=556,505",
                quantity: 3
            ),
            Product(
                name: "Tavuklu Burger",
                description: "Özel soslu tavuk burger",
                oldPrice: 140,
                newPrice: 100,
                endDate: "22:00",
                deliveryType: .all,
                restaurantId: "restoran123",
                category: ["Burger", "Tavuk"],
                imageUrl: "https://images.immediate.co.uk/production/volatile/sites/30/2020/08/chorizo-mozarella-gnocchi-bake-cropped-9ab73a3.jpg?quality=90&resize=556,505",
                quantity: 8
            )
        ]
    }
    
    // Sahte siparişler oluştur
    private func createMockOrders(from products: [Product]) -> [Orders] {
        var mockOrders: [Orders] = []
        
        // Her ürün için farklı durumlarda siparişler oluştur
        for (index, product) in products.enumerated() {
            // Her ürün için 1 sipariş oluştur
            var order = Orders(productId: product.productId, userId: "user\(index + 1)", selectedDeliveryType: product.deliveryType)
            
            // Örnek sipariş detayları
            let orderStatuses: [OrderStatus] = [.preparing, .delivered, .canceled]
            order.orderId = "order_\(index + 1)"
            order.orderNo = "ORDER\(100000 + index)"
            order.status = orderStatuses[index % orderStatuses.count]
            
            // Tarih varyasyonları
            let hourOffset = Double(index * 3) // Her sipariş 3 saat arayla
            order.orderDate = Date().addingTimeInterval(-hourOffset * 3600)
            
            mockOrders.append(order)
        }
        
        return mockOrders
    }
    
    // Firebase verilerinden Product nesnesi oluştur
    private func createProductFromFirestore(data: [String: Any]) -> Product? {
        guard
            let name = data["name"] as? String,
            let description = data["description"] as? String,
            let oldPrice = data["oldPrice"] as? Int,
            let newPrice = data["newPrice"] as? Int,
            let endDate = data["endDate"] as? String,
            let deliveryTypeString = data["deliveryType"] as? String,
            let deliveryType = DeliveryType(rawValue: deliveryTypeString),
            let restaurantId = data["restaurantId"] as? String,
            let category = data["category"] as? [String],
            let imageUrl = data["imageUrl"] as? String,
            let quantity = data["quantity"] as? Int
        else {
            return nil
        }
        
        var product = Product(
            name: name,
            description: description,
            oldPrice: oldPrice,
            newPrice: newPrice,
            endDate: endDate,
            deliveryType: deliveryType,
            restaurantId: restaurantId,
            category: category,
            imageUrl: imageUrl,
            quantity: quantity
        )
        
        if let productId = data["productId"] as? String {
            product.productId = productId
        }
        
        if let status = data["status"] as? Bool {
            product.status = status
        }
        
        if let createdAtTimestamp = data["createdAt"] as? Timestamp {
            product.createdAt = createdAtTimestamp.dateValue()
        }
        
        return product
    }
    
    // Veri modunu değiştir
    func toggleDataMode() {
        isUsingMockData = !isUsingMockData
    }
}
