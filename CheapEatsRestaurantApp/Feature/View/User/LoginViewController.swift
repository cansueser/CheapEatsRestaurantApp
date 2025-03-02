//
//  LoginViewController.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 2.03.2025.
//
import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import JVFloatLabeledTextField

final class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailBackView: UIView!
    @IBOutlet weak var passwordBackView: UIView!
    @IBOutlet weak var emailTextField: JVFloatLabeledTextField!
    @IBOutlet weak var passwordTextField: JVFloatLabeledTextField!
    @IBOutlet weak var emailImage: UIImageView!
    @IBOutlet weak var passwordImage: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var securityIcon: UIButton!
    //MARK: - Variables
    var loginViewModel: LoginViewModelProtocol = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initScreen()
    }
    func initScreen() {
        loginViewModel.delegate = self
        emailImage.makeRounded(radius: 5)
        passwordImage.makeRounded(radius: 5)
        emailBackView.addRoundedBorder(cornerRadius: 2,borderWidth: 1, borderColor: .iconBG)
        passwordBackView.addRoundedBorder(cornerRadius: 2,borderWidth: 1, borderColor: .iconBG)
    }
    var iconClick = true
    @IBAction func securityIconClicked(_ sender: Any) {
        if iconClick {
            passwordTextField.isSecureTextEntry = false
            securityIcon.setImage(<#T##image: UIImage?##UIImage?#>, for: <#T##UIControl.State#>)
        }
        else{
            passwordTextField.isSecureTextEntry = true
        }
        iconClick = !iconClick
        
    }


    @IBAction func loginButtonClicked(_ sender: Any) {
       
        if let email = emailTextField.text,
           let password = passwordTextField.text {
            let user = UserLogin(email: email, password: password)
            loginViewModel.loginUser(user: user, password: password)
            print("doğru")
        }
        
       
        else{
            print("bilgiler hatalı")
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginVC = storyboard.instantiateViewController(withIdentifier: "RegisterViewControllerID") as? RegisterViewController{
            navigationController?.pushViewController(loginVC, animated: true)}
        else{
            print("geçiş yapılamadı")
        }
    }
    
}
extension LoginViewController: LoginViewModelOutputProtocol {
    func update() {
        print("Update")
    }
    
    func error() {
        print("Error")
    }
    
    
}
