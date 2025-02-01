

import UIKit
class ProductAddedViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productDescriptionTextView: UITextView!
    @IBOutlet weak var oldPriceTextField: UITextField!
    @IBOutlet weak var newPriceTextField: UITextField!
    @IBOutlet weak var saveAndNextButton: UIButton!
    @IBOutlet weak var deliveryTypeSegmentControl: UISegmentedControl!
    @IBOutlet weak var discountSegmentControl: UISegmentedControl!
    @IBOutlet weak var lastTimePicker: UIDatePicker!
    @IBOutlet weak var mealTypeButton: UIButton!
    @IBOutlet weak var selectedMealTypeLabel: UILabel!
    
    var orderViewModel: OrderViewModel!
    var selectedOrder: Order?
    //clli  güncelleme
    var selectedIndexPath: IndexPath?
    private var bottomSheetViewModel: BottomSheetViewModel! //
    // DateFormatter tanımla
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // Saat ve dakika formatı
        return formatter
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Segment değişimini dinle
        deliveryTypeSegmentControl.addTarget(self, action: #selector(deliveryTypeChanged(_:)), for: .valueChanged)
        // Segment değişimini dinlemek için viewDidLoad'a ekle
        discountSegmentControl.addTarget(self, action: #selector(discountSegmentChanged(_:)), for: .valueChanged)
        
        
        // DatePicker'ı saat moduna ayarla (Storyboard'dan da yapılabilir)
        lastTimePicker.datePickerMode = .time
        lastTimePicker.locale = Locale(identifier: "tr_TR") // Türkçe saat formatı
        
        updateSelectedMealTypes([]) // İlk açılışta placeholder göster
        bottomSheetViewModel = BottomSheetViewModel()
        // Eğer düzenliyorsak, önceki seçimleri yükle
        if let order = selectedOrder {
            let selectedIndices = order.mealTypes.compactMap { mealType in
                bottomSheetViewModel.mealTypes.firstIndex { $0 == mealType } // String karşılaştırma yapın!
            }
            bottomSheetViewModel.selectedMealIndices = Set(selectedIndices)
        }
        
        oldPriceTextField.delegate = self
        newPriceTextField.delegate = self
        
        if let order = selectedOrder {
            let selectedIndices = order.mealTypes.compactMap { mealType in
                bottomSheetViewModel.mealTypes.firstIndex { $0 == mealType }
            }
            bottomSheetViewModel.selectedMealIndices = Set(selectedIndices)
            productNameTextField.text = order.name
            productDescriptionTextView.text = order.description
            oldPriceTextField.text = "\(order.oldPrice) TL"
            newPriceTextField.text = "\(order.newPrice) TL"
         
            discountSegmentControl.selectedSegmentIndex = order.discountType
            lastTimePicker.date = order.endTime
            
            updateSelectedMealTypes(order.mealTypes) // Yemek türlerini yükle
            
        }
        
        
        configureGestures()
        configureImageViewTap()
    }
    
    private func configureGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func configureImageViewTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        selectedImageView.isUserInteractionEnabled = true
        selectedImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func selectImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.present(imagePickerController, animated: true, completion: nil)
        } else {
            print("Fotoğraf kütüphanesi erişilemiyor.")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return true }
        let newString = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if let number = Int(newString.filter({ $0.isNumber })) {
            textField.text = "\(number) TL"
        } else if newString.isEmpty {
            textField.text = ""
        }
        
        return false
    }
    
    
    @IBAction func saveAndNextButtonClicked(_ sender: UIButton) {
        // Seçilen segmentin başlığını al
            let deliveryTypeIndex = deliveryTypeSegmentControl.selectedSegmentIndex
            let deliveryTypeTitle = deliveryTypeSegmentControl.titleForSegment(at: deliveryTypeIndex) ?? ""
             
        // Seçilen saati al
        let selectedTime = lastTimePicker.date
        // Formatlı şekilde konsola yaz
        let formattedTime = dateFormatter.string(from: selectedTime)
        print("Seçilen saat: \(formattedTime)")
        let name = productNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let description = productDescriptionTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let oldPriceText = oldPriceTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " TL", with: "") ?? ""
        let newPriceText = newPriceTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " TL", with: "") ?? ""
        
        guard !name.isEmpty,
              !description.isEmpty,
              !oldPriceText.isEmpty,
              !newPriceText.isEmpty,
              let oldPrice = Int(oldPriceText),
              let newPrice = Int(newPriceText),
              let foodImage = selectedImageView.image else {
            showAlert(message: "Lütfen tüm alanları doldurun.")
            return
        }
        let selectedMeals = bottomSheetViewModel.selectedMealIndices.map {
            bottomSheetViewModel.mealTypes[$0]
        }
        let updatedOrder = Order(
            name: name,
            description: description,
            oldPrice: oldPrice,
            newPrice: newPrice,
            deliveryTypeTitle: deliveryTypeTitle,
            discountType: discountSegmentControl.selectedSegmentIndex,
            endTime: selectedTime,
            foodImage: foodImage,
            orderStatus: .preparing,
            mealTypes: selectedMeals //
        )
        print("Teslim Türü: \(deliveryTypeTitle)")
        if let indexPath = selectedIndexPath {
            orderViewModel.updateOrder(at: indexPath.row, with: updatedOrder)
        } else {
            orderViewModel.addOrder(updatedOrder)
        }
        
        
        navigationController?.popViewController(animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
    
    
    @IBAction func mealTypeButtonClicked(_ sender: UIButton) {
        let bottomSheetVC = BottomSheetViewController(viewModel: bottomSheetViewModel)
        bottomSheetVC.onDismissWithSelectedMeals = { [weak self] selectedMeals in
            self?.updateSelectedMealTypes(selectedMeals)
        }
        
        let navController = UINavigationController(rootViewController: bottomSheetVC)
        navController.modalPresentationStyle = .pageSheet
        if let sheet = navController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        present(navController, animated: true)
    }
    private func updateSelectedMealTypes(_ meals: [String]) {
        if meals.isEmpty {
            selectedMealTypeLabel.text = "Yemek Türü Seçiniz"
            selectedMealTypeLabel.textColor = .lightGray
        } else {
            selectedMealTypeLabel.text = meals.joined(separator: ", ")
            selectedMealTypeLabel.textColor = .black
        }
    }
    @objc func discountSegmentChanged(_ sender: UISegmentedControl) {
        // Eski fiyatı al ve kontrol et
        guard let oldPriceText = oldPriceTextField.text?.replacingOccurrences(of: " TL", with: ""),
              let oldPrice = Int(oldPriceText) else {
            showAlert(message: "Lütfen önce normal fiyatı giriniz.")
            return
        }
        
        // Segment başlığından yüzdeyi çıkar
        let selectedTitle = sender.titleForSegment(at: sender.selectedSegmentIndex) ?? ""
        let percentageString = selectedTitle.filter { $0.isNumber }
        guard let discountPercentage = Int(percentageString) else { return }
        
        // Yeni fiyatı hesapla
        let discountRate = Double(discountPercentage) / 100.0
        let newPrice = Int(Double(oldPrice) * (1.0 - discountRate))
        newPriceTextField.text = "\(newPrice) TL"
        
        // Konsola yazdır
        print("Normal Fiyat:\(oldPrice) TL İndirim Oranı:%\(discountPercentage) Yeni Fiyat: \(newPrice) TL")
    }
    // UITextFieldDelegate metodlarını ekleyin
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == newPriceTextField {
            // Elle giriş yapılıyorsa segment seçimini sıfırla
            discountSegmentControl.selectedSegmentIndex = UISegmentedControl.noSegment
        }
    }
    @objc func deliveryTypeChanged(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        let selectedTitle = sender.titleForSegment(at: selectedIndex) ?? ""
        print("Seçilen teslim türü: \(selectedTitle)")
    }
}

