//
//  ProfileSettingsViewController.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 7.06.2025.
//

import UIKit

final class ProfileSettingsViewController: UIViewController {
    
    @IBOutlet private weak var restaurantNameLabel: UILabel!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var phoneLabel: UILabel!
    @IBOutlet private weak var editProfileButton: UIButton!
    @IBOutlet private weak var changePasswordButton: UIButton!
    @IBOutlet private weak var logoutButton: UIButton!
    //TODO: adres düzenleme butınunu ekle
    var profileSettingsViewModel: ProfileSettingsViewModelProtocol = ProfileSettingsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        title = "Profile Settings"
        
    }
    
    @IBAction func editProfileTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func changePasswordTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func logoutTapped(_ sender: UIButton) {
        
    }
    private func updateUI() {
        let user = profileSettingsViewModel.user
        restaurantNameLabel.text = user.restaurantName
        usernameLabel.text = user.fullName
        emailLabel.text = user.email
        phoneLabel.text = user.phoneNumber
    }
}

// MARK: - ViewModel Output
extension ProfileSettingsViewController: ProfileSettingsViewModelOutputProtocol {
    func navigateToEditProfile(with user: UserModel) {
        // Instantiate from storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let editProfileVC = storyboard.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController {
            let viewModel = EditProfileViewModel(user: user)
            editProfileVC.configure(with: viewModel)
            navigationController?.pushViewController(editProfileVC, animated: true)
        }
    }
    
    func navigateToChangePassword() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let changePasswordVC = storyboard.instantiateViewController(withIdentifier: "ChangePasswordViewController") as? ChangePasswordViewController {
            
            navigationController?.pushViewController(changePasswordVC, animated: true)
        }
    }
    
    func didLogout() {
    }
    
    func updateUserInterface() {
        updateUI()
    }
}
