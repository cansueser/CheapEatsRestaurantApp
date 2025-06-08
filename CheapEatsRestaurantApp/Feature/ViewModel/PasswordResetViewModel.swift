//
//  PasswordResetViewModel.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 23.03.2025.
//

import Foundation

/*
protocol PassResViewModelProtocol {
    var delegate: PassResViewModelOutputProtocol? {get set}
    func resetPassword(email: String)
}

protocol PassResViewModelOutputProtocol: AnyObject {
    func update()
    func error()
}

final class PassResViewModel {
    weak var delegate: PassResViewModelOutputProtocol?
    
    func resetPassword(email: String) {
        NetworkManager.shared.resetPassword(email: email) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.delegate?.update()
            case .failure:
                self.delegate?.error()
            }
        }
    }
}

extension PassResViewModel: PassResViewModelProtocol { }
*/
