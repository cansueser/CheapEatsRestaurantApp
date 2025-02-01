//
//  FilterDeliveryTypeViewModel.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 11.12.2024.
//

import Foundation

protocol FilterTypeViewModelProtocol {
    var delegate: FilterTypeViewModelOutputProtocol? { get set }
    var selectedDeliveryType: Int { get set }
    var selectedDiscount: Int { get set }
    
    func updateDeliveryType(to index: Int)
}

protocol FilterTypeViewModelOutputProtocol: AnyObject {
    func deliveryTypeDidUpdate(to index: Int)
}

final class FilterTypeViewModel {
    weak var delegate: FilterTypeViewModelOutputProtocol?
    var selectedDeliveryType: Int = 0
    var selectedDiscount: Int = 0
}

extension FilterTypeViewModel: FilterTypeViewModelProtocol {
    func updateDeliveryType(to index: Int) {
        selectedDeliveryType = index
        // UI'yi bilgilendirme
        delegate?.deliveryTypeDidUpdate(to: index)
        
    }
}

