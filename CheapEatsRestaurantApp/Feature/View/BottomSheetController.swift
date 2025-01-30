//
//  BottomSheetController.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 30.01.2025.
//

import Foundation

import UIKit
import UIKit

final class BottomSheetViewController: UIViewController {
    //MARK: -Variables
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var applyButton: UIButton!
    var bottomSheetViewModel: BottomSheetViewModelProtocol = BottomSheetViewModel()
    weak var delegate: BottomSheetViewModelDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        bottomSheetViewModel.delegate = self
        configureView(applyButton, cornerRadius: 10)
    }

    func setupNavigationBar() {
        let clearButton = UIBarButtonItem(title: "Temizle", style: .plain, target: self, action: #selector(clearButtonTapped))
        clearButton.tintColor = UIColor(named: "ButtonColor")
        navigationItem.rightBarButtonItem = clearButton
        navigationItem.title = "Yemek Türleri"
        let cancelButton = UIBarButtonItem(title: "İptal", style: .plain, target: self, action: #selector(cancelButtonTapped))
        cancelButton.tintColor = UIColor(named: "CutColor")
        navigationItem.leftBarButtonItem = cancelButton
        navigationBar.setItems([navigationItem], animated: false)
    }

    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsMultipleSelection = true
    }

    @IBAction func applyButtonClicked(_ sender: Any) {
        delegate?.didApplySelection(selectedOptions: bottomSheetViewModel.selectedOptions)
        dismiss(animated: true)
    }

    @objc private func clearButtonTapped() {
        bottomSheetViewModel.clearSelection(tableView: tableView)
    }

    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
}

extension BottomSheetViewController: BottomSheetViewModelOutputProtocol {
    func didChangeSelection() {
        tableView.reloadData()
    }
}
