//
//  ProductAddedViewModel.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 23.12.2024.
//

import Foundation
final class ProductAddedViewModel {
    func validateFields(
        name: String?,
        description: String?,
        oldPrice: String?,
        newPrice: String?
    ) -> Bool {
        return !(name?.isEmpty ?? true) &&
               !(description?.isEmpty ?? true) &&
               !(oldPrice?.isEmpty ?? true) &&
               !(newPrice?.isEmpty ?? true)
    }
    
    func createOrder(
        name: String,
        description: String,
        oldPrice: Double,
        newPrice: Double,
        deliveryType: Int,
        discountType: Int,
        startTime: Date,
        endTime: Date,
        foodImage: UIImage
    ) -> Order {
        return Order(
            foodName: name,
            foodDescription: description,
            oldPrice: oldPrice,
            newPrice: newPrice,
            deliveryType: deliveryType,
            discountType: discountType,
            startTime: startTime,
            endTime: endTime,
            foodImage: foodImage
        )
    }
}
