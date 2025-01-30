import Foundation
import UIKit

protocol OrderViewModelOutputProtocol: AnyObject {
    func ordersDidUpdate()
}

final class OrderViewModel {
    //private yapınca tableviewden erişilmiyor düzelt
     var orders: [Order] = []
    weak var delegate: OrderViewModelOutputProtocol?

    func addOrder(_ order: Order) {
        orders.append(order)
        delegate?.ordersDidUpdate()
    }

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
        guard index >= 0 && index < orders.count else { return }
        orders[index] = order
        delegate?.ordersDidUpdate()
    }

}
