import UIKit

class ProductAddedViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productDescriptionTextField: UITextField!
    @IBOutlet weak var oldPriceTextField: UITextField!
    @IBOutlet weak var newPriceTextField: UITextField!
    @IBOutlet weak var saveAndNextButton: UIButton!
    @IBOutlet weak var deliveryTypeSegmentControl: UISegmentedControl!
    @IBOutlet weak var discountSegmentControl: UISegmentedControl!
    weak var delegate: FilterTypeViewModelOutputProtocol?
    var filterTypeViewModel: FilterTypeViewModelProtocol = FilterTypeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Tıklanabilirlik
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        selectedImageView.isUserInteractionEnabled = true
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        selectedImageView.addGestureRecognizer(imageTapRecognizer)
        // TextField Delegate'lerini ayarla
             oldPriceTextField.delegate = self
             newPriceTextField.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        deliveryTypeSegmentControl.selectedSegmentIndex = filterTypeViewModel.selectedDeliveryType
        discountSegmentControl.selectedSegmentIndex = filterTypeViewModel.selectedDiscount
    }
    @objc func selectImage() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectedImageView.image = info[.originalImage] as? UIImage
        // saveButton.isEnabled = true
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func saveAndNextButton(_ sender: UIButton) {
        
           // Tüm alanları kontrol et
           if let text1 = productNameTextField.text, !text1.isEmpty,
              let text2 = productDescriptionTextField.text, !text2.isEmpty,
              let text3 = oldPriceTextField.text, !text3.isEmpty,
              let text4 = newPriceTextField.text, !text4.isEmpty {
               
               // Hepsi doluysa konsola yazdır
               print("TextField1: \(text1)")
               print("TextField2: \(text2)")
               print("TextField3: \(text3)")
               print("TextField4: \(text4)")
           } else {
               // Eğer birisi boşsa hata mesajı
               showAlert(message: "Lütfen tüm alanları doldurun!")
           }
       }

       private func showAlert(message: String) {
           let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
           present(alert, animated: true, completion: nil)
       }
    // Sadece sayı girişine izin veren bir kontrol
      func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
          let allowedCharacters = CharacterSet.decimalDigits
          let characterSet = CharacterSet(charactersIn: string)
          return allowedCharacters.isSuperset(of: characterSet)
      }
    
    @IBAction func deliveryTypeSegmentChanged(_ sender: UISegmentedControl) {
        filterTypeViewModel.selectedDeliveryType = sender.selectedSegmentIndex
        print(sender.selectedSegmentIndex)
       }
   
    @IBAction func discountSegmentControlChanged(_ sender: UISegmentedControl) {
        filterTypeViewModel.selectedDiscount = sender.selectedSegmentIndex
        print(sender.selectedSegmentIndex)
        
    }
    
}

    
