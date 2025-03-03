//
//  ForgetPasswordViewController.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 4.03.2025.
//

import UIKit
import JVFloatLabeledTextField
import FirebaseAuth

final class ResetPasswordViewController: UIViewController {
    //MARK: -Variables
    @IBOutlet weak var emailTextField: JVFloatLabeledTextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var passwordResetViewModel: ResetPasswordViewModelProtocol = ResetPasswordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func sendButtonClicked(_ sender: UIButton) {
        Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) { error in
            DispatchQueue.main.async {
                if error != nil {
                    let resetFailedAlert = UIAlertController(title: "Reset Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                    resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetFailedAlert, animated: true, completion: nil)
                }else{
                    if error == nil && self.emailTextField.text?.isEmpty==false{
                                        let resetEmailAlertSent = UIAlertController(title: "Reset Email Sent", message: "Reset email has been sent to your login email, please follow the instructions in the mail to reset your password", preferredStyle: .alert)
                                        resetEmailAlertSent.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                        self.present(resetEmailAlertSent, animated: true, completion: nil)
                                    }
                                        let resetEmailAlertSent = UIAlertController(title: "Reset Email Sent", message: "Reset email has been sent to your login email, please follow the instructions in the mail to reset your password", preferredStyle: .alert)
                                        resetEmailAlertSent.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                        self.present(resetEmailAlertSent, animated: true, completion: nil)
                                    }
            }
        }
    }
}
       /* if let email = emailTextField.text{
            passwordResetViewModel.resetPassword(email: email)
            print("Resetleme doğru.")
        }
        else{
            print("Resetleme yanlış.")
        }
        */
    


