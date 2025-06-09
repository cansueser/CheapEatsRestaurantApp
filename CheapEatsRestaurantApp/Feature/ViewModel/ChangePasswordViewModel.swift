//
//  ChangePasswordViewModel.swift
//  CheapEatsRestaurantApp
//
//  Created by EmreYlr on 7.06.2025.
//

import Foundation

protocol ChangePasswordViewModelProtocol {
    var delegate: ChangePasswordViewModelOutputProtocol? { get set }
    func changePassword(currentPassword: String, newPassword: String)
}

protocol ChangePasswordViewModelOutputProtocol: AnyObject {
    func update()
    func error()
    func startLoading()
    func stopLoading()
}

final class ChangePasswordViewModel {
    weak var delegate: ChangePasswordViewModelOutputProtocol?
    func changePassword(currentPassword: String, newPassword: String) {
        delegate?.startLoading()
        NetworkManager.shared.updatePassword(currentPassword: currentPassword, newPassword: newPassword) { [weak self] result in
            switch result {
            case .success:
                self?.delegate?.update()
            case .failure(let error):
                print(error)
                self?.delegate?.error()
            }
            self?.delegate?.stopLoading()
        }
    }
}

extension ChangePasswordViewModel: ChangePasswordViewModelProtocol {}
