//
//  EditProfileViewController.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 7.06.2025.
//

import UIKit
import NVActivityIndicatorView

final class EditProfileViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var companyNameTextField: UITextField!
    @IBOutlet private weak var ownerNameTextField: UITextField!
    @IBOutlet private weak var ownerSurnameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var phoneTextField: UITextField!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet weak var waitView: UIView!
    @IBOutlet weak var editView: UIView!
    
    private var loadIndicator: NVActivityIndicatorView!
    var editProfileViewModel: EditProfileViewModelProtocol = EditProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initScreen()
        setupTextFieldObservers()
        setupLoadingIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateButtonState()
    }
    
    private func setupLoadingIndicator() {
        loadIndicator = createLoadingIndicator(in: waitView)
    }
    
    func initScreen() {
        editProfileViewModel.delegate = self
        editView.layer.cornerRadius = 10
        editView.layer.masksToBounds = true
        saveButton.layer.cornerRadius = 5
        setShadow(with: editView.layer, shadowOffset: true)
        updateButtonState()
    }
    
    func initData() {
        if let restaurant = editProfileViewModel.restaurant {
            companyNameTextField.text = restaurant.companyName
            ownerNameTextField.text = restaurant.ownerName
            ownerSurnameTextField.text = restaurant.ownerSurname
            phoneTextField.text = restaurant.phone
            emailTextField.text = restaurant.email
        }
    }
    
    private func setupTextFieldObservers() {
        companyNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        ownerNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        ownerSurnameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        phoneTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        updateButtonState()
    }
    
    private func updateButtonState() {
        let hasChanges = editProfileViewModel.checkForChanges(
            companyName: companyNameTextField.text,
            name: ownerNameTextField.text,
            surname: ownerSurnameTextField.text,
            email: emailTextField.text,
            phone: phoneTextField.text
        )
        saveButton.isEnabled = hasChanges
        saveButton.alpha = hasChanges ? 1.0 : 0.5
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        editProfileViewModel.updateRestaurantInfo(
            companyName: companyNameTextField.text,
            name: ownerNameTextField.text,
            surname: ownerSurnameTextField.text,
            email: emailTextField.text,
            phone: phoneTextField.text
        )
    }
}

extension EditProfileViewController: EditProfileViewModelOutputProtocol {
    func update() {
        print("update")
        navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name("RestaurantProfileUpdated"), object: nil)
    }
    
    func error() {
        print("error")
    }
    
    func updateButtonState(isEnabled: Bool) {
        saveButton.isEnabled = isEnabled
        saveButton.alpha = isEnabled ? 1.0 : 0.5
    }
    
    func startLoading() {
        waitView.isHidden = false
        loadIndicator.isHidden = false
        loadIndicator.startAnimating()
    }
    
    func stopLoading() {
        waitView.isHidden = true
        loadIndicator.isHidden = true
        loadIndicator.stopAnimating()
    }
    
}
