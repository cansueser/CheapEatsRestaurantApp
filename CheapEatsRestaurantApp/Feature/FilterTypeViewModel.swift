//
//  FilterDeliveryTypeViewModel.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 11.12.2024.
//

import Foundation
protocol FilterTypeViewModelProtocol {
    var delegate: FilterTypeViewModelOutputProtocol? { get set }
    var selectedDeliveryType : Int { get set }
    var selectedDiscount : Int { get set }
}
protocol FilterTypeViewModelOutputProtocol: AnyObject {
}
final class FilterTypeViewModel {
    weak var delegate: FilterTypeViewModelOutputProtocol?
    var selectedDeliveryType : Int = 0
    var selectedDiscount : Int = 0
}
extension FilterTypeViewModel: FilterTypeViewModelProtocol {
}

