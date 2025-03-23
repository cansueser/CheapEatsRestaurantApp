//
//  ProductManageViewController+Picker.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 26.02.2025.
//
import UIKit
import PhotosUI

extension ProductManageViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let item = results.first?.itemProvider, item.canLoadObject(ofClass: UIImage.self) else { return }
        
        item.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
            guard let self = self, let selectedImage = image as? UIImage else { return }
            DispatchQueue.main.async {
                self.selectedImageView.image = selectedImage
                self.selectedImageView.contentMode = .scaleAspectFit
//                self.productManageViewModel.uploadImage(selectedImageView: self.selectedImageView)

            }
        }
    }
}
