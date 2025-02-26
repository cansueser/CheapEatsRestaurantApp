import UIKit
import Cloudinary
import Kingfisher
import PhotosUI
import EasyTipView

class ProductManageViewController: UIViewController {
    //MARK: -Variables
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
    @IBOutlet weak var priceImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeImage: UIImageView!
    
    var productManageViewModel: ProductManageViewModelProtocol = ProductManageViewModel()
    private var bottomSheetViewModel: BottomSheetViewModel = BottomSheetViewModel()
    
    var tipView: EasyTipView?
    var preferences = EasyTipView.Preferences()
    
    var cloudinary: CLDCloudinary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        cloudinary = productManageViewModel.initCloudinary()
        tapGesture()
        if productManageViewModel.selectedMealTypes.isEmpty {
            selectedMealTypeLabel.text = "Yemek Türü Seçiniz"
        } else {
            selectedMealTypeLabel.text = productManageViewModel.selectedMealTypes.map { $0.rawValue }.joined(separator: ", ")
        }
        
        /*if let order = selectedOrder {
            productNameTextField.text = order.name
            productDescriptionTextView.text = order.description
            oldPriceTextField.text = "\(order.oldPrice) TL"
            newPriceTextField.text = "\(order.newPrice) TL"
            discountSegmentControl.selectedSegmentIndex = order.discountType
            lastTimePicker.date = order.endTime
            updateSelectedMealTypes(order.category)
        }
         */
    }
    
    private func setupUI() {
        oldPriceTextField.delegate = self
        newPriceTextField.delegate = self
        productManageViewModel.delegate = self
        
        selectedMealTypeLabel.addRoundedBorder(cornerRadius: 5, borderWidth: 1, borderColor: .suyeşil,backgroundColor: .beyaz)
        productDescriptionTextView.addRoundedBorder(cornerRadius: 5, borderWidth: 1, borderColor: .suyeşil,backgroundColor: .beyaz)
        timeImage.makeRounded(radius: 5)
        timeLabel.makeRounded(radius: 5)
        priceImage.makeRounded(radius: 5)
        priceLabel.makeRounded(radius: 5)
        selectedImageView.makeRounded(radius: 5)
        preferences.drawing.backgroundColor = .lightGray
        preferences.drawing.foregroundColor = .white
    }

    @objc func imageTapped() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func infoButtonClicked(_ sender: Any) {
        showToolTip()
    }
    
    @IBAction func saveAndNextButtonClicked(_ sender: UIButton) {
        guard let deliveryType = DeliveryType(index: deliveryTypeSegmentControl.selectedSegmentIndex) else {
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
            showOneButtonAlert(title: "Hata", message: "Lütfen tüm alanları doldurun.")
            return
        }
    }
    
    @IBAction func mealTypeButtonClicked(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let bottomSheetVC = storyboard.instantiateViewController(withIdentifier: "BottomSheetViewController") as? BottomSheetViewController {
            bottomSheetVC.modalPresentationStyle = .pageSheet
            if let sheet = bottomSheetVC.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
            }
            productManageViewModel.emptyCheckSelectedItem(bottomSheetVC: bottomSheetVC)
            bottomSheetVC.delegate = self
            present(bottomSheetVC, animated: true)
        }
    }
    
    
    private func updateSelectedMealTypes(_ meals: [String]) {
        if meals.isEmpty {
            selectedMealTypeLabel.text = "Yemek Türü Seçiniz"
            selectedMealTypeLabel.textColor = .gri
        } else {
            selectedMealTypeLabel.text = meals.joined(separator: " , ")
            selectedMealTypeLabel.textColor = .black
        }
    }

    private func tapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        selectedImageView.isUserInteractionEnabled = true
        selectedImageView.addGestureRecognizer(tap)
    }
    
    @IBAction func discountSegmentClicked(_ sender: UISegmentedControl) {
        guard let oldPriceText = oldPriceTextField.text?.replacingOccurrences(of: " TL", with: ""),
              let oldPrice = Int(oldPriceText) else {
            showOneButtonAlert(title: "Hata", message: "Lütfen önce normal fiyatı giriniz.")
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
    @IBAction func deliveryTypeSegmentClicked(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
    }
}
extension ProductManageViewController: BottomSheetViewModelDelegate {
    func didApplySelection(selectedOptions: [Category]) {
        productManageViewModel.selectedMealTypes = selectedOptions
        selectedMealTypeLabel.text = selectedOptions.isEmpty ? "Yemek Türü Seçiniz" : selectedOptions.map { $0.rawValue }.joined(separator: ", ")
    }
}

extension ProductManageViewController: ProductManageViewModelOutputProtocol {
    func update() {
        print("Update")
    }
    
    func error() {
        print("Error")
    }
}

