import Foundation
import Firebase

protocol OrderViewModelProtocol {
    var delegate: OrdersViewModelOutputProtocol? { get set }
    var orderDetailsList: [OrderDetail] { get set }
    func fetchData()
    func loadData()
    
    func getOrderStatu() -> Bool
    func updateOrderStatus(orderId: String, newStatus: OrderStatus, completion: @escaping (Bool) -> Void)
}

protocol OrdersViewModelOutputProtocol: AnyObject {
    func update()
    func error()
    func updateTable()
    func startLoading()
    func stopLoading()
}

final class OrderViewModel {
    weak var delegate: OrdersViewModelOutputProtocol?
    var orders: [Orders] = []
    var products: [Product]?
    var users: [Customer]?
    var orderDetailsList: [OrderDetail] = []
    private let dispatchGroup = DispatchGroup()
    
    func fetchData() {
        self.delegate?.startLoading()
        orders.removeAll()
        products?.removeAll()
        users?.removeAll()
        orderDetailsList.removeAll()
        dispatchGroup.enter()
        fetchOrders()
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            let productIds = self.orders.map { $0.productId }
            self.dispatchGroup.enter()
            self.fetchProducts(productIds: productIds)
            self.dispatchGroup.enter()
            self.fetchUsers()
            self.dispatchGroup.notify(queue: .main) { [weak self] in
                self?.delegate?.update()
                self?.delegate?.stopLoading()
            }
        }
    }
    
    private func fetchOrders() {
        NetworkManager.shared.fetchOrders { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let orders):
                self.orders = orders
            case .failure(let error):
                print(error)
                self.delegate?.error()
            }
            self.dispatchGroup.leave()
        }
    }
    
    private func fetchProducts(productIds: [String]) {
        if productIds.isEmpty{
            dispatchGroup.leave()
            return
        }
        NetworkManager.shared.fetchSelectedProduct(productIds: productIds) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let products):
                self.products = products
            case .failure(let error):
                print(error)
            }
            dispatchGroup.leave()
        }
    }
    
    private func fetchUsers() {
        NetworkManager.shared.fetchUsers { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let users):
                self.users = users
            case .failure(let error):
                print(error)
            }
            dispatchGroup.leave()
        }
    }
    
    private func combineOrderAndUserAndProduct() {
        orderDetailsList.removeAll()
        guard let products = products, let users = users else { return }
        
        for order in orders {
            guard let product = products.first(where: { $0.productId == order.productId }), let user = users.first(where: { $0.uid == order.userId })
            else {
                continue
            }
            
            let orderDetail = OrderDetail(userOrder: order, user: user, product: product)
            orderDetailsList.append(orderDetail)
        }
    }
    
    func loadData() {
        combineOrderAndUserAndProduct()
        delegate?.updateTable()
    }
   
    func getOrderStatu() -> Bool {
        return orderDetailsList.isEmpty
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

extension OrderViewModel: OrderViewModelProtocol {}
