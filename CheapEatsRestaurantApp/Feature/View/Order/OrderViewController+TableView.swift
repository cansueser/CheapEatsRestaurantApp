//
//  OrderViewController+TableView.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 11.05.2025.
//

import UIKit
extension OrderViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderViewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as? ProductTableViewCell else {
            return UITableViewCell()
        }
        let order = orderViewModel.products[indexPath.row]
        print("Order: \(order)")
        cell.configureCell(wtih: order)
        //cell.fakeconfigureCell()
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    
}
