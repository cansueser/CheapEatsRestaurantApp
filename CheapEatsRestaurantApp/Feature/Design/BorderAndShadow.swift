//
//  BorderAndShadow.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 6.03.2025.
//

import UIKit

protocol BorderAndShadow {
    func setBorder(with CALayer: CALayer)
    func setShadow(with CALayer: CALayer, shadowOffset: Bool)
}
extension BorderAndShadow {
    func setBorder(with CALayer: CALayer) {
        CALayer.borderColor = UIColor.gray.cgColor
        CALayer.borderWidth = 0.2
    }
    
    func setShadow(with CALayer: CALayer, shadowOffset: Bool) {
        CALayer.shadowColor = UIColor.black.cgColor
        CALayer.masksToBounds = false
        CALayer.shadowOpacity = 0.2
        if shadowOffset {
            CALayer.shadowOffset = CGSize(width: 1, height: 0)
        }else{
            CALayer.shadowOffset = CGSize(width: 0, height: 1)
        }
        
        CALayer.shadowRadius = 3.0
    }
}

extension UITableViewCell: BorderAndShadow {}
extension UIViewController: BorderAndShadow {}
