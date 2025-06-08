//
//  EditProfileViewController.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 7.06.2025.
//

import UIKit

final class EditProfileViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var companyNameTextField: UITextField!
    @IBOutlet private weak var ownerNameTextField: UITextField!
    @IBOutlet private weak var ownerSurnameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var phoneTextField: UITextField!
    @IBOutlet private weak var saveButton: UIButton!
    
    // MARK: - Properties
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSaveButton()
    }
    
    private func setupSaveButton() {
        saveButton.layer.cornerRadius = 8
        saveButton.isEnabled = false
        saveButton.alpha = 0.5
    }
    
    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
    }
}

// MARK: - ViewModel Output
extension EditProfileViewController: EditProfileViewModelOutputProtocol {
    func updateUI() {
    }
    
    func showError(message: String) {
        
    }
    
    func startLoading() {
        
    }
    
    func stopLoading() {
        
    }
    
    func updateSaveButtonState(isEnabled: Bool) {
        
        
    }
    
    func navigateBack() {
    
    }
}
