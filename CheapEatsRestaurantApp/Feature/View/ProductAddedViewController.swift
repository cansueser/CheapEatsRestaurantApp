import UIKit

class ProductAddedViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate{
    
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productDescriptionTextView: UITextView!
    @IBOutlet weak var oldPriceTextField: UITextField!
    @IBOutlet weak var newPriceTextField: UITextField!
    @IBOutlet weak var saveAndNextButton: UIButton!
    @IBOutlet weak var deliveryTypeSegmentControl: UISegmentedControl!
    @IBOutlet weak var discountSegmentControl: UISegmentedControl!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var lastTimePicker: UIDatePicker!
    
    @IBOutlet weak var placeholderLabel: UILabel!
    
    
    weak var delegate: FilterTypeViewModelOutputProtocol?
    var filterTypeViewModel: FilterTypeViewModelProtocol = FilterTypeViewModel()
    private var viewModel: TimeViewModel!
    let DescplaceholderLabel = UILabel()
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
        
        // ViewModel'i başlat
        viewModel = TimeViewModel()
        
        // DatePicker ayarları
        startTimePicker.datePickerMode = .time
        lastTimePicker.datePickerMode = .time
        
        if #available(iOS 14, *) {
            startTimePicker.preferredDatePickerStyle = .wheels
            lastTimePicker.preferredDatePickerStyle = .wheels
        }
        placeholderLabel.text = "Açıklamayı buraya yazın..."


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

        
               let name = productNameTextField.text!
               let description = productDescriptionTextView.text!
               let oldPrice = Double(oldPriceTextField.text!) ?? 0
               let newPrice = Double(newPriceTextField.text!) ?? 0
               let foodImage = selectedImageView.image ?? UIImage()
               
               // Yeni ürünü oluşturma
        let newOrder = Order(name: name, description: description, oldPrice: oldPrice, newPrice: newPrice, deliveryType: 1, discountType: 1, startTime: Date(), endTime: Date(), foodImage: foodImage, orderStatus: .preparing)
               
               // Veriyi ekleyin ve geri dönün
               if let navigationController = self.navigationController {
                   let orderViewController = navigationController.viewControllers.first as! OrderViewController
                   orderViewController.orders.append(newOrder)  // Yeni ürünü ana sayfaya ekliyoruz
                   orderViewController.orderTableView.reloadData()  // TableView'ı güncelleyerek gösteriyoruz
               }
               
               // Geri dön
               navigationController?.popViewController(animated: true)
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
    @IBAction func startTimePickerChanged(_ sender: UIDatePicker) {
            viewModel.updateTime1(sender.date)
        }
        
        @IBAction func lastTimePicker2Changed(_ sender: UIDatePicker) {
            viewModel.updateTime2(sender.date)
        }
        
    
}

    
