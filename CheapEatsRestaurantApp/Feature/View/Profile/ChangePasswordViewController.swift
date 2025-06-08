//
//  ChangePasswordViewController.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 7.06.2025.
//
import UIKit

final class ChangePasswordViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var currentPasswordTextField: UITextField!
    @IBOutlet private weak var newPasswordTextField: UITextField!
    // @IBOutlet private weak var confirmPasswordTextField: UITextField!
    @IBOutlet private weak var saveButton: UIButton!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
    }
}



// MARK: - ViewModel Output
extension ChangePasswordViewController: ChangePasswordViewModelOutputProtocol {
    func showLoading() {
        
    }
    
    func hideLoading() {
        
        
    }
    
    func passwordChanged() {
    }
    
    func showError(message: String) {
       
    }
}

