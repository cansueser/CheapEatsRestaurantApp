//
//  ProductDetailViewModel.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 25.12.2024.
//

import Foundation
import UIKit

class ProductDetailViewModel {
    private var product: Product
    
    init(product: Product) {
        self.product = product
    }
    
    func getProduct() -> Product {
        return product
    }
    
    func updateProduct(newProduct: Product) {
        product = newProduct
    }
}
