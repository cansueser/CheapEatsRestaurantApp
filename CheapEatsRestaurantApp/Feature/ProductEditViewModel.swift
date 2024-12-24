import Foundation
import UIKit

class ProductEditViewModel {
    
    private var product: Order
    
    // Initializer
    init(product: Order) {
        self.product = product
    }
    
    // Getters for product properties
    func getProductName() -> String {
        return product.name
    }
    
    func getProductDescription() -> String {
        return product.description
    }
    
    func getOldPrice() -> String {
        return String(product.oldPrice)
    }
    
    func getNewPrice() -> String {
        return String(product.newPrice)
    }
    
    func getProductImage() -> UIImage {
        return product.foodImage
    }
    
    // Method to update the product details
    func updateProduct(name: String, description: String, oldPrice: Double, newPrice: Double, foodImage: UIImage) {
        self.product.name = name
        self.product.description = description
        self.product.oldPrice = oldPrice
        self.product.newPrice = newPrice
        self.product.foodImage = foodImage
    }
}
