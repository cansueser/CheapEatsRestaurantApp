import Firebase

struct Orders {
    var orderId: String
    var orderDate: Date
    var orderNo: String
    var productId: String
    var status: OrderStatus
    var userId: String
    var cardInfo: String
    var quantity: Int
    var selectedDeliveryType: DeliveryType
    var couponId: String

    init?(dictionary: [String: Any], documentId: String) {
        self.orderId = documentId
        if let timestamp = dictionary["orderDate"] as? Timestamp {
            self.orderDate = timestamp.dateValue()
        } else if let dateString = dictionary["orderDate"] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM d, yyyy 'at' h:mm:ss a zzz"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            self.orderDate = formatter.date(from: dateString) ?? Date()
        } else {
            self.orderDate = Date()
        }
        self.orderNo = dictionary["orderNo"] as? String ?? ""
        self.cardInfo = dictionary["cardInfo"] as? String ?? ""
        self.productId = dictionary["productId"] as? String ?? ""
        let statusString = dictionary["status"] as? String ?? OrderStatus.preparing.rawValue
        self.status = OrderStatus(rawValue: statusString) ?? .preparing
        self.userId = dictionary["userId"] as? String ?? ""
        let selectedDeliveryTypeString = dictionary["selectedDeliveryType"] as? String ?? DeliveryType.all.rawValue
        self.selectedDeliveryType = DeliveryType(rawValue: selectedDeliveryTypeString) ?? .all
        self.quantity = dictionary["quantity"] as? Int ?? 1
        self.couponId = dictionary["couponId"] as? String ?? ""
    }
}

enum OrderStatus: String, Codable, CaseIterable, CustomStringConvertible {
    case pending = "Sipariş Alındı"
    case preparing = "Hazırlanıyor"
    case ready = "Hazır"
    case delivered = "Teslim Edildi"
    case canceled = "İptal Edildi"
    var description: String { self.rawValue }
}
