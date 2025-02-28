import Foundation
import UIKit

protocol HomeViewModelProtocol {
    var delegate: OrderViewModelOutputProtocol? { get set}
    var orders: [Product]? { get set }
}

protocol OrderViewModelOutputProtocol: AnyObject {
    func update()
    func error()
}

final class HomeViewModel {
    var orders: [Product]?
    weak var delegate: OrderViewModelOutputProtocol?
    
}

extension HomeViewModel: HomeViewModelProtocol {}
