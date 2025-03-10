//
//  String+UpperCase.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 10.03.2025.
//

import Foundation

extension String {
    func turkishUppercased() -> String {
        return self.uppercased(with: Locale(identifier: "tr_TR"))
    }
}
