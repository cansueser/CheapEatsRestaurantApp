//
//  OrderViewController.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 11.05.2025.
//

import UIKit

final class OrderViewController: UIViewController {
    //MARK: - Variables
    
    @IBOutlet weak var orderTableView: UITableView!
    //EKLE
    //    @IBOutlet weak var emptyOrdersView: UIView!
    //    @IBOutlet weak var emptyOrdersLabel: UILabel!
    var orderViewModel: OrderViewModelProtocol = OrderViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        title = "Siparişler"
        orderViewModel.delegate = self
    }
    
    private func configureTableView() {
        orderTableView.delegate = self
        orderTableView.dataSource = self
        orderTableView.separatorStyle = .none
        orderTableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "orderCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        orderViewModel.getOrders()
    }
}

extension OrderViewController: OrderViewModelOutputProtocol {
    func update() {
        orderTableView.reloadData()
    }
    func error() {
        // Hata göster
    }
}
