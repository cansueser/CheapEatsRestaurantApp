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
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! TableViewCellAdded
        cell.foodImage.image = UIImage(named: "testImage")
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    func tableView(_ tableView: UITableView, weightForRowAt indexPath: IndexPath) -> CGFloat {
        return 390
    }
    
  /*  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let SB = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = SB.instantiateViewController(withIdentifier: "OrdersDetailViewController") as! OrdersDetailViewController
        navigationController?.pushViewController(detailVC, animated: true)
    }*/
        }

