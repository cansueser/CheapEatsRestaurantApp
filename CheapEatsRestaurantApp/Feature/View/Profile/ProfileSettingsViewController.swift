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
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var ownerView: UIView!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var profileView: UIView!
    
    var profileSettingsViewModel: ProfileSettingsViewModelProtocol = ProfileSettingsViewModel()
    private var loadIndicator: NVActivityIndicatorView!
    let SB = UIStoryboard(name: "Main", bundle: nil)
    private var editAddressViewController: EditAddressViewController?
    private var mapViewController: MapViewController?
    private var editProfileViewController: EditProfileViewController?
    private var changePasswordViewController: ChangePasswordViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initScreen()
        setupLoadingIndicator()
        updateUserInfo()
        NotificationCenter.default.addObserver(self, selector: #selector(restaurantProfileUpdated), name: NSNotification.Name("RestaurantProfileUpdated"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func restaurantProfileUpdated() {
        profileSettingsViewModel.refreshRestaurantData()
        updateUserInfo()
        showOneButtonAlert(title: "Uyarı", message: "İşleminiz başarılı bir şekilde gerçekleştirildi.")
    }
    
    private func updateUserInfo() {
        if let restaurant = profileSettingsViewModel.restaurant {
            ownerNameLabel.text = "\(restaurant.ownerName) \(restaurant.ownerSurname)"
            companyNameLabel.text = "\(restaurant.companyName)"
            emailLabel.text = restaurant.email
            phoneLabel.text = restaurant.phone
        }
    }
    
    private func setupLoadingIndicator() {
        loadIndicator = createLoadingIndicator(in: waitView)
    }
    
    private func initScreen() {
        profileSettingsViewModel.delegate = self
        configureView(profileImageView, cornerRadius: 5, borderColor: .gray, borderWidth: 0.5)
        setBorder(with: profileView.layer)
        setBorder(with: emailView.layer)
        setBorder(with: phoneView.layer)
        setBorder(with: logoutButton.layer)
        setBorder(with: updateAddressButton.layer)
        setBorder(with: changePasswordButton.layer)
        setBorder(with: editProfileButton.layer)
        setShadow(with: editProfileButton.layer , shadowOffset: true)
        setShadow(with: phoneView.layer, shadowOffset: false)
        
    }

    // MARK: - Actions
    @IBAction func editProfileTapped(_ sender: UIButton) {
        if editProfileViewController == nil {
            editProfileViewController = SB.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController
        }
        if let editProfileVC = editProfileViewController {
            navigationController?.pushViewController(editProfileVC, animated: true)
        }
    }
    
    @IBAction func changePasswordTapped(_ sender: UIButton) {
        if changePasswordViewController == nil {
            changePasswordViewController = SB.instantiateViewController(withIdentifier: "ChangePasswordViewController") as? ChangePasswordViewController
        }
        if let changePasswordVC = changePasswordViewController {
            navigationController?.pushViewController(changePasswordVC, animated: true)
        }
    }

    @IBAction func updateAddressButton(_ sender: UIButton) {
        if mapViewController == nil {
            mapViewController = SB.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController
        }
        if let mapVC = mapViewController {
            mapVC.isFromProfile = true
            mapVC.profileVC = self
            navigationController?.pushViewController(mapVC, animated: true)
        }
        
        
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

