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
import NVActivityIndicatorView

final class LoginViewController: UIViewController {
    //MARK: - Variables
    @IBOutlet weak var emailBackView: UIView!
    @IBOutlet weak var passwordBackView: UIView!
    @IBOutlet weak var emailTextField: JVFloatLabeledTextField!
    @IBOutlet weak var passwordTextField: JVFloatLabeledTextField!
    @IBOutlet weak var emailImage: UIImageView!
    @IBOutlet weak var passwordImage: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var securityIcon: UIButton!
    @IBOutlet weak var resetPassword: UIButton!
    @IBOutlet weak var ImageBackView: CustomLineView!
    @IBOutlet weak var girisYapLabel: UILabel!
    @IBOutlet weak var waitView: UIView!
    
    var loginViewModel: LoginViewModelProtocol = LoginViewModel()
    private var loadIndicator: NVActivityIndicatorView!
    let SB = UIStoryboard(name: "Main", bundle: nil)
    private var registerVC: RegisterViewController?
    private var tabBarVC: UITabBarController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initScreen()
        setupLoadingIndicator()
    }
    
    
    func initScreen() {
        loginViewModel.delegate = self
        ImageBackView.setNeedsDisplay()
        ImageBackView.lineYPosition = girisYapLabel.frame.origin.y+40
        emailImage.makeRounded(radius: 5)
        passwordImage.makeRounded(radius: 5)
        emailBackView.addRoundedBorder(cornerRadius: 2,borderWidth: 1, borderColor: .iconBG)
        passwordBackView.addRoundedBorder(cornerRadius: 2,borderWidth: 1, borderColor: .iconBG)
        loginButton.makeRounded(radius: 5)
    }
    
    private func setupLoadingIndicator() {
        loadIndicator = createLoadingIndicator(in: waitView)
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
        guard let email = emailTextField.text,
           let password = passwordTextField.text else {
               return
        }
        loginViewModel.loginUser(email: email, password: password)
        print("doğru")
    }
    
    @IBAction func registerButtonClicked(_ sender: UIButton) {
        if registerVC == nil {
            registerVC = SB.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController
        }
        
        if let registerVC = registerVC {
            navigationController?.pushViewController(registerVC, animated: true)
        }
    }
    
    @IBAction func resetPasswordButtonClicked(_ sender: UIButton) {
        Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) { error in
            DispatchQueue.main.async {
                if error != nil {
                    let resetFailedAlert = UIAlertController(title: "Sıfırlama Başarısız", message: "Error(E-postanızı doğru giriniz ve tekrar deneyiniz) : \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                    resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetFailedAlert, animated: true, completion: nil)
                }else{
                    if error == nil && self.emailTextField.text?.isEmpty==false{
                        let resetEmailAlertSent = UIAlertController(title: "Sıfırlama E-postası Gönderildi.", message: "Giriş e-postanıza sıfırlama e-postası gönderildi, lütfen şifrenizi sıfırlamak için e-postadaki talimatları izleyin.", preferredStyle: .alert)
                        resetEmailAlertSent.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(resetEmailAlertSent, animated: true, completion: nil)}
                    let resetEmailAlertSent = UIAlertController(title: "Sıfırlama E-postası Gönderildi.", message: "Giriş e-postanıza sıfırlama e-postası gönderildi, lütfen şifrenizi sıfırlamak için e-postadaki talimatları izleyin.", preferredStyle: .alert)
                    resetEmailAlertSent.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetEmailAlertSent, animated: true, completion: nil)
                }
            }
        }
    }
}
extension LoginViewController: LoginViewModelOutputProtocol {
    func update() {
        print("Update")
        print(RestaurantManager.shared.getRestaurantId())
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
