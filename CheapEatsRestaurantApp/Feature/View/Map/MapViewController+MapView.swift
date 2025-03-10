//
//  MapViewController+MapView.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 9.03.2025.
//
import MapKit
import CoreLocation

extension MapViewController: MKMapViewDelegate, CLLocationManagerDelegate  {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    @objc func chooseLocation(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            mapView.removeAnnotations(mapView.annotations)
            let touchPoint = gestureRecognizer.location(in: mapView)
            let touchCoordinate: CLLocationCoordinate2D = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            mapViewModel.location = MapLocation(latitude: touchCoordinate.latitude, longitude: touchCoordinate.longitude)
            
            let annotation: MKPointAnnotation = MKPointAnnotation()
            annotation.coordinate = touchCoordinate
            annotation.title = "Restoran konumu"
            mapView.addAnnotation(annotation)
            
            getAddressFromCoordinates(latitude: touchCoordinate.latitude, longitude: touchCoordinate.longitude)
            
        }
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
    
    
}

