//
//  MapViewController.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 3.03.2025.
//

import UIKit
import MapKit
import CoreLocation
import GooglePlaces


final class MapViewController: UIViewController, HandleMapSearch {
    
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
        var registerVC: RegisterViewController?
    var resultSearchController:UISearchController? = nil
    var selectedPin:MKPlacemark?
    var lastAnnotation: MKPointAnnotation?

        override func viewDidLoad() {
            super.viewDidLoad()
            initView()
            mapControlView()
            mapViewModel.delegate = self
            //saveButton.isEnabled = false
           // mapView = MKMapView(frame: view.bounds)
           // view.addSubview(mapView)
            let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
            locationSearchTable.mapView = mapView
                   locationSearchTable.handleMapSearchDelegate = self

            resultSearchController = UISearchController(searchResultsController: locationSearchTable)
            resultSearchController?.searchResultsUpdater = locationSearchTable
            let searchBar = resultSearchController!.searchBar
            searchBar.sizeToFit()
            searchBar.placeholder = "Search for places"
            navigationItem.searchController = resultSearchController
            resultSearchController?.hidesNavigationBarDuringPresentation = false
            resultSearchController?.dimsBackgroundDuringPresentation = true
            definesPresentationContext = true
            locationSearchTable.mapView = mapView
            locationSearchTable.handleMapSearchDelegate = self
            
            
        }
        
        func initView() {
            mapImage.makeRounded(radius: 5)
            toolTipImage.makeRounded(radius: 5)
            saveButton.makeRounded(radius: 5)
            searchBar.addRoundedBorder(cornerRadius: 5, borderWidth: 1, borderColor: .button)
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
           
           // Tüm pinleri al
           let allAnnotations = mapView.annotations
           
           // En son eklenen pin hariç diğerlerini sil
           for annotation in allAnnotations {
               if annotation !== lastAnnotation {
                   mapView.removeAnnotation(annotation)
               }
           }
       }

  /*  func dropPinZoomIn(placemark: MKPlacemark) {
        selectedPin = placemark
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality, let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)}*/


    
        
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
