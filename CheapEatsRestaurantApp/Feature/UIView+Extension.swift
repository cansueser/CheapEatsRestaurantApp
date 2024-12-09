//
//  UIView+Extension.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 9.12.2024.
//

import Foundation
import UIKit

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat, borderColor: UIColor? = nil, borderWidth: CGFloat = 0) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
        if let borderColor = borderColor, borderWidth > 0 {
            let borderLayer = CAShapeLayer()
            borderLayer.path = path.cgPath
            borderLayer.fillColor = UIColor.clear.cgColor
            borderLayer.strokeColor = borderColor.cgColor
            borderLayer.lineWidth = borderWidth
            borderLayer.frame = bounds
            layer.sublayers?.removeAll(where: { $0 is CAShapeLayer && $0 !== mask })
            
            layer.addSublayer(borderLayer)
        }
    }

}
