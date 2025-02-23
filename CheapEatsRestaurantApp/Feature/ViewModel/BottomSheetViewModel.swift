//
//  BottomSheetViewModel.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 30.01.2025.
//

import UIKit
import Foundation

class BottomSheetViewModel {
    var mealType: [Category] = Category.getAllCategories()
    var selectedMealIndices: Set<Int> = [] // Çoklu seçim için set
    
    var reloadTableView: (() -> Void)?
    
    func fetchMealTypes() {
        reloadTableView?()
    }
    
    func toggleSelection(at index: Int) {
        if selectedMealIndices.contains(index) {
            selectedMealIndices.remove(index)
        } else {
            selectedMealIndices.insert(index)
        }
    }
    
    func isSelected(at index: Int) -> Bool {
        return selectedMealIndices.contains(index)
    }
}
