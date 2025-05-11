//
//  OrderViewController.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 11.05.2025.
//

import UIKit

final class OrderViewController: UIViewController {
    //MARK: - Variables
    var orderViewModel: OrderViewModelProtocol = OrderViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
extension OrderViewController: OrderViewModelOutputProtocol{
    func update() {
        print("update")
    }
    
    func error() {
        print("error")

    }
    
    
}
