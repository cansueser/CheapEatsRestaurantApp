//
//  ProfileSettingsViewModel.swift
//  CheapEatsRestaurantApp
//
//  Created by EmreYlr on 7.06.2025.
//

import Foundation

protocol ProfileSettingsViewModelProtocol {
    var delegate: ProfileSettingsViewModelOutputProtocol? { get set }
    var restaurant: Restaurant? { get }
    func refreshRestaurantData()
    func signOut()
}

protocol ProfileSettingsViewModelOutputProtocol: AnyObject {
    func update()
    func error()
    func startLoading()
    func stopLoading()
}

final class ProfileSettingsViewModel {
    weak var delegate: ProfileSettingsViewModelOutputProtocol?
    private(set) var restaurant: Restaurant?
    
    init() {
        self.restaurant = RestaurantManager.shared.restaurant
    }
    
    func refreshRestaurantData() {
        restaurant = RestaurantManager.shared.restaurant
    }
    
    func signOut() {
        self.delegate?.startLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            NetworkManager.shared.logout { [weak self] result in
                self?.delegate?.stopLoading()
                switch result {
                case .success:
                    RestaurantManager.shared.signOut()
                    UserDefaultsManager.shared.clearUserData()
                    self?.delegate?.update()
                case .failure:
                    self?.delegate?.error()
                }
            }
        }
    }
}

extension ProfileSettingsViewModel: ProfileSettingsViewModelProtocol {}
