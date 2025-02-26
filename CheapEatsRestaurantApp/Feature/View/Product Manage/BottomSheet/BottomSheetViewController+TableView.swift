//
//  BottomSheetViewController+TableView.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 26.02.2025.
//
import UIKit

extension BottomSheetViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bottomSheetViewModel.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let option = bottomSheetViewModel.options[indexPath.row]
        cell.textLabel?.text = option.rawValue
        cell.selectionStyle = .none
        cell.accessoryView = nil
        if bottomSheetViewModel.selectedOptions.contains(option) {
            let checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
            checkmarkImageView.tintColor = UIColor(.yeşil)
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
