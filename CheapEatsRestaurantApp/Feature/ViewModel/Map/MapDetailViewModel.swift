//
//  MapDetailViewModel.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 3.03.2025.
//

import UIKit
import MapKit

protocol MapDetailViewModelProtocol {
    var delegate: MapDetailViewModelOutputProtocol? { get set}
    var location: MapLocation? { get set }
    func centerMapToLocation(mapView: MKMapView)
    var dataSource:  [String] { get set }
    func selectedData(with status: Bool)
    func getData()
    func getDistrict(cityName: String)
    func clearDistrictData()
    func checkLocation(cityButton: UIButton, districtButton: UIButton)
}

protocol MapDetailViewModelOutputProtocol: AnyObject {
    func update()
    func error()
}

final class MapDetailViewModel {
    weak var delegate: MapDetailViewModelOutputProtocol?
    var location: MapLocation?
    var cityJSONData: [City] = []
    var dataSource: [String] = []
    private var cityData: [String] = []
    private var districtData: [String] = []
    
    func centerMapToLocation(mapView: MKMapView) {
        guard let latitude = location?.latitude, let longitude = location?.longitude else { return }
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Seçtiğin konum"
        mapView.addAnnotation(annotation)
    }
    
    func checkLocation(cityButton: UIButton, districtButton: UIButton) {
        if let locationCity = location?.city, let locationDistrict = location?.district {
            if let selectedCity = cityJSONData.first(where: { $0.ilAdi == locationCity }) {
                let districtNames = selectedCity.ilceler.map { $0.ilceAdi }
                cityButton.setTitle(locationCity, for: .normal)
                districtButton.isEnabled = true
                if
                    !districtNames.contains(locationDistrict.turkishUppercased()) {
                    self.location?.district = ""
                    districtButton.setTitle("İlçe", for: .normal)
                } else{
                    districtButton.setTitle(locationDistrict, for: .normal)
                }
            }else{
                cityButton.setTitle("İl", for: .normal)
                districtButton.setTitle("İlçe", for: .normal)
                location?.city = ""
                location?.district = ""
            }
            
        }
    }
    
    
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
            districtData = selectedCity.ilceler.map { $0.ilceAdi.capitalized}
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
