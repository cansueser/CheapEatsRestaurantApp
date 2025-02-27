//
//  ProductManageViewController+TextField.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 26.02.2025.
//
import UIKit

extension ProductManageViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let isNumber = string.isEmpty || string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        return isNumber
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == newPriceTextField {
            discountSegmentControl.selectedSegmentIndex = UISegmentedControl.noSegment
        }
    }
}
