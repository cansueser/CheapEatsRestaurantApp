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
    var mapDetailVC : MapDetailViewController?
    var locationManager = CLLocationManager()
    var mapViewModel: MapViewModelProtocol = MapViewModel()
    var registerVC: RegisterViewController?
    var profileVC: ProfileSettingsViewController?
    var isFromProfile: Bool = false
    
    var selectedPin:MKPlacemark?
    var lastAnnotation: MKPointAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        mapControlView()
        mapViewModel.delegate = self
        saveButton.isEnabled = false

        if isFromProfile {
            loadCurrentRestaurantLocation()
            saveButton.setTitle("Düzenle", for: .normal)
        } else {
            saveButton.setTitle("Kaydet", for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFromProfile {
            centerMapToCurrentRestaurantLocation()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func initView() {
        mapImage.makeRounded(radius: 5)
        toolTipImage.makeRounded(radius: 5)
        saveButton.makeRounded(radius: 5)
    }
    
    func mapControlView(){
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        // gestureRecognizer.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(gestureRecognizer)
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.requestLocation()

    }
    func clearAllAnnotationsExceptLast() {
        guard let lastAnnotation = lastAnnotation else { return }
        
        let allAnnotations = mapView.annotations

        for annotation in allAnnotations {
            if annotation !== lastAnnotation {
                mapView.removeAnnotation(annotation)
            }
        }
    }
    
    func loadCurrentRestaurantLocation() {
        guard let restaurant = RestaurantManager.shared.restaurant else { return }
        
        let latitude = restaurant.location.latitude
        let longitude = restaurant.location.longitude
        
        guard latitude != 0.0 && longitude != 0.0 else { return }
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        mapView.removeAnnotations(mapView.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Mevcut Konum"
        annotation.subtitle = restaurant.address
        mapView.addAnnotation(annotation)
        lastAnnotation = annotation
        
        mapViewModel.location = MapLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: false)
        
        saveButton.isEnabled = true
        
        getAddressFromCoordinates(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    func centerMapToCurrentRestaurantLocation() {
        guard let restaurant = RestaurantManager.shared.restaurant else { return }
        
        let latitude = restaurant.location.latitude
        let longitude = restaurant.location.longitude
        
        guard latitude != 0.0 && longitude != 0.0 else { return }
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
        
        if mapView.annotations.isEmpty {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "Mevcut Konum"
            annotation.subtitle = restaurant.address
            mapView.addAnnotation(annotation)
            lastAnnotation = annotation
        }
    }
    
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        //bunu tekrar düzenle
        /*if mapViewModel.location?.country != "Türkiye" {
         showOneButtonAlert(title: "Hata", message: "Seçtiğiniz konum Türkiye sınırları dışındadır. Lütfen Türkiye sınırları içinde bir konum seçip tekrar deneyiniz.")
         return
         }*/
        
        if mapDetailVC == nil{
            mapDetailVC = SB.instantiateViewController(withIdentifier: "MapDetailViewController") as? MapDetailViewController
        }
        
        if let mapDetailVC = mapDetailVC {
            mapDetailVC.mapDetailViewModel.location = mapViewModel.location
            mapDetailVC.registerVC = registerVC
            mapDetailVC.profileVC = profileVC
            mapDetailVC.isFromProfile = isFromProfile
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
