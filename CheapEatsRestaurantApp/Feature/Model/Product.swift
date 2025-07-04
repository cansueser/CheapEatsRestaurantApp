import Foundation
import Firebase

struct Product {
    var productId: String
    var name: String
    var description: String
    var oldPrice: Double
    var newPrice: Double
    var restaurantId: String
    var category: [String]
    var imageUrl: String
    var deliveryType: DeliveryType
    var endDate: String
    var status: Bool
    var createdAt: Date
    var quantity: Int

    init(
        name: String,
        description: String,
        oldPrice: Double,
        newPrice: Double,
        endDate: String,
        deliveryType: DeliveryType,
        restaurantId: String,
        category: [String],
        imageUrl: String,
        quantity: Int
    ) {
        self.productId = ""
        self.name = name
        self.description = description
        self.oldPrice = oldPrice
        self.newPrice = newPrice
        self.endDate = endDate
        self.status = false
        self.deliveryType = deliveryType
        self.restaurantId = restaurantId
        self.category = category
        self.imageUrl = imageUrl
        self.createdAt = Date()
        self.quantity = quantity
    }
    
    init?(dictionary: [String: Any]) {
        guard
            let productId = dictionary["productId"] as? String,
            let name = dictionary["name"] as? String,
            let description = dictionary["description"] as? String,
            let oldPrice = dictionary["oldPrice"] as? Double,
            let newPrice = dictionary["newPrice"] as? Double,
            let endDate = dictionary["endDate"] as? String,
            let deliveryTypeString = dictionary["deliveryType"] as? String,
            let deliveryType = DeliveryType(rawValue: deliveryTypeString),
            let restaurantId = dictionary["restaurantId"] as? String,
            let category = dictionary["category"] as? [String],
            let imageUrl = dictionary["imageUrl"] as? String,
            let quantity = dictionary["quantity"] as? Int
        else {
            return nil
        }
        self.productId = productId
        self.name = name
        self.description = description
        self.oldPrice = oldPrice
        self.newPrice = newPrice
        self.endDate = endDate
        self.status = dictionary["status"] as? Bool ?? false
        self.deliveryType = deliveryType
        self.restaurantId = restaurantId
        self.category = category
        self.imageUrl = imageUrl
        if let createdAt = dictionary["createdAt"] as? Timestamp {
            self.createdAt = createdAt.dateValue()
        } else {
            self.createdAt = Date()
        }
        self.quantity = quantity
    }
    
    init?(dictionary: [String: Any], documentId: String) {
        self.productId = documentId
        self.name = dictionary["name"] as? String ?? ""
        self.description = dictionary["description"] as? String ?? ""
        self.oldPrice = dictionary["oldPrice"] as? Double ?? 0.0
        self.newPrice = dictionary["newPrice"] as? Double ?? 0.0
        self.restaurantId = dictionary["restaurantId"] as? String ?? ""
        self.category = dictionary["category"] as? [String] ?? []
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        let deliveryTypeString = dictionary["deliveryType"] as? String ?? DeliveryType.all.rawValue
        self.deliveryType = DeliveryType(rawValue: deliveryTypeString) ?? .all
        if let timestamp = dictionary["createdAt"] as? Timestamp {
            self.createdAt = timestamp.dateValue()
        } else {
            self.createdAt = Date()
        }
        self.endDate = dictionary["endDate"] as? String ?? "00:00"
        self.status = dictionary["status"] as? Bool ?? false
        self.quantity = dictionary["quantity"] as? Int ?? 1
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "productId": productId,
            "name": name,
            "description": description,
            "oldPrice": oldPrice,
            "newPrice": newPrice,
            "endDate": endDate,
            "status": status,
            "deliveryType": deliveryType.rawValue,
            "restaurantId": restaurantId,
            "category": category,
            "imageUrl" : imageUrl,
            "createdAt": Timestamp(date: createdAt),
            "quantity": quantity
        ]
    }
}

enum DeliveryType: String, CaseIterable {
    case all = "Hepsi"
    case delivery = "Gel-Al"
    case takeout = "Kurye"
    
    var title: String {
        return self.rawValue
    }
    
    init?(index: Int) {
        switch index {
        case 0: self = .all
        case 1: self = .delivery
        case 2: self = .takeout
        default: return nil
        }
    }
    
    var index: Int {
        switch self {
        case .all: return 0
        case .delivery: return 1
        case .takeout: return 2
        }
    }
}

enum Category: String, CaseIterable, CustomStringConvertible {
    case burger = "Burger"
    case doner = "Döner"
    case tatlı = "Tatlı"
    case pizza = "Pizza"
    case tavuk = "Tavuk"
    case kofte = "Köfte"
    case evYemek = "Ev Yemekleri"
    case pastane = "Pastane & Fırın"
    case kebap = "Kebap"
    case kahvaltı = "Kahvaltı"
    case vegan = "Vegan"
    case corba = "Çorba"
    
    var description: String {
        return self.rawValue
    }
    
    static func getAllCategories() -> [Category] {
        return Array(Category.allCases)
    }
    
    static func getAllCategoriesNames() -> [String] {
        return Array(Category.allCases.map{$0.rawValue})
    }
}
