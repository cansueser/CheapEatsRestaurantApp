//
//  Register.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 1.03.2025.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import JVFloatLabeledTextField
      
final class RegisterViewController: UIViewController {

    @IBOutlet weak var nameTextField: JVFloatLabeledTextField!
    @IBOutlet weak var surnameTextField: JVFloatLabeledTextField!
    @IBOutlet weak var phoneNumberTextField: JVFloatLabeledTextField!
    @IBOutlet weak var emailTextField: JVFloatLabeledTextField!
    @IBOutlet weak var passwordTextField: JVFloatLabeledTextField!
    @IBOutlet weak var companyNameTextField: JVFloatLabeledTextField!
    @IBOutlet weak var registerButoon: UIButton!
    @IBOutlet weak var userNameBackView: UIView!
    @IBOutlet weak var phoneBackView: UIView!
    @IBOutlet weak var mailBackView: UIView!
    @IBOutlet weak var passwordBackView: UIView!
    @IBOutlet weak var companyBackView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var phoneImage: UIImageView!
    @IBOutlet weak var mailImage: UIImageView!
    @IBOutlet weak var passwordImage: UIImageView!
    @IBOutlet weak var companyImage: UIImageView!
    @IBOutlet weak var logoBackView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    //MARK: - Variables
    var registerViewModel: RegisterViewModelProtocol = RegisterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initScreen()
    }

    func initScreen() {
        registerViewModel.delegate = self
        userImage.makeRounded(radius: 5)
        phoneImage.makeRounded(radius: 5)
        mailImage.makeRounded(radius: 5)
        passwordImage.makeRounded(radius: 5)
         companyImage.makeRounded(radius: 5)
        userNameBackView.addRoundedBorder(cornerRadius: 2,borderWidth: 1, borderColor: .iconBG)
        phoneBackView.addRoundedBorder(cornerRadius: 2,borderWidth: 1, borderColor: .iconBG)
        mailBackView.addRoundedBorder(cornerRadius: 2,borderWidth: 1, borderColor: .iconBG)
        passwordBackView.addRoundedBorder(cornerRadius: 2,borderWidth: 1, borderColor: .iconBG)
         companyBackView.addRoundedBorder(cornerRadius: 2,borderWidth: 1, borderColor: .iconBG)
    }
    
    @IBAction func registerButtonClicked(_ sender: UIButton) {
        if let ownerName = nameTextField.text,
           let ownerSurname = surnameTextField.text,
           let phone = phoneNumberTextField.text,
           let address = addressLabel.text,
           let companyname = companyNameTextField.text,
           let email = emailTextField.text,
           let password = passwordTextField.text {
            let restaurant = Restaurant(ownerName: ownerName, ownerSurname: ownerSurname, email: email, phone: phone, address: address, companyName: companyname, location: Location(latitude: 0, longitude: 0))
            setRestaurant(restaurant: restaurant, password: password)
        }
        else{
            print("hata")
            
        }
        
    }
    func setRestaurant(restaurant: Restaurant, password: String) {
        registerViewModel.registerRestaurant(restaurant: restaurant, password: password)
    }
}
extension RegisterViewController: RegisterViewModelOutputProtocol {
    func update() {
        print("Update")
    }
    
    func error() {
        print("Error")
    }
    
    
}
