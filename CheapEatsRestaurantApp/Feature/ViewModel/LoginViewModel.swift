//
//  LoginViewModel.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 2.03.2025.
//

import Foundation
import UIKit
import FirebaseAuth

protocol LoginViewModelProtocol{
    var delegate: LoginViewModelOutputProtocol? { get set}
    func loginUser(email: String, password: String)
}

protocol LoginViewModelOutputProtocol: AnyObject {
    func update()
    func error()
    func startLoading()
    func stopLoading()
}

final class LoginViewModel {
    weak var delegate: LoginViewModelOutputProtocol?
    
    func loginUser(email: String, password: String) {
        delegate?.startLoading()
        NetworkManager.shared.login(email: email, password: password) { result in
            switch result{
            case .success:
                guard let restaurantId = self.getCurrentUser()?.uid else{
                    self.delegate?.error()
                    self.delegate?.stopLoading()
                    return
                }
                self.getRestaurantInfo(uid: restaurantId)
            case .failure(let error):
                print(error)
                self.delegate?.error()
                self.delegate?.stopLoading()
            }
            
        }
    }
    
    private func getCurrentUser() -> User? {
        if let user = Auth.auth().currentUser {
            return user
        }
        return nil
    }
    
    private func getRestaurantInfo(uid: String) {
        NetworkManager.shared.getRestaurantInfo(uid: uid) { [weak self] restaurant in
            guard let self = self else { return }
            if let restaurant = restaurant {
                RestaurantManager.shared.restaurant = restaurant
                UserDefaultsManager.shared.saveUser(restaurant)
                self.delegate?.update()
            } else {
                self.delegate?.error()
            }
            self.delegate?.stopLoading()
        }
    }
}
extension LoginViewModel: LoginViewModelProtocol {}

  
