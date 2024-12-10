//
//  UIViewController+Extension.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 10.12.2024.
//

import Foundation
import UIKit

extension UIViewController {
    func configureView(_ view: UIView, cornerRadius: CGFloat) {
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = true
    }
    
    func configureView(_ view: UIView, cornerRadius: CGFloat, borderColor: UIColor?, borderWidth: CGFloat) {
        view.layer.cornerRadius = cornerRadius
        view.layer.borderColor = borderColor?.cgColor
        view.layer.borderWidth = borderWidth
        view.layer.masksToBounds = true
    }
}
