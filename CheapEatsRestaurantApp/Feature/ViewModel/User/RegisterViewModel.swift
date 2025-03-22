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
    var mapLocation : MapLocation? { get set }
    func validateEmail(_ email: String) throws
}

protocol RegisterViewModelOutputProtocol: AnyObject {
    func update()
    func error()
    
}

final class RegisterViewModel {
    weak var delegate: RegisterViewModelOutputProtocol?
    var mapLocation: MapLocation?
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
    func validateEmail(_ email: String) throws {
        if email.isEmpty {
            throw EmailValidationError.empty
        }
        
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        
        if !emailPredicate.evaluate(with: email) {
            throw EmailValidationError.invalidFormat
        }
        
        let allowedDomains = ["example.com", "test.com"]
        if let emailDomain = email.split(separator: "@").last, !allowedDomains.contains(String(emailDomain)) {
            throw EmailValidationError.domainNotAllowed
        }
    }

    
}
extension RegisterViewModel: RegisterViewModelProtocol {}

