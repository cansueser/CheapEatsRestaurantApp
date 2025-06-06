import Foundation
import Firebase

protocol OrderViewModelProtocol {
    var orders: [Orders] { get }
    var productsById: [String: Product] { get }
    var delegate: OrderViewModelOutputProtocol? { get set }
    func getOrders()
    func product(for order: Orders) -> Product?
    func updateOrderStatus(orderId: String, newStatus: OrderStatus, completion: @escaping (Bool) -> Void)
}

class OrderViewModel: OrderViewModelProtocol {
    var orders: [Orders] = []
    var productsById: [String: Product] = [:]
    weak var delegate: OrderViewModelOutputProtocol?
    
    func getOrders() {
        // Siparişleri ve ürünleri çek
        print("Siparişler yükleniyor...")
        
        NetworkManager.shared.fetchOrders { [weak self] orders in
            guard let self = self else { return }
            self.orders = orders
            
            if orders.isEmpty {
                print("Hiç sipariş bulunamadı!")
                DispatchQueue.main.async {
                    self.delegate?.update()
                }
                return
            }
            
            // Ürün ID'lerini topla
            let productIds = Array(Set(orders.map { $0.productId }))
            print("Siparişlerdeki benzersiz ürün ID'leri: \(productIds)")
            
            // Ürünleri çek - belge ID'si ile
            self.productsById = [:] // Temizle
            
            // Her bir ürünü ayrı ayrı çek
            let dispatchGroup = DispatchGroup()
            
            for productId in productIds {
                dispatchGroup.enter()
                
                NetworkManager.shared.fetchProduct(withId: productId) { product in
                    if let product = product {
                        self.productsById[productId] = product
                        print("Ürün bulundu ve eklendi: \(product.name)")
                    } else {
                        print("Ürün bulunamadı: \(productId)")
                    }
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                print("Tüm ürünler çekildi, toplam \(self.productsById.count) ürün")
                
                for order in self.orders {
                    let productFound = self.productsById[order.productId] != nil
                    print("Sipariş #\(order.orderNo) - Ürün bulundu: \(productFound)")
                }
                
                self.delegate?.update()
            }
        }
    }
    
    private func fetchOrdersAndProducts() {
        NetworkManager.shared.fetchOrders { [weak self] orders in
            guard let self = self else { return }
            self.orders = orders
            
            if orders.isEmpty {
                print("Hiç sipariş bulunamadı!")
                DispatchQueue.main.async {
                    self.delegate?.update()
                }
                return
            }
            
            let productIds = Array(Set(orders.map { $0.productId }))
            print("Siparişlerdeki benzersiz ürün ID'leri: \(productIds)")
            
            // Ürünleri çek
            NetworkManager.shared.fetchProductsByIds(productIds) { products in
                print("Bulunan ürün sayısı: \(products.count)")
                
                // Ürünleri ID'ye göre sözlüğe yerleştir
                self.productsById = Dictionary(uniqueKeysWithValues: products.map { ($0.productId, $0) })
                
                // Hangi siparişlerin ürünleri bulundu, debug bilgisi
                for order in self.orders {
                    let productFound = self.productsById[order.productId] != nil
                    print("Sipariş #\(order.orderNo) - Ürün ID: \(order.productId) - Ürün bulundu: \(productFound)")
                }
                
                // UI'ı güncelle
                DispatchQueue.main.async {
                    self.delegate?.update()
                }
            }
        }
    }
    
    func product(for order: Orders) -> Product? {
        return productsById[order.productId]
    }
    
    func updateOrderStatus(orderId: String, newStatus: OrderStatus, completion: @escaping (Bool) -> Void) {
        NetworkManager.shared.updateOrderStatus(orderId: orderId, newStatus: newStatus) { success in
            if success {
                if let index = self.orders.firstIndex(where: { $0.orderId == orderId }) {
                    self.orders[index].status = newStatus
                }
            }
            completion(success)
        }
    }
}
protocol OrderViewModelOutputProtocol: AnyObject {
    func update()
    func error()
}
