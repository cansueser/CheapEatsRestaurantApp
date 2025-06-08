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
        guard !email.isEmpty else { throw EmailValidationError.empty }
        
        // E-posta formatı kontrolü
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        guard emailPredicate.evaluate(with: email) else {
            throw EmailValidationError.invalidFormat
        }
        
        // Domain kontrolü
        let allowedDomains = ["gmail.com", "hotmail.com", "outlook.com", "yahoo.com", "icloud.com"]
        let domain = email.components(separatedBy: "@").last ?? ""
        guard allowedDomains.contains(domain) else {
            throw EmailValidationError.domainNotAllowed
        }
    }

    
}
extension RegisterViewModel: RegisterViewModelProtocol {}

