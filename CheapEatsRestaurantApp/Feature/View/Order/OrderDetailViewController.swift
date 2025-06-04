import UIKit
import Kingfisher

class OrderDetailViewController: UIViewController {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var orderNoLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var deliveryTypeLabel: UILabel!
    @IBOutlet weak var changeStatusButton: UIButton!
    @IBOutlet weak var DetailBackView: UIView!
    
    @IBOutlet weak var productDescriptionTextView: UITextView!
    var order: Orders!
       var product: Product?
       var onOrderStatusChanged: ((OrderStatus) -> Void)?
       
       override func viewDidLoad() {
           super.viewDidLoad()
           title = "Sipariş Detayı"
           setupUI()
           // Order non-nil kontrolü
           guard order != nil else {
               showErrorAndPopController(message: "Sipariş bilgisi bulunamadı")
               return
           }
           
           // Ürün varsa hemen göster, yoksa çekmeyi dene
           if let product = product {
               configureUI(with: product)
           } else {
               // Ürün yok, Firebase'den çekelim
               fetchProductFromFirebase()
           }
       }
       
       private func fetchProductFromFirebase() {
           guard let productId = order?.productId else {
               configureUI(with: nil)  // Ürün ID'si yoksa boş göster
               return
           }
           
           // Ürün yükleniyor bilgisi göster
           productNameLabel.text = "Ürün yükleniyor..."
           NetworkManager.shared.fetchProduct(withId: productId) { [weak self] product in
               guard let self = self else { return }
               
               // UI güncellemelerini ana thread'de yap
               DispatchQueue.main.async {
                   self.product = product
                   self.configureUI(with: product)
               }
           }
       }
       
       private func showErrorAndPopController(message: String) {
           let alert = UIAlertController(
               title: "Hata",
               message: message,
               preferredStyle: .alert
           )
           alert.addAction(UIAlertAction(title: "Tamam", style: .default) { [weak self] _ in
               self?.navigationController?.popViewController(animated: true)
           })
           present(alert, animated: true)
       }
       
       private func setupUI() {
           DetailBackView.layer.cornerRadius = 5
           DetailBackView.layer.masksToBounds = false
           DetailBackView.layer.shadowColor = UIColor.black.cgColor
           DetailBackView.layer.shadowOpacity = 0.2
           DetailBackView.layer.shadowRadius = 4
           DetailBackView.layer.shadowOffset = CGSize(width: 0, height: 2)
           productImageView.layer.cornerRadius = 8
           productImageView.clipsToBounds = true
           statusLabel.layer.cornerRadius = 5
           statusLabel.clipsToBounds = true
       }
       
       private func configureUI(with product: Product?) {
           guard let order = order else { return }
           
           if let product = product {
               // Ürün bulundu - tüm bilgileri göster
               productNameLabel.text = product.name
               productDescriptionTextView.text = product.description 
               
               // Eski ve yeni fiyatı formatlı göster
               let oldPrice = product.oldPrice
               let newPrice = product.newPrice
               let oldPriceAttr = NSAttributedString(
                   string: "\(oldPrice) TL",
                   attributes: [
                       .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                       .foregroundColor: UIColor.lightGray
                   ])
               let newPriceAttr = NSAttributedString(
                   string: " \(newPrice) TL",
                   attributes: [
                    .foregroundColor: UIColor.button,
                       .font: UIFont.boldSystemFont(ofSize: 17)
                   ])
               let priceText = NSMutableAttributedString()
               priceText.append(oldPriceAttr)
               priceText.append(newPriceAttr)
               priceLabel.attributedText = priceText
               
               // Ürün görseli yükle
               if let url = URL(string: product.imageUrl) {
                   productImageView.kf.setImage(with: url, placeholder: UIImage(named: "Logo"))
               }
           } else {
               // Ürün bulunamadı - default bilgiler
               productNameLabel.text = "Ürün bilgisi bulunamadı"
               productDescriptionTextView.text = "Ürün detayları bulunamadı" // UITextView kullanımı
               priceLabel.text = "Fiyat bilgisi yok"
               productImageView.image = UIImage(named: "Logo") ?? UIImage(systemName: "photo")
           }
           
           // Sipariş bilgileri (her zaman göster)
           orderNoLabel.text = "Sipariş No: \(order.orderNo)"
           
           // Tarih bilgisi
           let dateFormatter = DateFormatter()
           dateFormatter.dateStyle = .medium
           dateFormatter.timeStyle = .short
           dateFormatter.locale = Locale(identifier: "tr_TR")
           orderDateLabel.text = "Sipariş Tarihi: \(dateFormatter.string(from: order.orderDate))"
           
           // Sipariş durumu
           updateStatusLabel(with: order.status)
           
           // Teslimat tipi
           switch order.selectedDeliveryType {
           case .delivery:
               deliveryTypeLabel.text = "Teslimat Tipi: Eve Teslimat 🚚"
           case .takeout:
               deliveryTypeLabel.text = "Teslimat Tipi: Gel-Al 🏃‍♂️"
           case .all:
               deliveryTypeLabel.text = "Teslimat Tipi: Eve Teslimat / Gel-Al 🚚🏃‍♂️"
           }
       }
       
       
       private func updateStatusLabel(with status: OrderStatus) {
           statusLabel.text = "Durum: \(status.description)"
           switch status {
                   case .preparing:
                       statusLabel.textColor = UIColor(named: "AccentColor") ?? .systemYellow
                   case .delivered:
                       statusLabel.textColor = UIColor(named: "ButtonColor") ?? .systemGreen
                   case .canceled:
                       statusLabel.textColor = UIColor(named: "Cutcolor") ?? .systemRed            }
       }
       
       @IBAction func changeStatusButtonTapped(_ sender: UIButton) {
           let alertController = UIAlertController(title: "Sipariş Durumunu Değiştir", message: "Yeni bir durum seçin", preferredStyle: .actionSheet)
           
           for status in OrderStatus.allCases {
               let action = UIAlertAction(title: status.description, style: .default) { [weak self] _ in
                   self?.updateOrderStatus(to: status)
               }
               if status == order.status {
                   action.setValue(true, forKey: "checked")
               }
               alertController.addAction(action)
           }
           
           let cancelAction = UIAlertAction(title: "İptal", style: .cancel)
           alertController.addAction(cancelAction)
           
           present(alertController, animated: true)
       }
       
       private func updateOrderStatus(to newStatus: OrderStatus) {
           guard newStatus != order.status else { return }
           
           order.status = newStatus
           updateStatusLabel(with: newStatus)
           onOrderStatusChanged?(newStatus)
           showStatusChangeSuccess(status: newStatus)
       }
       
       private func showStatusChangeSuccess(status: OrderStatus) {
           var emoji = ""
           var message = ""
           
           switch status {
           case .preparing:
               emoji = "👨‍🍳"
               message = "Sipariş hazırlanıyor olarak güncellendi!"
           case .delivered:
               emoji = "🚚"
               message = "Sipariş teslim edildi olarak güncellendi!"
           case .canceled:
               emoji = "❌"
               message = "Sipariş iptal edildi olarak güncellendi!"
           }
           
           let alert = UIAlertController(
               title: "\(emoji) Durum Güncellendi",
               message: message,
               preferredStyle: .alert
           )
           alert.addAction(UIAlertAction(title: "Tamam", style: .default))
           present(alert, animated: true)
       }
   }
