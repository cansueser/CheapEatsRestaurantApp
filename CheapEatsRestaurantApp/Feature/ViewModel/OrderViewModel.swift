//
//  OrderViewModel.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 11.05.2025.
//

import Foundation
import UIKit

protocol OrderViewModelProtocol {
    var delegate: OrderViewModelOutputProtocol? { get set}
    var products: [Product] { get set }
    func getOrders()

}

protocol OrderViewModelOutputProtocol: AnyObject {
    func update()
    func error()
}

final class OrderViewModel {
    weak var delegate: OrderViewModelOutputProtocol?
    var products: [Product] = []
    func getOrders() {
        //siparişleri çek
     //   orderse istek at
      //  2- orderstaki restorant idsi == benim restorant id me olan ürünleri getir.
      //  3 bunları ordersin func un içine at
    }

}

extension OrderViewModel: OrderViewModelProtocol {}
