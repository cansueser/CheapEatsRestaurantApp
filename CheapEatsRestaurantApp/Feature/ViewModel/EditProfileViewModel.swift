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
    var restaurant: Restaurant? { get set }
    func checkForChanges(companyName: String?, name: String?, surname: String?, email: String?, phone: String?) -> Bool
    func updateRestaurantInfo(companyName: String?, name: String?, surname: String?, email: String?, phone: String?)
}

protocol EditProfileViewModelOutputProtocol: AnyObject {
    func update()
    func error()
    func startLoading()
    func stopLoading()
    func updateButtonState(isEnabled: Bool)
}

// MARK: - ViewModel Implementation
final class EditProfileViewModel {
    weak var delegate: EditProfileViewModelOutputProtocol?
    var restaurant: Restaurant?
    
    private var originalCompanyName: String = ""
    private var originalName: String = ""
    private var originalSurname: String = ""
    private var originalEmail: String = ""
    private var originalPhone: String = ""
    
    init() {
        restaurant = RestaurantManager.shared.restaurant
        
        if let restaurant = restaurant {
            originalCompanyName = restaurant.companyName
            originalName = restaurant.ownerName
            originalSurname = restaurant.ownerSurname
            originalEmail = restaurant.email
            originalPhone = restaurant.phone
        }
    }
    
    func checkForChanges(companyName: String? ,name: String?, surname: String?, email: String?, phone: String?) -> Bool {
        let currentCompanyName = companyName ?? ""
        let currentName = name ?? ""
        let currentSurname = surname ?? ""
        let currentEmail = email ?? ""
        let currentPhone = phone ?? ""
        
        let hasChanges = currentCompanyName != originalCompanyName ||
        currentName != originalName ||
        currentSurname != originalSurname ||
        currentEmail != originalEmail ||
        currentPhone != originalPhone
        
        return hasChanges
    }
    
    func updateRestaurantInfo(companyName: String?, name: String?, surname: String?, email: String?, phone: String?) {
        delegate?.startLoading()
        originalCompanyName = companyName ?? ""
        originalName = name ?? ""
        originalSurname = surname ?? ""
        originalEmail = email ?? ""
        originalPhone = phone ?? ""
        
        delegate?.startLoading()
        guard var updatedRestaurant = RestaurantManager.shared.restaurant else {
            delegate?.error()
            delegate?.stopLoading()
            return
        }
        
        updatedRestaurant.ownerName = name ?? updatedRestaurant.ownerName
        updatedRestaurant.ownerSurname = surname ?? updatedRestaurant.ownerSurname
        updatedRestaurant.email = email ?? updatedRestaurant.email
        updatedRestaurant.phone = phone ?? updatedRestaurant.phone
        updatedRestaurant.companyName = companyName ?? updatedRestaurant.companyName
        
        NetworkManager.shared.updateRestaurantInfo(restaurant: updatedRestaurant) { result in
            switch result {
            case .success():
                self.delegate?.update()
            case .failure(_):
                self.delegate?.error()
            }
            self.delegate?.stopLoading()
        }
    }
}

extension EditProfileViewModel: EditProfileViewModelProtocol {}
