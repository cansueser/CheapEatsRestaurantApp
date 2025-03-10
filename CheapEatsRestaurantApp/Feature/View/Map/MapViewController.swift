//
//  MapViewController.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 3.03.2025.
//

import UIKit
import MapKit
import CoreLocation

final class MapViewController: UIViewController {
    //MARK: - Variables
    @IBOutlet weak var mapImage: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var toolTipImage: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var saveButton: UIButton!
    let SB = UIStoryboard(name: "Main", bundle: nil)
    var  mapDetailVC : MapDetailViewController?
    var locationManager = CLLocationManager()
    var mapViewModel: MapViewModelProtocol = MapViewModel()
    let geocoder = CLGeocoder()
    let address = "8787 Snouffer School Rd, Montgomery Village, MD 20879"
    var currentLocationStr = " "
    var city = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        mapControlView()
        mapViewModel.delegate = self
    }
    
    func initView() {
        mapImage.makeRounded(radius: 5)
        toolTipImage.makeRounded(radius: 5)
        saveButton.makeRounded(radius: 5)
        searchBar.addRoundedBorder(cornerRadius: 5, borderWidth: 1, borderColor: .button)
    }
    func mapControlView(){
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(gestureRecognizer)
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        if mapDetailVC == nil{
            mapDetailVC = SB.instantiateViewController(withIdentifier: "MapDetailViewController") as? MapDetailViewController
        }
        
        if let mapDetailVC = mapDetailVC {
            mapDetailVC.mapDetailViewModel.location = mapViewModel.location
            navigationController?.pushViewController(mapDetailVC, animated: true)
        }
        
        
    }
}
extension MapViewController: MapViewModelOutputProtocol {
    func update() {
        print("Update")
    }
    
    func error() {
        print("error")
    }
    
    
}
