//
//  EditProfileViewModel.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 7.06.2025.
//

import Foundation

// MARK: - Protocols
protocol EditProfileViewModelProtocol {
    var output: EditProfileViewModelOutputProtocol? { get set }
    var user: UserModel { get }
    
    func saveProfile(firstName: String, lastName: String, email: String, phoneNumber: String, restaurantName: String)
}

protocol EditProfileViewModelOutputProtocol: AnyObject {
    func didUpdateUser(user: UserModel)
}

// MARK: - ViewModel Implementation
final class EditProfileViewModel: EditProfileViewModelProtocol {
    weak var output: EditProfileViewModelOutputProtocol?
    
    private(set) var user: UserModel
    
    init(user: UserModel) {
        self.user = user
    }
    
    func saveProfile(firstName: String, lastName: String, email: String, phoneNumber: String, restaurantName: String) {
        let updatedUser = UserModel(
            firstName: firstName,
            lastName: lastName,
            email: email,
            phoneNumber: phoneNumber,
            restaurantName: restaurantName,
            password: user.password
        )
        
        // Here you would typically make an API call to update the user's profile
        
        // After successful API call, update local user and notify
        self.user = updatedUser
        output?.didUpdateUser(user: updatedUser)
    }
}
