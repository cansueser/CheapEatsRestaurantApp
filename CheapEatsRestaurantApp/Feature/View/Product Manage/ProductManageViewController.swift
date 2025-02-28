import UIKit
import Cloudinary
import PhotosUI
import EasyTipView
import NVActivityIndicatorView

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
    @IBOutlet weak var productNameBackView: UIView!
    @IBOutlet weak var photoBackView: UIView!
    @IBOutlet weak var mealTypeBackView: UIView!
    @IBOutlet weak var priceBackView: CustomLineView!
    @IBOutlet weak var deliveryTypeBackView: CustomLineView!
    @IBOutlet weak var timeBackView: UIView!
    @IBOutlet weak var priceImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeImage: UIImageView!
    @IBOutlet weak var waitView: UIView!
    
    var productManageViewModel: ProductManageViewModelProtocol = ProductManageViewModel()
    private var bottomSheetViewModel: BottomSheetViewModel = BottomSheetViewModel()
    
    private var loadIndicator: NVActivityIndicatorView!
    var tipView: EasyTipView?
    var preferences = EasyTipView.Preferences()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
        discountSegmentControl.layer.shadowOpacity = 0
        deliveryTypeSegmentControl.layer.shadowOpacity = 0
        oldPriceTextField.delegate = self
        newPriceTextField.delegate = self
        productManageViewModel.delegate = self
        productDescriptionTextView.addRoundedBorder(cornerRadius: 5, borderWidth: 1, borderColor: .title,backgroundColor: .textWhite)
        timeImage.makeRounded(radius: 5)
        timeLabel.makeRounded(radius: 5)
        priceImage.makeRounded(radius: 5)
        priceLabel.makeRounded(radius: 5)
        selectedImageView.addRoundedBorder(cornerRadius: 5, borderWidth: 2, borderColor: .title)
        preferences.drawing.backgroundColor = .lightGray
        preferences.drawing.foregroundColor = .white
        priceBackView.lineYPosition = oldPriceTextField.frame.origin.y - 10
        deliveryTypeBackView.lineYPosition = deliveryTypeSegmentControl.frame.origin.y - 10
        priceBackView.setNeedsDisplay()
        deliveryTypeBackView.setNeedsDisplay()
        lastTimePicker.setDate(Date(), animated: true)
        loadIndicator = createLoadingIndicator(in: waitView)
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
        guard
            let name = productNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            !name.isEmpty,
            let description = productDescriptionTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            !description.isEmpty,
            let oldPrice = Int(oldPriceTextField.text ?? "0"),
            let newPrice = Int(newPriceTextField.text ?? "0")
        else {
            showOneButtonAlert(title: "Hata", message: "Lütfen tüm alanları doldurun.")
            return
        }
        if oldPrice <= newPrice {
            showOneButtonAlert(title: "Hata", message: "Eski fiyat yeni fiyattan yüksek olamaz.")
        }
        
        let selectedMealTypes = productManageViewModel.selectedMealTypes.map({ $0.rawValue })
        
        guard let deliveryType = DeliveryType(index: deliveryTypeSegmentControl.selectedSegmentIndex) else {
            return
        }
        
        if productManageViewModel.cloudinaryImageUrlString.isEmpty {
            showOneButtonAlert(title: "Hata", message: "Eski fiyat yeni fiyattan yüksek olamaz.")
        }else{
            let endDate = dateFormatter().string(from: lastTimePicker.date)
            let product =  Product(name: name, description: description, oldPrice: oldPrice, newPrice: newPrice,  endDate: endDate, deliveryType: deliveryType, restaurantId: "WXJ5I0rRDYfWaJSfwF3d", category: selectedMealTypes, imageUrl: productManageViewModel.cloudinaryImageUrlString)
            productManageViewModel.setProduct(product: product)
        }
        
        /*showTwoButtonAlert(title: "Uyarı", message: "Emin misin", firstButtonTitle: "Sil", firstButtonHandler: { _ in
                ---
        }, secondButtonTitle: "İptal Et")
        */
    }
    
    private func dateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
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

    private func tapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        selectedImageView.isUserInteractionEnabled = true
        selectedImageView.addGestureRecognizer(tap)
    }
    
    @IBAction func discountSegmentClicked(_ sender: UISegmentedControl) {
        if let oldPriceText = Int(oldPriceTextField.text ?? "0"){
            let selectedTitle = sender.titleForSegment(at: sender.selectedSegmentIndex) ?? ""
            let percentageString = selectedTitle.filter { $0.isNumber }
            guard let discountPercentage = Int(percentageString) else { return }
            
            let discountRate = Double(discountPercentage) / 100.0
            let newPrice = Int(Double(oldPriceText ) * (1.0 - discountRate))
            newPriceTextField.text = "\(newPrice)"
            print("Normal Fiyat:\(oldPriceText ) TL İndirim Oranı:%\(discountPercentage) Yeni Fiyat: \(newPrice) TL")
        }else{
            showOneButtonAlert(title: "Hata", message: "Lütfen önce normal fiyatı giriniz.")
        }
        
    }
    
    @IBAction func deliveryTypeSegmentClicked(_ sender: UISegmentedControl) {
        print(sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "")
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
    
    func stopLoading() {
        waitView.isHidden = true
        loadIndicator.isHidden = true
        loadIndicator.stopAnimating()
    }
    
    func startLoading() {
        waitView.isHidden = false
        loadIndicator.isHidden = false
        loadIndicator.startAnimating()
        
    }
    
}

