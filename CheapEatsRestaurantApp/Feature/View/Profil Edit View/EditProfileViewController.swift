//
//  EditProfileViewController.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 7.06.2025.
//

import UIKit

final class EditProfileViewController: UIViewController {
   
    @IBOutlet private weak var firstNameTextField: UITextField!
    @IBOutlet private weak var lastNameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var phoneTextField: UITextField!
    @IBOutlet private weak var restaurantNameTextField: UITextField!
    @IBOutlet private weak var saveButton: UIButton!
    
    private var viewModel: EditProfileViewModelProtocol!

       // MARK: - Setup
       func configure(with viewModel: EditProfileViewModelProtocol) {
           self.viewModel = viewModel
           if isViewLoaded {
               populateFields()
           }
       }
       
       // MARK: - Lifecycle
       override func viewDidLoad() {
           super.viewDidLoad()
           setupUI()
           populateFields()
       }
       
       // MARK: - Setup UI
       private func setupUI() {
           title = "Edit Profile"
           // Remove programmatic button setup - will be connected via storyboard
       }
       
       private func populateFields() {
           let user = viewModel.user
           firstNameTextField.text = user.firstName
           lastNameTextField.text = user.lastName
           emailTextField.text = user.email
           phoneTextField.text = user.phoneNumber
           restaurantNameTextField.text = user.restaurantName
       }
       
       // MARK: - IBActions
       @IBAction func saveProfileTapped(_ sender: UIButton) {
           guard let firstName = firstNameTextField.text,
                 let lastName = lastNameTextField.text,
                 let email = emailTextField.text,
                 let phoneNumber = phoneTextField.text,
                 let restaurantName = restaurantNameTextField.text else {
               return
           }
           
           viewModel.saveProfile(
               firstName: firstName,
               lastName: lastName,
               email: email,
               phoneNumber: phoneNumber,
               restaurantName: restaurantName
           )
       }
   }
