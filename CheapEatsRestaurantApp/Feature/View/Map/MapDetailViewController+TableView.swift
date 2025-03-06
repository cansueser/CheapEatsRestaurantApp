//
//  MapDetailViewController+TableView.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 6.03.2025.
//

import UIKit

extension MapDetailViewController :UITableViewDataSource ,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mapDetailViewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = mapDetailViewModel.dataSource[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedButton.setTitle(mapDetailViewModel.dataSource[indexPath.row], for: .normal)
        removetrasparentView()
        if selectedButton == provinceButton {
            districtButton.setTitle("İlçe", for: .normal)
            districtButton.isEnabled = true
            mapDetailViewModel.clearDistrictData()
        }
    }
}
