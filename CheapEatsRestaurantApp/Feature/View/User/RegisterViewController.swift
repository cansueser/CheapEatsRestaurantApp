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
    //MARK: - Variables
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
    @IBOutlet weak var logoBackView: CustomLineView!
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet var registerBackView: CustomLineView!
    
    @IBOutlet weak var kayıtolLabel: UILabel!
    var registerViewModel: RegisterViewModelProtocol = RegisterViewModel()
    private var mapVC: MapViewController?
    let SB = UIStoryboard(name: "Main", bundle: nil)
    private var tabBarVC: UITabBarController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initScreen()
        NotificationCenter.default.addObserver(self, selector: #selector(mapUpdated(_:)), name: NSNotification.Name("MapUpdated"), object: nil)
    }
    @objc func mapUpdated(_ notification: Notification){
        if let mapLocation = notification.object as? MapLocation {
            addressLabel.text = mapLocation.getAddress()
            registerViewModel.mapLocation = mapLocation
        }
    }
    func initScreen() {
        registerViewModel.delegate = self
        registerBackView.setNeedsDisplay()
        logoBackView.lineYPosition = kayıtolLabel.frame.origin.y+40
      registerBackView.setNeedsDisplay()
       registerBackView.lineYPosition = addressLabel.frame.origin.y-10
        userImage.makeRounded(radius: 5)
        phoneImage.makeRounded(radius: 5)
        mailImage.makeRounded(radius: 5)
        passwordImage.makeRounded(radius: 5)
         companyImage.makeRounded(radius: 5)
        registerButoon.makeRounded(radius: 5)
        userNameBackView.addRoundedBorder(cornerRadius: 2,borderWidth: 1, borderColor: .iconBG)
        phoneBackView.addRoundedBorder(cornerRadius: 2,borderWidth: 1, borderColor: .iconBG)
        mailBackView.addRoundedBorder(cornerRadius: 2,borderWidth: 1, borderColor: .iconBG)
        passwordBackView.addRoundedBorder(cornerRadius: 2,borderWidth: 1, borderColor: .iconBG)
         companyBackView.addRoundedBorder(cornerRadius: 2,borderWidth: 1, borderColor: .iconBG)
    }

    @IBAction func registerButtonClicked(_ sender: UIButton) {
        guard let ownerName = nameTextField.text,
           let ownerSurname = surnameTextField.text,
           let phone = phoneNumberTextField.text,
           let companyname = companyNameTextField.text,
           let email = emailTextField.text,
           let password = passwordTextField.text else {
            print("hata")
            return }
        // E-posta doğrulama
         do {
             try registerViewModel.validateEmail(email)
         } catch EmailValidationError.empty {
             showOneButtonAlert(title: "Hata", message: "E-posta adresi boş olamaz.")
             return
         } catch EmailValidationError.invalidFormat {
             showOneButtonAlert(title: "Hata", message: "Geçersiz e-posta formatı.")
             return
         } catch EmailValidationError.domainNotAllowed {
             showOneButtonAlert(title: "Hata", message: "Bu e-posta domaini izinli değil.")
             return
         } catch {
             showOneButtonAlert(title: "Hata", message: "Bilinmeyen bir hata oluştu.")
             return
         }

        guard let mapLocation = registerViewModel.mapLocation else {
            print("harita ekranından konum seçmediniz")
            return
        }
        
        let restaurant = Restaurant(ownerName: ownerName, ownerSurname: ownerSurname, email: email, phone: phone, address: mapLocation.getAddress(), companyName: companyname, location: Location(latitude: mapLocation.latitude, longitude: mapLocation.longitude))
        setRestaurant(restaurant: restaurant, password: password)
        
    }
    func setRestaurant(restaurant: Restaurant, password: String) {
        registerViewModel.registerRestaurant(restaurant: restaurant, password: password)
    }
    
    @IBAction func addressButtonClicked(_ sender: UIButton) {
        if mapVC == nil{
            mapVC = SB.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController
        }
        
        if let mapVC = mapVC {
            mapVC.registerVC = self
            navigationController?.pushViewController(mapVC, animated: true)
        }
    }
    
   
}
extension RegisterViewController: RegisterViewModelOutputProtocol {
    func update() {
        navigationController?.popViewController(animated: true)
    }
    
    func error() {
        print("Kayıt başarısız")
    }
}
