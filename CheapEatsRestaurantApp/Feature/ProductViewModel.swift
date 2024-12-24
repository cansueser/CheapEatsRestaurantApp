//
//  ProductViewModel.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 14.12.2024.
//

import Foundation
final class ProductViewModel {
    func validateFields(name: String?, description: String?, oldPrice: String?, newPrice: String?) -> Bool {
        return !(name?.isEmpty ?? true) &&
               !(description?.isEmpty ?? true) &&
               !(oldPrice?.isEmpty ?? true) &&
               !(newPrice?.isEmpty ?? true)
    }
}

