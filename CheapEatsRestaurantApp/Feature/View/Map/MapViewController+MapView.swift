//
//  MapViewController+MapView.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 9.03.2025.
//
import MapKit
import CoreLocation

extension MapViewController: MKMapViewDelegate, CLLocationManagerDelegate  {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithErrorerror:: \(error)")
    }
    @objc func chooseLocation(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: mapView)
            let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            addAnnotationAndUpdateLocation(coordinate: touchCoordinate)
        }
    }
    
    func dropPinZoomIn(placemark: MKPlacemark) {
        let coordinate = placemark.coordinate
        let title = placemark.name
        let subtitle = "\(placemark.locality ?? ""), \(placemark.administrativeArea ?? "")"
        addAnnotationAndUpdateLocation(coordinate: coordinate, title: title, subtitle: subtitle)
    }
    func addAnnotationAndUpdateLocation(coordinate: CLLocationCoordinate2D, title: String? = nil, subtitle: String? = nil) {
        clearAllAnnotationsExceptLast()

        mapView.removeAnnotations(mapView.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title ?? "Restoran konumu"
        annotation.subtitle = subtitle
        mapView.addAnnotation(annotation)
        lastAnnotation = annotation

        mapViewModel.location = MapLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        saveButton.isEnabled = true
        getAddressFromCoordinates(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    func getAddressFromCoordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Ters geokodlama hatası: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first {
                if let district = placemark.locality {
                    self.mapViewModel.location?.district = district
                }
                if let city = placemark.administrativeArea {
                    self.mapViewModel.location?.city = city
                }
                if let country = placemark.country {
                    self.mapViewModel.location?.country = country
                }
            }
        }
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? MKPointAnnotation {
            clearAllAnnotationsExceptLast()
            lastAnnotation = annotation
            let coordinate = annotation.coordinate
            mapViewModel.location = MapLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            getAddressFromCoordinates(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
    }}
