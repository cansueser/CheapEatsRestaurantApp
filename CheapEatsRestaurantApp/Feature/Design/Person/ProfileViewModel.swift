import Foundation
import Firebase
import FirebaseAuth

protocol ProfileViewModelProtocol: AnyObject {
    var output: ProfileViewModelOutputProtocol? { get set }
    var profile: ProfileModel { get }
    func fetchProfileData()
    func updateProfile(restaurantName: String, ownerName: String, ownerSurname: String, email: String, phone: String)
    func isValidEmail(_ email: String) -> Bool
    func isValidPhone(_ phone: String) -> Bool
}

class ProfileViewModel: ProfileViewModelProtocol {
    weak var output: ProfileViewModelOutputProtocol?
    
    private var profileInternal: ProfileModel = ProfileModel()
    var profile: ProfileModel {
        return profileInternal
    }
    private let db = Firestore.firestore()
    
    func fetchProfileData() {
        guard let userID = Auth.auth().currentUser?.uid else {
            output?.onError(message: "Kullanıcı bilgisi bulunamadı")
            return
        }
        
        db.collection("restaurants").document(userID).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                self.output?.onError(message: "Veri alınamadı: \(error.localizedDescription)")
                return
            }
            
            guard let data = snapshot?.data() else {
                self.output?.onError(message: "Restaurant data not available")
                return
            }
            
            self.profileInternal = ProfileModel(
                restaurantName: data["companyName"] as? String ?? "",
                ownerName: data["ownerName"] as? String ?? "",
                ownerSurname: data["ownerSurname"] as? String ?? "",
                email: data["email"] as? String ?? "",
                phone: data["phone"] as? String ?? ""
            )
            
            self.output?.onProfileUpdated(profile: self.profileInternal)
        }
    }
    
    func updateProfile(restaurantName: String, ownerName: String, ownerSurname: String, email: String, phone: String) {
        guard let userID = Auth.auth().currentUser?.uid else {
            output?.onError(message: "Kullanıcı bilgisi bulunamadı")
            return
        }
        
        let profileData: [String: Any] = [
            "companyName": restaurantName,
            "ownerName": ownerName,
            "ownerSurname": ownerSurname,
            "email": email,
            "phone": phone,
            "updatedAt": FieldValue.serverTimestamp()
        ]
        
        db.collection("restaurants").document(userID).setData(profileData, merge: true) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                self.output?.onError(message: "Profil güncellenemedi: \(error.localizedDescription)")
                return
            }
            
            self.profileInternal = ProfileModel(
                restaurantName: restaurantName,
                ownerName: ownerName,
                ownerSurname: ownerSurname,
                email: email,
                phone: phone
            )
            
            self.output?.onSaveSuccess()
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPhone(_ phone: String) -> Bool {
        let phoneRegEx = "^[0-9+]{10,15}$"
        let phonePred = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return phonePred.evaluate(with: phone)
    }
}
protocol ProfileViewModelOutputProtocol: AnyObject {
    func onProfileUpdated(profile: ProfileModel)
    func onError(message: String)
    func onSaveSuccess()
}
