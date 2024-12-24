import UIKit

class ProductEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    // UI Bileşenleri
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productDescriptionTextView: UITextView!
    @IBOutlet weak var oldPriceTextField: UITextField!
    @IBOutlet weak var newPriceTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    // ViewModel
    var viewModel: ProductEditViewModel!
    
    var productMode: ProductMode = .add
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Eğer edit modunda isek ViewModel'i initialize et
        if case .edit(let existingProduct) = productMode {
            viewModel = ProductEditViewModel(product: existingProduct)
        }
        
        setupUI()
    }
    
    private func setupUI() {
        if case .edit = productMode {
            // Edit modunda ise mevcut ürün verilerini al ve UI'ı güncelle
            productNameTextField.text = viewModel.getProductName()
            productDescriptionTextView.text = viewModel.getProductDescription()
            oldPriceTextField.text = viewModel.getOldPrice()
            newPriceTextField.text = viewModel.getNewPrice()
            selectedImageView.image = viewModel.getProductImage()
        }
        
        // Image picker setup
        selectedImageView.isUserInteractionEnabled = true
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        selectedImageView.addGestureRecognizer(imageTapRecognizer)
        
        // TextField ve TextView delegate'lerini ayarla
        productNameTextField.delegate = self
        oldPriceTextField.delegate = self
        newPriceTextField.delegate = self
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
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        // UI Bileşenlerinden gelen verileri ViewModel'e gönder
        let name = productNameTextField.text!
        let description = productDescriptionTextView.text!
        let oldPrice = Double(oldPriceTextField.text!) ?? 0
        let newPrice = Double(newPriceTextField.text!) ?? 0
        let foodImage = selectedImageView.image ?? UIImage()
        
        // ViewModel'deki updateProduct metodunu çağırarak ürünü güncelle
        viewModel.updateProduct(name: name, description: description, oldPrice: oldPrice, newPrice: newPrice, foodImage: foodImage)
        
        // Başarılı bir şekilde kaydedildiğinde, kullanıcıya bildirim göster
        showAlert(message: "Ürün başarıyla güncellendi!")
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Mesaj", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
