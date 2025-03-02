//
//  LoginViewModel.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 2.03.2025.
//

import Foundation
import UIKit

protocol LoginViewModelProtocol{
    var delegate: LoginViewModelOutputProtocol? { get set}
   // func loginUser(email: String , password: String)
    func loginUser(user: UserLogin, password: String)
}

protocol LoginViewModelOutputProtocol: AnyObject {
    func update()
    func error()
    
}

final class LoginViewModel {
    weak var delegate: LoginViewModelOutputProtocol?
    
    func loginUser(user: UserLogin, password: String) {
        NetworkManager.shared.login(user: user, password: password) { result in
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
extension LoginViewModel: LoginViewModelProtocol {}

  
