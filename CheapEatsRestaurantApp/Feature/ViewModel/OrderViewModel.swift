import Foundation
import UIKit
import Firebase
import FirebaseFirestore

protocol OrderViewModelOutputProtocol: AnyObject {
    func ordersDidUpdate()
}


final class OrderViewModel {
    //private yapınca tableviewden erişilmiyor düzelt
    private var orders: [Order] = []
    weak var delegate: OrderViewModelOutputProtocol?
    private let db = Firestore.firestore()
    
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
    
    
    func saveOrder(_ order: Order, completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        let documentRef: DocumentReference
        
        if let id = order.id { // Güncelleme
            documentRef = db.collection("orders").document(id)
        } else { // Yeni kayıt
            documentRef = db.collection("orders").document()
        }
        
        documentRef.setData(order.toDictionary()) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                var updatedOrder = order
                updatedOrder.id = documentRef.documentID
                self.syncLocalData(with: updatedOrder)
                completion(.success(()))
            }
        }
    }
    private func syncLocalData(with order: Order) {
        if let index = orders.firstIndex(where: { $0.id == order.id }) {
            orders[index] = order
        } else {
            orders.append(order)
        }
        delegate?.ordersDidUpdate()
    }
    //Silme
    func deleteOrder(orderID: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("orders").document(orderID).delete { error in
            if let error = error {
                print("Silme hatası: \(error.localizedDescription)")
                completion(false)
            } else {
                // Yerel veriden de kaldır
                if let index = self.orders.firstIndex(where: { $0.id == orderID }) {
                    self.orders.remove(at: index)
                }
                completion(true)
            }
        }
    }
}
