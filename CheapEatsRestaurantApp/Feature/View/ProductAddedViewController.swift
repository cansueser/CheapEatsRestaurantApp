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
    @IBOutlet weak var startTimePicker: UIDatePicker!
    
    
    var orderViewModel: OrderViewModel!
    //qqq
    var selectedOrder: Order?
    //qqqqqq
    //clli  güncelleme
    var selectedIndexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        //qqqqq
        // Eğer selectedOrder varsa bilgileri UI elemanlarına aktar
                if let order = selectedOrder {
                    productNameTextField.text = order.name
                    productDescriptionTextView.text = order.description
                    oldPriceTextField.text = "\(order.oldPrice)"
                    newPriceTextField.text = "\(order.newPrice)"
                    // Görsel için URL'den resim yükleme işlemi yapılabilir
                  //  selectedImageView.image = UIImage(named: order.foodImage) // Bu örnekte yerel bir resim adı kullanıyoruz

                    // Delivery Type ve Discount Type segmentlerini ayarla
                    deliveryTypeSegmentControl.selectedSegmentIndex = order.deliveryType
                    discountSegmentControl.selectedSegmentIndex = order.discountType
                    
                    // Start ve End Time Picker'ları ayarla
                    startTimePicker.date = order.startTime
                    lastTimePicker.date = order.endTime
                }
            
    //qqqqqq
        configureGestures()
        configureImageViewTap()
    }
    
    private func configureGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func configureImageViewTap() {
        // Resim seçmek için tap gesture ekleme
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
        imagePickerController.sourceType = .photoLibrary  // Galeriden seçim yapılacak
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.present(imagePickerController, animated: true, completion: nil)
        } else {
            print("Fotoğraf kütüphanesi erişilemiyor.")
        }
    }
    
    // Seçilen resmin alındığı metot
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageView.image = selectedImage  // Seçilen resmi imageView'e ekleyin
        }
        dismiss(animated: true, completion: nil)
    }

    // Kullanıcı fotoğraf seçiminden vazgeçerse
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

   
    @IBAction func saveAndNextButtonClicked(_ sender: UIButton) {
        let name = productNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
         let description = productDescriptionTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
         let oldPriceText = oldPriceTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
         let newPriceText = newPriceTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

         guard !name.isEmpty,
               !description.isEmpty,
               !oldPriceText.isEmpty,
               !newPriceText.isEmpty,
               let oldPrice = Double(oldPriceText),
               let newPrice = Double(newPriceText),
               let foodImage = selectedImageView.image else {
             showAlert(message: "Lütfen tüm alanları doldurun.")
             return
         }

         let updatedOrder = Order(
             name: name,
             description: description,
             oldPrice: oldPrice,
             newPrice: newPrice,
             deliveryType: deliveryTypeSegmentControl.selectedSegmentIndex,
             discountType: discountSegmentControl.selectedSegmentIndex,
             startTime: startTimePicker.date,
             endTime: lastTimePicker.date,
             foodImage: foodImage,
             orderStatus: .preparing
         )

         if let indexPath = selectedIndexPath {
             // Mevcut order'ı güncelle
             orderViewModel.updateOrder(at: indexPath.row, with: updatedOrder)
         } else {
             // Yeni order ekle
             orderViewModel.addOrder(updatedOrder)
         }

         navigationController?.popViewController(animated: true)
     }
           private func showAlert(message: String) {
               let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "Tamam", style: .default))
               present(alert, animated: true)
           }
       }
