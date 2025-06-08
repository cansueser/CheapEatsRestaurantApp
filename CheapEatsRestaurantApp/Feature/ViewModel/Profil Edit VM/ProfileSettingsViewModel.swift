//
//  ProfileSettingsViewModel.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 7.06.2025.
//

import Foundation

// MARK: - Protocols
protocol ProfileSettingsViewModelProtocol {
    var delegate: ProfileSettingsViewModelOutputProtocol? { get set }
    var user: UserModel { get }

}

protocol ProfileSettingsViewModelOutputProtocol: AnyObject {
    func navigateToEditProfile(with user: UserModel)
    func navigateToChangePassword()
    func didLogout()
    func updateUserInterface()
}

// MARK: - ViewModel Implementation
final class ProfileSettingsViewModel: ProfileSettingsViewModelProtocol {
    weak var delegate: ProfileSettingsViewModelOutputProtocol?
    
    private(set) var user: UserModel
    
    init(user: UserModel = UserModel(
        firstName: "John",
        lastName: "Doe",
        email: "john.doe@example.com",
        phoneNumber: "+90 555 123 4567",
        restaurantName: "Delicious Bites",
        password: "password123"
    )) {
        self.user = user
    }
}
