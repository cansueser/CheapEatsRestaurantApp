//
//  ProductMode.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 25.12.2024.
//

import Foundation
// Enum'u burada tanımlıyoruz
enum ProductMode {
    case add
    case edit(existingProduct: Order)
}
