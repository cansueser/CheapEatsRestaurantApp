//
//  OrderViewController+TableView.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 9.12.2024.
//

import Foundation
import UIKit
extension OrderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return 5
        return orders.count // OrderViewController içindeki orders dizisini kullanıyoruz
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! ProductTableViewCell
        // cell.foodImage.image = UIImage(named: "testImage")
        //YENİ
        // İlgili order verisini alıyoruz
        let order = orders[indexPath.row]
        // Hücreyi dolduruyoruz
        cell.foodNameLabel.text = order.name
        //cell.productDescriptionTextView.text = order.description
        cell.foodImage.image = order.foodImage
        cell.oldAmountLabel.text = String(order.oldPrice)
        cell.newAmountLabel.text = String(order.newPrice)
        // Sipariş durumunu stateLabel'e ayarla
        cell.stateLabel.text = order.orderStatus.description
        cell.stateLabel.textColor = order.orderStatus.textColor
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    func tableView(_ tableView: UITableView, weightForRowAt indexPath: IndexPath) -> CGFloat {
        return 390
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell seçildi test")
    }
}
