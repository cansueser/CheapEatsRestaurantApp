import Foundation
import UIKit

protocol OrderViewModelOutputProtocol: AnyObject {
    func ordersDidUpdate()
}


final class OrderViewModel {
    //private yapınca tableviewden erişilmiyor düzelt
    var orders: [Order] = []
    weak var delegate: OrderViewModelOutputProtocol?
    
    
    func getOrders() -> [Order] {
        return orders
    }
    
    func removeOrder(at index: Int) {
        guard index >= 0 && index < orders.count else { return }
        orders.remove(at: index)
        delegate?.ordersDidUpdate()
    }
    //celli güncelleme
    func updateOrder(at index: Int, with order: Order) {
        orders[index] = order
        delegate?.ordersDidUpdate()
    }
    
    func addOrder(_ order: Order) {
        orders.append(order)
        delegate?.ordersDidUpdate()
    }
    
}
