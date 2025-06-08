//
//  ChangePasswordViewController.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 7.06.2025.
//

import UIKit

final class ChangePasswordViewController: UIViewController {
    
    @IBOutlet private weak var currentPasswordTextField: UITextField!
    @IBOutlet private weak var newPasswordTextField: UITextField!
    @IBOutlet private weak var saveButton: UIButton!
    
    private var viewModel: ChangePasswordViewModelProtocol!

       func configure(with viewModel: ChangePasswordViewModelProtocol) {
           self.viewModel = viewModel
       }
       
       override func viewDidLoad() {
           super.viewDidLoad()
           setupUI()
       }
       
       private func setupUI() {
           title = "Change Password"
           
           currentPasswordTextField.isSecureTextEntry = true
           newPasswordTextField.isSecureTextEntry = true
           
       
       }
       
       // MARK: - IBActions
       @IBAction func savePasswordTapped(_ sender: UIButton) {
           guard let currentPassword = currentPasswordTextField.text,
                 let newPassword = newPasswordTextField.text else {
               return
           }
           
           viewModel.changePassword(currentPassword: currentPassword, newPassword: newPassword)
       }
   }

   // MARK: - ViewModel Output
   extension ChangePasswordViewController: ChangePasswordViewModelOutputProtocol {
       func didChangePassword(newPassword: String) {
           // Password changed successfully
           // Go back to profile settings
           navigationController?.popViewController(animated: true)
       }
       
       func showError(message: String) {
           let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default))
           present(alert, animated: true)
       }
   }
