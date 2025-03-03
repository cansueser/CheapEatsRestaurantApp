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
    let SB = UIStoryboard(name: "Main", bundle: nil)
    private var registerVC: RegisterViewController?
    private var tabBarVC: UITabBarController?
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
    
    @IBAction func securityIconClicked(_ sender: UIButton) {
        passwordTextField.togglePasswordVisibility()
        if passwordTextField.isSecureTextEntry {
            sender.setImage(UIImage(systemName: "eye"), for: .normal)
        } else{
            sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
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
    }
    
    @IBAction func registerButtonClicked(_ sender: UIButton) {
        if registerVC == nil {
            registerVC = SB.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController
        }
        
        if let registerVC = registerVC {
            navigationController?.pushViewController(registerVC, animated: true)
        }
    }
    
}
extension LoginViewController: LoginViewModelOutputProtocol {
    func update() {
        print("Update")
        if tabBarVC == nil {
            navigationController?.navigationBar.isHidden = true
            tabBarVC = SB.instantiateViewController(identifier: "TabBarController") as? UITabBarController
        }
      if let tabBarVC = tabBarVC {
          navigationController?.navigationBar.isHidden = true
          navigationController?.pushViewController(tabBarVC, animated: true)
        }
    }
    
    func error() {
        print("Error")
    }
    
    
}
