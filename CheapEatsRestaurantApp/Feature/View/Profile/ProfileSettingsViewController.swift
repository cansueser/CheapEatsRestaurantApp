//
//  ProfileSettingsViewController.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 7.06.2025.
//

import UIKit

final class ProfileSettingsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var companyNameLabel: UILabel!
    @IBOutlet private weak var ownerNameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var phoneLabel: UILabel!
    @IBOutlet private weak var updateAddressButton: UIButton!
    @IBOutlet private weak var editProfileButton: UIButton!
    @IBOutlet private weak var changePasswordButton: UIButton!
    @IBOutlet private weak var logoutButton: UIButton!
    
    var profileSettingsViewModel: ProfileSettingsViewModelProtocol = ProfileSettingsViewModel()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initLoad()
        setupButtons()
    }
    
    private func initLoad() {
        profileSettingsViewModel.delegate = self
    }
    private func setupButtons() {
        editProfileButton.layer.cornerRadius = 8
        changePasswordButton.layer.cornerRadius = 8
        updateAddressButton.layer.cornerRadius = 8
        logoutButton.layer.cornerRadius = 8
    }

    // MARK: - Actions
    @IBAction func editProfileTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func changePasswordTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func logoutTapped(_ sender: UIButton) {
        profileSettingsViewModel.signOut()
    }
}

extension ProfileSettingsViewController: ProfileSettingsViewModelOutputProtocol {
    func update() {
        let SB = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = SB.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let navigationController = UINavigationController(rootViewController: loginViewController)
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window?.layer.add(transition, forKey: kCATransition)
        self.view.window?.rootViewController = navigationController
        self.view.window?.makeKeyAndVisible()
    }
    
    func error() {
        print("Error")
    }
    
    
}

