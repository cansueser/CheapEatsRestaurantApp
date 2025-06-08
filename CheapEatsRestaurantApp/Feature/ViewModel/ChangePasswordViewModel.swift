//
//  ChangePasswordViewModel.swift
//  CheapEatsRestaurantApp
//
//  Created by EmreYlr on 7.06.2025.
//

import Foundation

// MARK: - Protocols
protocol ChangePasswordDelegate: AnyObject {
    func didChangePassword()
}

protocol ChangePasswordViewModelOutputProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func passwordChanged()
    func showError(message: String)
}

final class ChangePasswordViewModel {
    weak var delegate: ChangePasswordViewModelOutputProtocol?
    weak var changePasswordDelegate: ChangePasswordDelegate?

}
