import UIKit
import Cloudinary
import Kingfisher
import PhotosUI
import EasyTipView

class ProductAddedViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UIToolTipInteractionDelegate ,EasyTipViewDelegate {
    func easyTipViewDidTap(_ tipView: EasyTipView) {
        tipView.dismiss()
    }
   
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        preferences.animating.dismissTransform = CGAffineTransform(translationX: 0, y: -15)
        preferences.animating.showInitialTransform = CGAffineTransform(translationX: 0, y: -15)
        preferences.animating.showInitialAlpha = 0
        preferences.animating.showDuration = 1.5
        preferences.animating.dismissDuration = 1.5    }
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
    @IBOutlet weak var selectedImageView: CLDUIImageView!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view6: UIView!
    @IBOutlet weak var view7: UIView!
    @IBOutlet weak var view8: UIView!
    
    
    
    let cloudName: String = "djsg1qqv3"
    var uploadPreset: String = "ml_Resim"
    var cloudinary: CLDCloudinary!
    var toImage: String?
    var orderViewModel: OrderViewModel = OrderViewModel()
    var selectedOrder: Order?
    var selectedIndexPath: IndexPath?
    var preferences = EasyTipView.Preferences()
    var tipView: EasyTipView?
    private var bottomSheetViewModel: BottomSheetViewModel = BottomSheetViewModel() //
    // DateFormatter tanımla
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // Saat ve dakika formatı
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: - VİEW AYARLAMA
        view1.addRoundedBorder()
        view2.addRoundedBorder()
        view3.addRoundedBorder()
        view4.addRoundedBorder()
        view5.addRoundedBorder()
        view6.addRoundedBorder()
        view7.addRoundedBorder()
        view8.addRoundedBorder()
        selectedMealTypeLabel.addRoundedBorder(cornerRadius: 5, borderWidth: 1, borderColor: .sarı,backgroundColor: .beyaz)
        productDescriptionTextView.addRoundedBorder(cornerRadius: 5, borderWidth: 1, borderColor: .sarı,backgroundColor: .beyaz)
    
        preferences.drawing.backgroundColor = .lightGray
        preferences.drawing.foregroundColor = .white
        setupDeliverySegments()
        deliveryTypeSegmentControl.addTarget(
            self,
            action: #selector(deliveryTypeChanged(_:)),
            for: .valueChanged
        )
        tapGesture()
        initCloudinary()
        bottomSheetViewModel = BottomSheetViewModel()
        deliveryTypeSegmentControl.addTarget(self, action: #selector(deliveryTypeChanged(_:)), for: .valueChanged)
        // Segment değişimini dinlemek için viewDidLoad'a ekle
        discountSegmentControl.addTarget(self, action: #selector(discountSegmentChanged(_:)), for: .valueChanged)
        
        // DatePicker'ı saat moduna ayarla (Storyboard'dan da yapılabilir)
        lastTimePicker.datePickerMode = .time
        lastTimePicker.locale = Locale(identifier: "tr_TR") // Türkçe saat formatı
        
        updateSelectedMealTypes([]) // İlk açılışta placeholder göster
        // Eğer düzenliyorsak, önceki seçimleri yükle
        if let order = selectedOrder {
            let selectedIndices = order.category.compactMap { mealType in
                bottomSheetViewModel.mealType.firstIndex { $0.description == mealType } // String karşılaştırma yapın!
            }
            bottomSheetViewModel.selectedMealIndices = Set(selectedIndices)
        }
        
        oldPriceTextField.delegate = self
        newPriceTextField.delegate = self
        
        if let order = selectedOrder {
            let selectedIndices = order.category.compactMap { mealType in
                bottomSheetViewModel.mealType.firstIndex { $0.description == mealType }
            }
            bottomSheetViewModel.selectedMealIndices = Set(selectedIndices)
            productNameTextField.text = order.name
            productDescriptionTextView.text = order.description
            oldPriceTextField.text = "\(order.oldPrice) TL"
            newPriceTextField.text = "\(order.newPrice) TL"
            
            discountSegmentControl.selectedSegmentIndex = order.discountType
            lastTimePicker.date = order.endTime
            
            updateSelectedMealTypes(order.category) // Yemek türlerini yükle
            
        }
        configureGestures()
    }
    
    private func configureGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
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
    func tapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        selectedImageView.isUserInteractionEnabled = true
        selectedImageView.addGestureRecognizer(tap)
    }
    
    @objc func imageTapped() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    private func initCloudinary() {
        let config = CLDConfiguration(cloudName: cloudName, secure: true)
        cloudinary = CLDCloudinary(configuration: config)
    }
    
    private func uploadImage(selectedImage: UIImage) {
        guard let data = selectedImage.jpegData(compressionQuality: 0.8) else {
            print("Error: Image data not found")
            return
        }
        cloudinary.createUploader().upload(data: data, uploadPreset: uploadPreset, completionHandler:  { response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Upload error: \(error.localizedDescription)")
                    return
                }
                
                guard let url = response?.secureUrl else {
                    print("Error: Secure URL not found in response")
                    return
                }
                
                self.selectedImageView.cldSetImage(url, cloudinary: self.cloudinary)
                print("Image uploaded successfully!!!!!!!!!!!!!!!!!!!!!: \(url)")
                self.toImage = url
            }
        })
    }
    
    
    @IBAction func infoButtonClicked(_ sender: Any) {
        showToolTip()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func showToolTip() {
        tipView = EasyTipView(text: "Önerilen sabit indirimler!",
                              preferences: self.preferences,
                              delegate: self)
        tipView?.show(forView: self.infoButton, withinSuperview: self.mainView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tipView?.dismiss()
            self.tipView = nil
        }
    }
    @IBAction func saveAndNextButtonClicked(_ sender: UIButton) {
        guard let deliveryType = DeliveryType(index: deliveryTypeSegmentControl.selectedSegmentIndex) else {
               showAlert(message: "Geçersiz teslimat türü")
               return
           }
        let selectedTime = lastTimePicker.date
        guard
            let name = productNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            !name.isEmpty,
            let description = productDescriptionTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            !description.isEmpty,
            let oldPriceText = oldPriceTextField.text?
                .replacingOccurrences(of: " TL", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines),
            let oldPrice = Int(oldPriceText),
            let newPriceText = newPriceTextField.text?
                .replacingOccurrences(of: " TL", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines),
            let newPrice = Int(newPriceText)
        else {
            showAlert(message: "Lütfen tüm alanları doldurun.")
            return
        }
        
        let selectedMeals = bottomSheetViewModel.selectedMealIndices.map {
            bottomSheetViewModel.mealType[$0].description
        }
        let order = Order(
            productId: selectedOrder?.productId,
            name: name,
            description: description,
            oldPrice: oldPrice,
            newPrice: newPrice,
            discountType: discountSegmentControl.selectedSegmentIndex,
            endTime: selectedTime,
            orderStatus: OrderStatus.preparing,
            deliveryType: deliveryType,
            restaurantId: "1327",
            category: selectedMeals,
            imageUrl: toImage ?? ""
        )
        
        orderViewModel.saveOrder(order) { result in
            // Geri çağrı işlemleri
            self.navigationController?.popViewController(animated: true)
            
        }
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
    
    // MARK: - Delivery Segment
       private func setupDeliverySegments() {
           // Segment başlıklarını enum'dan al
           deliveryTypeSegmentControl.removeAllSegments()
           
           for (index, type) in DeliveryType.allCases.enumerated() {
               deliveryTypeSegmentControl.insertSegment(
                   withTitle: type.title,
                   at: index,
                   animated: false
               )
           }
           
           // Varsayılan seçimi ayarla
           deliveryTypeSegmentControl.selectedSegmentIndex = 0
       }
    @objc private func deliveryTypeChanged(_ sender: UISegmentedControl) {
        guard let deliveryType = DeliveryType(index: sender.selectedSegmentIndex) else {
            print("Geçersiz segment seçimi")
            return
        }
        
        print("Seçilen teslim türü: \(deliveryType.title)")
    }
}
extension ProductAddedViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let item = results.first?.itemProvider, item.canLoadObject(ofClass: UIImage.self) else { return }
        
        item.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
            guard let self = self, let selectedImage = image as? UIImage else { return }
            
            DispatchQueue.main.async {
                self.selectedImageView.image = selectedImage
                self.uploadImage(selectedImage: selectedImage)
            }
        }
    }
}

// MARK: - view
extension UIView {
    func addRoundedBorder(cornerRadius: CGFloat = 10,
                         borderWidth: CGFloat = 3,
                          borderColor: UIColor = .açıkgri,
                          backgroundColor: UIColor? = .opakbeyaz) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.backgroundColor = backgroundColor
    }
}
