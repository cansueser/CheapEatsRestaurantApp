//
//  OrderViewModel.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 23.12.2024.
//

import Foundation
//YENİ
import UIKit

protocol OrderViewModelOutputProtocol: AnyObject {
    func ordersDidUpdate() // TableView'yi güncellemek için protokol
}

final class OrderViewModel {
    private var orders: [Order] = [] // Ürün listesi
    weak var delegate: OrderViewModelOutputProtocol?

    func addOrder(_ product: Order) {
        orders.append(product) // Yeni ürünü listeye ekle
        delegate?.ordersDidUpdate() // TableView'yi bilgilendir
    }

    func getOrders() -> [Order] {
        print("update")
        return orders
    }
}
