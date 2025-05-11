import Foundation
import UIKit

protocol HomeViewModelProtocol {
    var delegate: HomeViewModelOutputProtocol? { get set}
    var products: [Product] { get set }
    func addProduct(_ product: Product)
}

protocol HomeViewModelOutputProtocol: AnyObject {
    func update()
    func error()
}

final class HomeViewModel {
    weak var delegate: HomeViewModelOutputProtocol?
    var products: [Product] = []

    func addProduct(_ product: Product) {
        if products.contains(where: { $0.productId == product.productId }) {
            products.remove(at: products.firstIndex(where: { $0.productId == product.productId })!)
        }
        products.append(product)
        delegate?.update()
    }
    
}

extension HomeViewModel: HomeViewModelProtocol {}
