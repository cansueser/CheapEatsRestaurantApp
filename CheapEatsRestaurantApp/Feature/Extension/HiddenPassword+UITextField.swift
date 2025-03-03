//
//  HiddenPassword+UITextField.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 3.03.2025.
//
import UIKit

extension UITextField {
    func togglePasswordVisibility() {
        isSecureTextEntry = !isSecureTextEntry

        if let existingText = text, isSecureTextEntry {
            deleteBackward()

            if let textRange = textRange(from: beginningOfDocument, to: endOfDocument) {
                replace(textRange, withText: existingText)
            }
        }
        if let existingSelectedTextRange = selectedTextRange {
            selectedTextRange = nil
            selectedTextRange = existingSelectedTextRange
        }
    }
}
