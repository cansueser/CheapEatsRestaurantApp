//
//  MapViewController.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 3.03.2025.
//

import UIKit
import MapKit
import CoreLocation
class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    //MARK: - Variables
    @IBOutlet weak var mapImage: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var toolTipImage: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var saveButton: UIButton!
    let SB = UIStoryboard(name: "Main", bundle: nil)
    private var  mapDetailVC : MapDetailViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    
    func initView() {
        mapImage.makeRounded(radius: 5)
        toolTipImage.makeRounded(radius: 5)
        saveButton.makeRounded(radius: 5)
        searchBar.addRoundedBorder(cornerRadius: 5, borderWidth: 1, borderColor: .button)
    }
    
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        if mapDetailVC == nil{
            mapDetailVC = SB.instantiateViewController(withIdentifier: "MapDetailViewController") as? MapDetailViewController
        }
        
        if let mapDetailVC = mapDetailVC {
            navigationController?.pushViewController(mapDetailVC, animated: true)
        }
        
        
    }
}
