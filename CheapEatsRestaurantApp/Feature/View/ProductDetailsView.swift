//
//  ProductDetailsView.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 24.12.2024.
//

import Foundation
import UIKit


class ProductDetailsView: UIView {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productDescriptionTextView: UITextView!
    @IBOutlet weak var oldPriceTextField: UITextField!
    @IBOutlet weak var newPriceTextField: UITextField!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    func configure(with product: Order?) {
        if let product = product {
            productNameTextField.text = product.name
            productDescriptionTextView.text = product.description
            oldPriceTextField.text = "\(product.oldPrice)"
            newPriceTextField.text = "\(product.newPrice)"
            productImageView.image = product.foodImage
        } else {
            productNameTextField.text = ""
            productDescriptionTextView.text = ""
            oldPriceTextField.text = ""
            newPriceTextField.text = ""
            productImageView.image = nil
        }
    }
}

