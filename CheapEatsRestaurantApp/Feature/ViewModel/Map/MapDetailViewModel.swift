//
//  MapDetailViewModel.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 3.03.2025.
//

import UIKit

protocol MapDetailViewModelProtocol {
    var delegate: MapDetailViewModelOutputProtocol? { get set}
    var dataSource:  [String] { get set }
    func selectedData(with status: Bool)
    func getData()
    func getDistrict(cityName: String)
    func clearDistrictData()
}

protocol MapDetailViewModelOutputProtocol: AnyObject {
    func update()
    func error()
}

final class MapDetailViewModel {
    weak var delegate: MapDetailViewModelOutputProtocol?
    var cityJSONData: [City] = []
    var dataSource: [String] = []
    private var cityData: [String] = []
    private var districtData: [String] = []
    
    func selectedData(with status: Bool) {
        if status {
            dataSource = cityData
        } else {
            dataSource = districtData
        }
    }
    
    func getData() {
        cityJSONData = loadJson(filename: "CityDistrict") ?? []
        cityData = cityJSONData.map{$0.ilAdi}
    }
    
    func getDistrict(cityName: String) {
        if let selectedCity = cityJSONData.first(where: { $0.ilAdi == cityName }) {
            districtData = selectedCity.ilceler.map { $0.ilceAdi }
        } else {
            districtData = []
        }
    }
    func clearDistrictData() {
        districtData = []
    }
    
    private func loadJson(filename fileName: String) -> [City]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(CityData.self, from: data)
                return jsonData.data
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
}
    

extension MapDetailViewModel : MapDetailViewModelProtocol{}
