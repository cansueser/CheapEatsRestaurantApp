//
//  ProductViewModel.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 14.12.2024.
//

import Foundation
import UIKit
import Cloudinary


protocol ProductManageViewModelProtocol {
    var delegate: ProductManageViewModelOutputProtocol? { get set}
    var product: Product? { get set }
    var selectedMealTypes: [Category] { get set }
    var cloudinaryImageUrlString: String { get set }
    func uploadImage(selectedImageView: CLDUIImageView)
    func emptyCheckSelectedItem(bottomSheetVC: BottomSheetViewController)
    func setProduct(product: Product)
    func getProduct() -> Product?
    func updateProduct(product: Product)
    var goSource : GoSource { get set }
}

protocol ProductManageViewModelOutputProtocol: AnyObject{
    func update()
    func error()
    func startLoading()
    func stopLoading()
}

final class ProductManageViewModel {
    weak var delegate: ProductManageViewModelOutputProtocol?
    var product: Product?
    var cloudinary: CLDCloudinary!
    var cloudinaryImageUrlString: String = ""
    var selectedMealTypes: [Category] = []
    var goSource : GoSource = .addProduct
    
    init() {
        cloudinary = initCloudinary()
    }
    
    func setProduct(product: Product) {
        self.delegate?.startLoading()
        NetworkManager.shared.addProduct(product: product) { result in
            switch result {
            case .success():
                self.product = product
                self.delegate?.update()
            case .failure(let error):
                print("Error: \(error)")
                self.delegate?.error()
            }
            self.delegate?.stopLoading()
        }
    }
    func getProduct() -> Product? {
        return product ?? nil
    }
    
    func updateProduct(product: Product) {
        delegate?.startLoading()
        var tempProduct = product
        tempProduct.productId = self.product?.productId ?? ""
        NetworkManager.shared.updateProduct(product: tempProduct) { result in
            switch result {
            case .success():
                self.product = product
                self.delegate?.update()
            case .failure(_):
                self.delegate?.error()
            }
            self.delegate?.stopLoading()
        }
    }
    
    private func initCloudinary() -> CLDCloudinary {
        let networkHelper = NetworkHelper.self
        let config = CLDConfiguration(cloudName: networkHelper.cloudName, secure: true)
        return CLDCloudinary(configuration: config)
    }
    
    func uploadImage(selectedImageView: CLDUIImageView) {
        delegate?.startLoading()
        guard let imageView = selectedImageView.image, let data = imageView.jpegData(compressionQuality: 0.8) else {
            print("Error: Image data not found")
            return
        }
        let networkHelper = NetworkHelper.self
        cloudinary.createUploader().upload(data: data, uploadPreset: networkHelper.cloudUploadPresent, completionHandler:  { response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Upload error: \(error.localizedDescription)")
                    return
                }
                
                guard let url = response?.secureUrl else {
                    print("Error: Secure URL not found in response")
                    return
                }
                
                selectedImageView.cldSetImage(url, cloudinary: self.cloudinary)
                print("Image uploaded successfully!: \(url)")
                self.cloudinaryImageUrlString = url
                self.delegate?.stopLoading()
            }
        })
    }
    
    func emptyCheckSelectedItem(bottomSheetVC: BottomSheetViewController) {
        if selectedMealTypes.isEmpty {
            bottomSheetVC.bottomSheetViewModel.selectedOptions = []
        } else {
            bottomSheetVC.bottomSheetViewModel.selectedOptions = selectedMealTypes
        }
    }
}

extension ProductManageViewModel: ProductManageViewModelProtocol { }


enum GoSource {
    case addProduct, updateProduct
}
