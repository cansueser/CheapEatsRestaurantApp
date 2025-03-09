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
    @objc func chooseLocation(gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: mapView)
            let touchCoordinate: CLLocationCoordinate2D = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            chosenLatitude = touchCoordinate.latitude
            chosenLongitude = touchCoordinate.longitude
            
            let annotation: MKPointAnnotation = MKPointAnnotation()
            annotation.coordinate = touchCoordinate
            annotation.title = "Restoran konumu"
            mapView.addAnnotation(annotation)
            print(annotation)
            getAddressFromCoordinates(latitude: touchCoordinate.latitude, longitude: touchCoordinate.longitude) { address in
                if let address = address {
                    print("Seçilen Konumun Adresi: \(address)")
                } else {
                    print("Adres bulunamadı.")
                }
            }
            
        }
    }
        func getAddressFromCoordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (String?) -> Void) {
            let geocoder = CLGeocoder()
            let location = CLLocation(latitude: latitude, longitude: longitude)
            
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    print("Ters geokodlama hatası: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                if let placemark = placemarks?.first {
                    var addressString = ""
                    
                    if let street = placemark.thoroughfare {
                        addressString += street + ", "
                    }
                    if let city = placemark.locality {
                        addressString += city + ", "
                    }
                    if let state = placemark.administrativeArea {
                        addressString += state + ", "
                    }
                    if let country = placemark.country {
                        addressString += country
                    }
                    
                    completion(addressString)
                } else {
                    completion(nil)
                }
            }
        }
        
    }

