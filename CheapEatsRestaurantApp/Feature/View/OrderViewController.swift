//
//  ViewController.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 9.12.2024.
//

import UIKit

class OrderViewController: UIViewController {

    @IBOutlet weak var orderTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("test")
        initTableView()

    }
    func initTableView() {
        orderTableView.delegate = self
        orderTableView.dataSource = self
        orderTableView.register(UINib(nibName: "TableViewCellAdded", bundle: nil), forCellReuseIdentifier: "orderCell")
        orderTableView.layer.cornerRadius = 10
        
    }
}

