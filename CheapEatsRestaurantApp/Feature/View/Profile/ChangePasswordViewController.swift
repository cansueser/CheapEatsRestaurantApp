//
//  ChangePasswordViewController.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 7.06.2025.
//

import UIKit
import NVActivityIndicatorView

final class ChangePasswordViewController: UIViewController {
    // MARK: - Variables
    @IBOutlet private weak var currentPasswordTextField: UITextField!
    @IBOutlet private weak var newPasswordTextField: UITextField!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet weak var waitView: UIView!
    @IBOutlet weak var passwordView: UIView!
    
    private var loadIndicator: NVActivityIndicatorView!
    var changePasswordViewModel: ChangePasswordViewModelProtocol = ChangePasswordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initScreen()
        setupLoadingIndicator()
    }
    
    func initScreen() {
        changePasswordViewModel.delegate = self
        passwordView.layer.cornerRadius = 10
        passwordView.layer.masksToBounds = true
        saveButton.layer.cornerRadius = 5
        setShadow(with: passwordView.layer, shadowOffset: true)
    }
    
    private func setupLoadingIndicator() {
        loadIndicator = createLoadingIndicator(in: waitView)
    }
    
    // MARK: - Actions
    
    @IBAction func currentEyeButtonClicked(_ sender: UIButton) {
        currentPasswordTextField.togglePasswordVisibility()
        if currentPasswordTextField.isSecureTextEntry {
            sender.setImage(UIImage(systemName: "eye"), for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
    }
    
    @IBAction func newEyeButtonClicked(_ sender: UIButton) {
        newPasswordTextField.togglePasswordVisibility()
        if newPasswordTextField.isSecureTextEntry {
            sender.setImage(UIImage(systemName: "eye"), for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let currentPassword = currentPasswordTextField.text, !currentPassword.isEmpty,
              let newPassword = newPasswordTextField.text, !newPassword.isEmpty else {
            showOneButtonAlert(title: "Hata", message: "Mevcut şifre veya yeni şifre boş olamaz!")
            return
        }
        if newPassword.count < 6 {
            showOneButtonAlert(title: "Hata", message: "Yeni şifre 6 karakterden küçük olamaz!")
            return
        }
        changePasswordViewModel.changePassword(currentPassword: currentPassword, newPassword: newPassword)
    }
}

extension ChangePasswordViewController: ChangePasswordViewModelOutputProtocol {
    func update() {
        print("update")
        showOneButtonAlert(title: "Uyarı", message: "Şifre değiştirme işlemi başarılı bir şekilde gerçekleşti.", buttonTitle: "Tamam") { _ in
            self.navigationController?.popViewController(animated: true)
        }
        currentPasswordTextField.text = ""
        newPasswordTextField.text = ""
        
    }
    
    func error() {
        print("error")
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

