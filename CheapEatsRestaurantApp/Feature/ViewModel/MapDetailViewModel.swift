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
    var dataSource:  [String] { get set }
    func centerMapToLocation(mapView: MKMapView)
    func selectedData(with status: Bool)
    func getData()
    func getDistrict(cityName: String)
    func clearDistrictData()
    func checkLocation(cityButton: UIButton, districtButton: UIButton)
    func loadLocationFromRestaurant()
    func updateRestaurantAddress(mapLocation: MapLocation)
}

protocol MapDetailViewModelOutputProtocol: AnyObject {
    func update()
    func error()
    func updateSuccess()
    func updateFailed(error: String)
    func showLoading()
    func hideLoading()
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
    
    func loadLocationFromRestaurant() {
        guard let restaurant = RestaurantManager.shared.restaurant else { return }
        var mapLocation = MapLocation(
            latitude: restaurant.location.latitude,
            longitude: restaurant.location.longitude
        )
        
        var address = restaurant.address
        
        if let directionsStart = address.range(of: "(") {
            let directionsEnd = address.range(of: ")")?.upperBound ?? address.endIndex
            let directionsRange = directionsStart.lowerBound..<directionsEnd
            let directionsText = String(address[directionsRange])
            mapLocation.directions = directionsText.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
            address = address.replacingCharacters(in: directionsRange, with: "").trimmingCharacters(in: .whitespaces)
        }

        if let slashIndex = address.lastIndex(of: "/") {
            let cityPart = String(address.suffix(from: address.index(after: slashIndex))).trimmingCharacters(in: .whitespaces)
            mapLocation.city = cityPart
            
        
            let beforeSlash = String(address.prefix(upTo: slashIndex))
            
            if let lastCommaIndex = beforeSlash.lastIndex(of: ",") {
                let districtPart = String(beforeSlash.suffix(from: beforeSlash.index(after: lastCommaIndex))).trimmingCharacters(in: .whitespaces)
                mapLocation.district = districtPart
                
                let remainingAddress = String(beforeSlash.prefix(upTo: lastCommaIndex))
                let parts = remainingAddress.components(separatedBy: ", ")
                
                if parts.count >= 1 {
                    mapLocation.buildingNumber = parts[0].trimmingCharacters(in: .whitespaces)
                }
                if parts.count >= 2 {
                    mapLocation.neighbourhood = parts[1].trimmingCharacters(in: .whitespaces)
                }
                if parts.count >= 3 {
                    mapLocation.street = parts[2].trimmingCharacters(in: .whitespaces)
                }
            } else {
                mapLocation.district = beforeSlash.trimmingCharacters(in: .whitespaces)
            }
        } else {
            let parts = address.components(separatedBy: ", ")
            
            if parts.count >= 1 {
                mapLocation.buildingNumber = parts[0].trimmingCharacters(in: .whitespaces)
            }
            if parts.count >= 2 {
                mapLocation.neighbourhood = parts[1].trimmingCharacters(in: .whitespaces)
            }
            if parts.count >= 3 {
                mapLocation.street = parts[2].trimmingCharacters(in: .whitespaces)
            }
        }
        
        self.location = mapLocation
    }
    
    func updateRestaurantAddress(mapLocation: MapLocation) {
        guard let restaurant = RestaurantManager.shared.restaurant else { return }
        
        delegate?.showLoading()
        
        self.location = mapLocation
        
        let fullAddress = mapLocation.getAddress()
        let newLocation = Location(latitude: mapLocation.latitude, longitude: mapLocation.longitude)
        
        NetworkManager.shared.updateAddress(restaurantId: restaurant.restaurantId, address: fullAddress, location: newLocation) { [weak self] result in
            DispatchQueue.main.async {
                self?.delegate?.hideLoading()
                
                switch result {
                case .success:
                    if RestaurantManager.shared.restaurant != nil {
                        RestaurantManager.shared.updateRestaurantAddress(address: fullAddress, location: newLocation)
                    } else {

                    }
                    self?.delegate?.updateSuccess()
                case .failure(let error):
                    self?.delegate?.updateFailed(error: error.localizedDescription)
                }
            }
        }
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
