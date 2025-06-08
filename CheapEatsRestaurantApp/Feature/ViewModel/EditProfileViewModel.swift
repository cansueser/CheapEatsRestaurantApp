//
//  EditProfileViewModel.swift
//  CheapEatsRestaurantApp
//
//  Created by EmreYlr on 7.06.2025.
//

import Foundation

// MARK: - Protocols
protocol EditProfileViewModelProtocol {
    var delegate: EditProfileViewModelOutputProtocol? { get set }
    var restaurant: Restaurant? { get }

}

protocol EditProfileViewModelOutputProtocol: AnyObject {
    func updateUI()
    func showError(message: String)
    func startLoading()
    func stopLoading()
    func updateSaveButtonState(isEnabled: Bool)
    func navigateBack()
}

// MARK: - ViewModel Implementation
final class EditProfileViewModel {
    weak var delegate: EditProfileViewModelOutputProtocol?
    private(set) var restaurant: Restaurant?
    
}

extension EditProfileViewModel: EditProfileViewModelProtocol {}
