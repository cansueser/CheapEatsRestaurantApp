import Foundation
import UIKit
import Firebase

protocol HomeViewModelProtocol {
    var delegate: HomeViewModelOutputProtocol? { get set}
    var products: [Product] { get set }
    var orders: [Orders] { get set }
    func orderProduct(for order: Orders) -> Product?
    func addProduct(_ product: Product)
    func getProductStatu() -> Bool
    func getOrderStatu() -> Bool
    func fetchRestaurantProducts()
    func startListeningOrders()
    func fetchRestaurantOrders()
    func updateOrderStatus(index: Int, newStatus: OrderStatus)
}

protocol HomeViewModelOutputProtocol: AnyObject {
    func update()
    func error()
    func updateOrder()
    func startLoading()
    func stopLoading()
}

final class HomeViewModel {
    weak var delegate: HomeViewModelOutputProtocol?
    var products: [Product] = []
    var orders: [Orders] = []
    var productsById: [String: Product] = [:]
    var orderListener: ListenerRegistration?
    private var loadingCounter = 0
    
    func startListeningOrders() {
        orderListener = NetworkManager.shared.listenOrder { [weak self] newOrder in
            guard let self = self else { return }
            self.orders.insert(newOrder, at: 0)
            
            self.decreaseProductQuantity(for: newOrder.productId, by: newOrder.quantity)
            
            NetworkManager.shared.fetchProduct(withId: newOrder.productId) { product in
                if let product = product {
                    self.productsById[newOrder.productId] = product
                } else {
                    print("Ürün bulunamadı: \(newOrder.productId)")
                }
                
                DispatchQueue.main.async {
                    self.delegate?.updateOrder()
                }
            }
        }
    }
    
    func addProduct(_ product: Product) {
        if products.contains(where: { $0.productId == product.productId }) {
            products.remove(at: products.firstIndex(where: { $0.productId == product.productId })!)
        }
        products.append(product)
        delegate?.update()
    }
    
    func getProductStatu() -> Bool {
        return products.isEmpty
    }
    
    func getOrderStatu() -> Bool {
        return orders.isEmpty
    }
    
    func decreaseProductQuantity(for productId: String, by quantity: Int) {
        if let index = products.firstIndex(where: { $0.productId == productId }) {
            var product = products[index]
            product.quantity = max(0, product.quantity - quantity)
            if product.quantity == 0 {
                products.remove(at: index)
            } else {
                products[index] = product
            }
            delegate?.update()
        }
    }
    
    func fetchRestaurantProducts() {
        delegate?.startLoading()
        loadingCounter += 1
        products.removeAll()
        NetworkManager.shared.fetchRestaurantProducts { result in
            switch result {
            case .success(let product):
                print(product)
                self.products = product
                self.delegate?.update()
            case .failure(_):
                self.delegate?.error()
            }
            self.loadingCounter -= 1
            self.checkLoading()
        }
    }
    
    func fetchRestaurantOrders() {
        orders.removeAll()
        productsById.removeAll()
        delegate?.startLoading()
        loadingCounter += 1
        NetworkManager.shared.fetchRestaurntOrders { [weak self] orders in
            guard let self = self else { return }
            self.orders = orders
            
            if orders.isEmpty {
                DispatchQueue.main.async {
                    self.delegate?.error()
                    self.loadingCounter -= 1
                    self.checkLoading()
                }
                return
            }
            
            let productIds = orders.map { $0.productId }
            self.productsById = [:]
            
            let dispatchGroup = DispatchGroup()
            
            for productId in productIds {
                dispatchGroup.enter()
                NetworkManager.shared.fetchProduct(withId: productId) { product in
                    if let product = product {
                        self.productsById[productId] = product
                    } else {
                        print("Ürün bulunamadı: \(productId)")
                    }
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                self.delegate?.updateOrder()
                self.loadingCounter -= 1
                self.checkLoading()
            }
        }
    }
    
    func orderProduct(for order: Orders) -> Product? {
        return productsById[order.productId]
    }
    
    private func checkLoading() {
        if loadingCounter == 0 {
            delegate?.stopLoading()
        }
    }
    
    func updateOrderStatus(index: Int, newStatus: OrderStatus) {
        let orderId = orders[index].orderId
        
        NetworkManager.shared.updateOrderStatus(orderId: orderId, newStatus: newStatus) { result in
            if result {
                if newStatus == .canceled || newStatus == .delivered {
                    self.orders.removeAll { $0.orderId == orderId }
                } else {
                    self.orders[index].status = newStatus
                }
                self.delegate?.updateOrder()
            } else {
                self.delegate?.error()
            }
        }
    }
}


extension HomeViewModel: HomeViewModelProtocol {}
