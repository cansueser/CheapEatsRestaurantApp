//
//  ProfileSettingsViewController.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 7.06.2025.
//

import UIKit
import NVActivityIndicatorView

final class ProfileSettingsViewController: UIViewController {
    // MARK: - Variables
    @IBOutlet private weak var companyNameLabel: UILabel!
    @IBOutlet private weak var ownerNameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var phoneLabel: UILabel!
    @IBOutlet private weak var updateAddressButton: UIButton!
    @IBOutlet private weak var editProfileButton: UIButton!
    @IBOutlet private weak var changePasswordButton: UIButton!
    @IBOutlet private weak var logoutButton: UIButton!
    @IBOutlet weak var waitView: UIView!
    
    var profileSettingsViewModel: ProfileSettingsViewModelProtocol = ProfileSettingsViewModel()
    private var loadIndicator: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLoad()
        setupButtons()
        setupLoadingIndicator()
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
    
    private func setupLoadingIndicator() {
        loadIndicator = createLoadingIndicator(in: waitView)
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
    
    func startLoading() {
        waitView.isHidden = false
        waitView.alpha = 0.4
        loadIndicator.isHidden = false
        loadIndicator.startAnimating()
    }
    
    func stopLoading() {
        waitView.isHidden = true
        loadIndicator.isHidden = true
        loadIndicator.stopAnimating()
    }
}

