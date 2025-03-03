//
//  MapDetailViewController.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 3.03.2025.
//

import UIKit
import MapKit
import JVFloatLabeledTextField

class MapDetailViewController: UIViewController {
    // MARK: - Variables
    @IBOutlet weak var provinceBackView: UIView!
    @IBOutlet weak var districtButtonBackView: UIView!
    @IBOutlet weak var neighbourhoodButtonBackView: UIView!
    @IBOutlet weak var streetTextFieldBackView: UIView!
    @IBOutlet weak var buildingNumberBackView: UIView!
    @IBOutlet weak var directionsBackView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var provinceTextField: JVFloatLabeledTextField!
    @IBOutlet weak var districtButton: UIButton!
    @IBOutlet weak var neighbourhoodButton: UIButton!
    @IBOutlet weak var streetTextField: JVFloatLabeledTextField!
    @IBOutlet weak var buildingNumberTextField: JVFloatLabeledTextField!
    @IBOutlet weak var directionsTextField: JVFloatLabeledTextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    func initView() {
        provinceBackView.addRoundedBorder(cornerRadius: 2,borderWidth: 1, borderColor: .iconBG)
        districtButtonBackView.addRoundedBorder(cornerRadius: 2,borderWidth: 1, borderColor: .iconBG)
        neighbourhoodButtonBackView.addRoundedBorder(cornerRadius: 2,borderWidth: 1, borderColor: .iconBG)
        streetTextFieldBackView.addRoundedBorder(cornerRadius: 2,borderWidth: 1, borderColor: .iconBG)
        directionsBackView.addRoundedBorder(cornerRadius: 2,borderWidth: 1, borderColor: .iconBG)
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
    }
    
}
