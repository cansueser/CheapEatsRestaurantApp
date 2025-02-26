//
//  ProductManageViewController+TextField.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 26.02.2025.
//
import UIKit

extension ProductManageViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return true }
        let newString = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if let number = Int(newString.filter({ $0.isNumber })) {
            textField.text = "\(number) TL"
        } else if newString.isEmpty {
            textField.text = ""
        }
        
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == newPriceTextField {
            discountSegmentControl.selectedSegmentIndex = UISegmentedControl.noSegment
        }
    }
}
