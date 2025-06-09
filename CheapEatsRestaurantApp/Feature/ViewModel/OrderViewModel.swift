import Foundation
import Firebase

protocol OrderViewModelProtocol {
    var orders: [Orders] { get }
    var delegate: OrderViewModelOutputProtocol? { get set }
    func getOrders()
    func product(for order: Orders) -> Product?
    func updateOrderStatus(orderId: String, newStatus: OrderStatus, completion: @escaping (Bool) -> Void)
}

protocol OrderViewModelOutputProtocol: AnyObject {
    func update()
    func error()
    func startLoading()
    func stopLoading()
}

class OrderViewModel: OrderViewModelProtocol {
    var orders: [Orders] = []
    var productsById: [String: Product] = [:]
    weak var delegate: OrderViewModelOutputProtocol?
    
    func getOrders() {
        delegate?.startLoading()
        NetworkManager.shared.fetchOrders { [weak self] orders in
            guard let self = self else { return }
            self.orders = orders
            
            if orders.isEmpty {
                DispatchQueue.main.async {
                    self.delegate?.error()
                    self.delegate?.stopLoading()
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
                self.delegate?.update()
                self.delegate?.stopLoading()
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

