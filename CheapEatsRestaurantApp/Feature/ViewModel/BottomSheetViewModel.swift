//
//  BottomSheetViewModel.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 30.01.2025.
//

import UIKit
import Foundation

protocol BottomSheetViewModelProtocol {
    var delegate: BottomSheetViewModelOutputProtocol? { get set }
    var options: [Category] { get }
    var selectedOptions: [Category] { get set }
    func clearSelection(tableView: UITableView)
}

protocol BottomSheetViewModelOutputProtocol: AnyObject {
    func didChangeSelection()
}

protocol BottomSheetViewModelDelegate: AnyObject {
    func didApplySelection(selectedOptions: [Category])
}

final class BottomSheetViewModel {
    var options = Category.allCases
    var selectedOptions: [Category] = []
    weak var delegate: BottomSheetViewModelOutputProtocol?

    func clearSelection(tableView: UITableView) {
        selectedOptions.removeAll()
        if let selectedRows = tableView.indexPathsForSelectedRows {
            for indexPath in selectedRows {
                tableView.deselectRow(at: indexPath, animated: false)
            }
        }
        delegate?.didChangeSelection()
    }
}
extension BottomSheetViewModel: BottomSheetViewModelProtocol {}
