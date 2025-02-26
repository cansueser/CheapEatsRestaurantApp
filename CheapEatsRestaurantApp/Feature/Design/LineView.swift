//
//  LineView.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 26.02.2025.
//
import UIKit

class CustomLineView: UIView {
    var lineYPosition: CGFloat = 0.0
    var lineColor: UIColor = .lightGray
    var lineWidth: CGFloat = 1.0

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawHorizontalLine(at: lineYPosition, with: lineColor, lineWidth: lineWidth)
    }

    func drawHorizontalLine(at yPosition: CGFloat, with color: UIColor = .lightGray, lineWidth: CGFloat = 1.0) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(lineWidth)
        context.move(to: CGPoint(x: 10, y: yPosition))
        context.addLine(to: CGPoint(x: self.bounds.width - 10, y: yPosition))
        context.strokePath()
    }
}
