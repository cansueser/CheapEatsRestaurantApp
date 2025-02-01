//
//  BottomSheetViewModel.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 30.01.2025.
//

import UIKit

import Foundation

class BottomSheetViewModel {
    var mealTypes: [String] = ["Burger", "Döner", "Tatlı", "Pizza","Tavuk", "Köfte", "Ev Yemekleri", "Pastane & Fırın","Kebap", "Kahvaltı", "Vegan", "Çorba"]
    var selectedMealIndices: Set<Int> = [] // Çoklu seçim için set
    
    var reloadTableView: (() -> Void)?
    
    func fetchMealTypes() {
        mealTypes = ["Burger", "Döner", "Tatlı", "Pizza","Tavuk", "Köfte", "Ev Yemekleri", "Pastane & Fırın","Kebap", "Kahvaltı", "Vegan", "Çorba"]
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

/*
 protocol BottomSheetViewModelProtocol {
 var delegate: BottomSheetViewModelOutputProtocol? { get set }
 //var options: [MealType] { get }
 // var selectedOptions: [MealType] { get set }
 func clearSelection(tableView: UITableView)
 }
 
 protocol BottomSheetViewModelOutputProtocol: AnyObject {
 func didChangeSelection()
 }
 
 protocol BottomSheetViewModelDelegate: AnyObject {
 // func didApplySelection(selectedOptions: [MealType])
 }
 
 final class BottomSheetViewModel {
 //var options = MealType.allCases
 //var selectedOptions: [MealType] = []
 weak var delegate: BottomSheetViewModelOutputProtocol?
 
 func clearSelection(tableView: UITableView) {
 //   selectedOptions.removeAll()
 if let selectedRows = tableView.indexPathsForSelectedRows {
 for indexPath in selectedRows {
 tableView.deselectRow(at: indexPath, animated: false)
 }
 }
 delegate?.didChangeSelection()
 }
 }
 
 extension BottomSheetViewModel: BottomSheetViewModelProtocol {}
 import Foundation
 import UIKit
 
 extension BottomSheetViewController: UITableViewDataSource, UITableViewDelegate {
 func tableView( tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 return bottomSheetViewModel.options.count
 }
 
 func tableView( tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
 let option = bottomSheetViewModel.options[indexPath.row]
 cell.textLabel?.text = option.rawValue
 cell.selectionStyle = .none
 cell.accessoryView = nil
 if bottomSheetViewModel.selectedOptions.contains(option) {
 let checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
 checkmarkImageView.tintColor = UIColor(named: "ButtonColor")
 cell.accessoryView = checkmarkImageView
 }
 return cell
 }
 
 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 let selectedOption = bottomSheetViewModel.options[indexPath.row]
 if let index = bottomSheetViewModel.selectedOptions.firstIndex(of: selectedOption) {
 bottomSheetViewModel.selectedOptions.remove(at: index)
 } else {
 bottomSheetViewModel.selectedOptions.append(selectedOption)
 }
 tableView.reloadRows(at: [indexPath], with: .none)
 }
 }
 */
