////
////  OrderService.swift
////  CheapEatsRestaurantApp
////
////  Created by CANSU on 24.05.2025.
////
//
//// OrderService.swift
//final class OrderService {
//    static let shared = OrderService()
//    
//    private init() {}
//    
//    // Siparişleri tutacak dizi
//    private var orders: [Orders] = []
//    
//    // Siparişe konu olan ürünleri ID'lerine göre eşleyecek sözlük
//    // Bu şekilde her sipariş için ilgili ürün bilgilerine erişebiliriz
//    private var productCache: [String: Product] = [:]
//    
//    // Ürün bilgilerini cache'e ekler
//    func cacheProduct(_ product: Product) {
//        productCache[product.productId] = product
//    }
//    
//    // Bir ürünü sipariş olarak ekle
//    func createOrder(for product: Product, userId: String) -> Orders {
//        // Ürünü cache'e ekle
//        cacheProduct(product)
//        
//        // Sipariş numarası oluştur
//        let orderNo = "ORD\(Int.random(in: 100000..<1000000))"
//        
//        // Yeni bir order nesnesi oluştur
//        var newOrder = Orders(productId: product.productId, userId: userId, selectedDeliveryType: product.deliveryType)
//        
//        // Order özelliklerini ayarla
//        newOrder.orderNo = orderNo
//       // newOrder.orderId = UUID().uuidString
//        
//        // Siparişi diziye ekle
//        orders.append(newOrder)
//        
//        return newOrder
//    }
//    
//    // Tüm siparişleri getir
//    func getAllOrders() -> [Orders] {
//        return orders
//    }
//    
//    // Belirli bir kullanıcının siparişlerini getir
//    func getOrders(for userId: String) -> [Orders] {
//        return orders.filter { $0.userId == userId }
//    }
//    
//    // Belirli bir siparişe ait ürün bilgilerini getir
//    func getProduct(for order: Orders) -> Product? {
//        return productCache[order.productId]
//    }
//    
//    // Mock veri oluştur
//    func createMockOrders(count: Int = 3) {
//        // Mock ürünler oluştur
//        let mockProducts = [
//            Product(
//                name: "Tavuk Döner",
//                description: "Lezzetli tavuk döner",
//                oldPrice: 180,
//                newPrice: 150,
//                endDate: "25.05.2025",
//                deliveryType: .delivery,
//                restaurantId: "rest123",
//                category: [Category.doner.rawValue],
//                imageUrl: "https://via.placeholder.com/150",
//                quantity: 2
//            ),
//            Product(
//                name: "İskender",
//                description: "Enfes iskender",
//                oldPrice: 250,
//                newPrice: 200,
//                endDate: "26.05.2025",
//                deliveryType: .takeout,
//                restaurantId: "rest123",
//                category: [Category.kebap.rawValue],
//                imageUrl: "https://via.placeholder.com/150",
//                quantity: 1
//            ),
//            Product(
//                name: "Pizza",
//                description: "Karışık pizza",
//                oldPrice: 220,
//                newPrice: 180,
//                endDate: "27.05.2025",
//                deliveryType: .takeout,
//                restaurantId: "rest123",
//                category: [Category.pizza.rawValue],
//                imageUrl: "https://via.placeholder.com/150",
//                quantity: 3
//            )
//        ]
//        
//        // Her ürün için bir sipariş oluştur
//        for product in mockProducts {
//            cacheProduct(product)
//            
//            let orderNo = "ORD\(Int.random(in: 100000..<1000000))"
//            var order = Orders(productId: product.productId, userId: "user123", selectedDeliveryType: product.deliveryType)
//            order.orderNo = orderNo
//           // order.orderId = UUID().uuidString
//            
//            // Rastgele bir sipariş durumu ata
//            let statuses: [OrderStatus] = [.preparing, .delivered, .canceled]
//            order.status = statuses.randomElement() ?? .preparing
//            
//            orders.append(order)
//        }
//    }
//}
