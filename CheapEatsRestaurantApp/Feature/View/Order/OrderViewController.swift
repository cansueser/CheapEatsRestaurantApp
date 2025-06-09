//
//  OrderViewController.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 11.05.2025.
//

import UIKit
import NVActivityIndicatorView

final class OrderViewController: UIViewController {
    //MARK: - Variables
    @IBOutlet weak var orderTableView: UITableView!
    @IBOutlet weak var waitView: UIView!
    var orderViewModel: OrderViewModelProtocol = OrderViewModel()
    private var loadIndicator: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        orderViewModel.delegate = self
        setupLoadingIndicator()
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
    
    private func setupLoadingIndicator() {
        loadIndicator = createLoadingIndicator(in: waitView)
    }
}

extension OrderViewController: OrderViewModelOutputProtocol {
    func update() {
        orderTableView.reloadData()
    }
    func error() {
        // Hata göster
    }
    func startLoading() {
        waitView.isHidden = false
        loadIndicator.isHidden = false
        loadIndicator.startAnimating()
    }
    
    func stopLoading() {
        waitView.isHidden = true
        loadIndicator.isHidden = true
        loadIndicator.stopAnimating()
    }
}
