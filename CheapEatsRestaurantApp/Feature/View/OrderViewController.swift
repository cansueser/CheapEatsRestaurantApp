//
//  ViewController.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 9.12.2024.
//

import UIKit

class OrderViewController: UIViewController {

    @IBOutlet weak var orderTableView: UITableView!
    @IBOutlet weak var foodAddButton: UIButton!
    
    private var orderViewModel = OrderViewModel()
    var orders: [Order] = []  // Yemeklerin listeleneceği dizi

    override func viewDidLoad() {
        super.viewDidLoad()
        print("test")
        initTableView()
        //YENİ
        //orderViewModel.delegate = self
        // TableView Ayarları
        orderTableView.delegate = self
        orderTableView.dataSource = self
        orderTableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "orderCell")
        
        // İlgili verilerle TableView'ı güncelleme
        orders.append(Order(name: "Pizza", description: "Delicious pizza", oldPrice: 20.0, newPrice: 15.0, deliveryType: 1, discountType: 1, startTime: Date(), endTime: Date(), foodImage: UIImage(named: "testImage")!, orderStatus: .preparing))
        
        orderTableView.reloadData() // TableView'ı güncelleyerek verileri gösteriyoruz.
        //BURAYA KADAR YENİ

    }
    func initTableView() {
        orderTableView.delegate = self
        orderTableView.dataSource = self
        orderTableView.separatorStyle = .none
        orderTableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "orderCell")
        orderTableView.layer.cornerRadius = 10
        
    }
    
    @IBAction func foodAddButtonClicked(_ sender: UIButton) {
        let SB = UIStoryboard(name: "Main", bundle: nil)
        let productVC = SB.instantiateViewController(withIdentifier: "ProductAddedViewController") as! ProductAddedViewController
        navigationController?.pushViewController(productVC, animated: true)
    }
}

