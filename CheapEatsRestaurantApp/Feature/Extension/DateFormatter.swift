//
//  DateFormatter.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 10.06.2025.
//

import UIKit

protocol DateFormattable {
    func dateFormatter(with date: Date) -> String
}

extension DateFormattable {
    func dateFormatter(with date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
}

extension UIViewController: DateFormattable {}
extension UICollectionViewCell: DateFormattable {}
extension UITableViewCell: DateFormattable {}
