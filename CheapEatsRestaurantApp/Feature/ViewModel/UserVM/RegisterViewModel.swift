//
//  RegisterViewModel.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 1.03.2025.
//

import Foundation
import UIKit


protocol RegisterViewModelProtocol{
    var delegate: RegisterViewModelOutputProtocol? { get set}
    func registerRestaurant(restaurant: Restaurant, password: String)
}

protocol RegisterViewModelOutputProtocol: AnyObject {
    func update()
    func error()
    
}

final class RegisterViewModel {
    weak var delegate: RegisterViewModelOutputProtocol?
    
    func registerRestaurant(restaurant: Restaurant, password: String) {
        NetworkManager.shared.registerRestaurant(restaurant: restaurant, password: password) { result in
            switch result{
            case .success:
                self.delegate?.update()
            case .failure(let error):
                print(error)
                self.delegate?.error()
            }
        }
    }
    
}
extension RegisterViewModel: RegisterViewModelProtocol {}

