//
//  ChangePasswordViewModel.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 7.06.2025.
//

import Foundation

// MARK: - Protocols
protocol ChangePasswordViewModelProtocol {
    var output: ChangePasswordViewModelOutputProtocol? { get set }
    
    func changePassword(currentPassword: String, newPassword: String)
}

protocol ChangePasswordViewModelOutputProtocol: AnyObject {
    func didChangePassword(newPassword: String)
    func showError(message: String)
}

// MARK: - ViewModel Implementation
final class ChangePasswordViewModel: ChangePasswordViewModelProtocol {
    weak var output: ChangePasswordViewModelOutputProtocol?
    
    private let currentPassword: String
    
    init(currentPassword: String) {
        self.currentPassword = currentPassword
    }
    
    func changePassword(currentPassword: String, newPassword: String) {
        // Validate current password
        if currentPassword != self.currentPassword {
            output?.showError(message: "Current password is incorrect")
            return
        }
        
        // Validate new password (example: minimum 6 characters)
        if newPassword.count < 6 {
            output?.showError(message: "New password should be at least 6 characters")
            return
        }
        
        // Here you would typically make an API call to update the password
        
        // After successful API call, notify
        output?.didChangePassword(newPassword: newPassword)
    }
}
