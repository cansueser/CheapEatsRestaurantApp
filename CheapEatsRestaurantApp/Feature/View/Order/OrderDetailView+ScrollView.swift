//
//  OrderDetailView+ScrollView.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 10.06.2025.
//
import UIKit

extension OrderDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY > 0 {
            navigationController?.navigationBar.tintColor = .white
            navigationController?.navigationBar.backgroundColor = .white
            navigationController?.navigationBar.tintColor = .white
        } else {
            navigationController?.navigationBar.backgroundColor = .clear
            navigationController?.navigationBar.tintColor = UIColor(named: "ButtonColor")
        }
    }
}
