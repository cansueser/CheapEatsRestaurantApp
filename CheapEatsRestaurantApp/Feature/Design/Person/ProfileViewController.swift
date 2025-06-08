//
//  ProfileViewController.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 5.06.2025.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, ProfileViewModelOutputProtocol {
    
    @IBOutlet weak var restaurantNameTextField: UITextField!
    @IBOutlet weak var ownerNameTextField: UITextField!
    @IBOutlet weak var ownerSurnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
  private let viewModel: ProfileViewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchProfileData()
    }
    
    private func setupUI() {
        saveButton.layer.cornerRadius = 8
        saveButton.clipsToBounds = true
        saveButton.backgroundColor = UIColor(named: "ButtonColor")
    }
    
    private func bindViewModel() {
        viewModel.output = self
    }
    
    private func updateUI() {
        restaurantNameTextField.text = viewModel.profile.restaurantName
        ownerNameTextField.text = viewModel.profile.ownerName
        ownerSurnameTextField.text = viewModel.profile.ownerSurname
        emailTextField.text = viewModel.profile.email
        phoneTextField.text = viewModel.profile.phone
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard validateInputs() else { return }
        saveButton.isEnabled = false
        
        viewModel.updateProfile(
            restaurantName: restaurantNameTextField.text ?? "",
            ownerName: ownerNameTextField.text ?? "",
            ownerSurname: ownerSurnameTextField.text ?? "",
            email: emailTextField.text ?? "",
            phone: phoneTextField.text ?? ""
        )
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        NetworkManager.shared.logout { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success:
                    // Giriş ekranına yönlendir
                    if let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") {
                        loginVC.modalPresentationStyle = .fullScreen
                        self.present(loginVC, animated: true)
                    }
                case .failure(let error):
                    self.showAlert(title: "Hata", message: "Çıkış yapılamadı: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func validateInputs() -> Bool {
        // Boş alan kontrolü
        guard let restaurantName = restaurantNameTextField.text, !restaurantName.isEmpty else {
            showAlert(title: "Eksik Bilgi", message: "Lütfen restoran adını girin")
            return false
        }
        
        guard let ownerName = ownerNameTextField.text, !ownerName.isEmpty else {
            showAlert(title: "Eksik Bilgi", message: "Lütfen sahip adını girin")
            return false
        }
        
        guard let ownerSurname = ownerSurnameTextField.text, !ownerSurname.isEmpty else {
            showAlert(title: "Eksik Bilgi", message: "Lütfen sahip soyadını girin")
            return false
        }
        
        // E-posta ve telefon doğrulama
        guard let email = emailTextField.text, viewModel.isValidEmail(email) else {
            showAlert(title: "Geçersiz E-posta", message: "Lütfen geçerli bir e-posta adresi girin")
            return false
        }
        
        guard let phone = phoneTextField.text, viewModel.isValidPhone(phone) else {
            showAlert(title: "Geçersiz Telefon", message: "Lütfen geçerli bir telefon numarası girin")
            return false
        }
        
        return true
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - ProfileViewModelOutputProtocol
    
    func onProfileUpdated(profile: ProfileModel) {
        DispatchQueue.main.async {
            self.updateUI()
        }
    }
    
    func onError(message: String) {
        DispatchQueue.main.async {
            self.showAlert(title: "Hata", message: message)
            self.saveButton.isEnabled = true
        }
    }
    
    func onSaveSuccess() {
        DispatchQueue.main.async {
            self.saveButton.isEnabled = true
            self.showAlert(title: "Başarılı", message: "Profil bilgileri güncellendi")
        }
    }
}
