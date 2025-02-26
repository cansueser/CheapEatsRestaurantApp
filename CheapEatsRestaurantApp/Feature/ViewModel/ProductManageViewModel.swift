//
//  ProductViewModel.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 14.12.2024.
//

import Foundation
import EasyTipView
import Cloudinary
import UIKit

protocol ProductManageViewModelProtocol {
    var delegate: ProductManageViewModelOutputProtocol? { get set}
    var selectedMealTypes: [Category] { get set }
    var cloudinaryImageUrlString: String? { get set }
    func initCloudinary() -> CLDCloudinary
    func uploadImage(selectedImageView: CLDUIImageView, selectedImage: UIImage, cloudinary: CLDCloudinary)
    func emptyCheckSelectedItem(bottomSheetVC: BottomSheetViewController)
    
}
protocol ProductManageViewModelOutputProtocol: AnyObject{
    func update()
    func error()
}

final class ProductManageViewModel {
    weak var delegate: ProductManageViewModelOutputProtocol?
    var cloudinaryImageUrlString: String?
    var selectedMealTypes: [Category] = []
    
    func initCloudinary() -> CLDCloudinary {
        let networkHelper = NetworkHelper.self
        let config = CLDConfiguration(cloudName: networkHelper.cloudName, secure: true)
        return CLDCloudinary(configuration: config)
    }

    func uploadImage(selectedImageView: CLDUIImageView, selectedImage: UIImage, cloudinary: CLDCloudinary) {
        guard let data = selectedImage.jpegData(compressionQuality: 0.8) else {
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
                
                selectedImageView.cldSetImage(url, cloudinary: cloudinary)
                print("Image uploaded successfully!: \(url)")
                self.cloudinaryImageUrlString = url
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

