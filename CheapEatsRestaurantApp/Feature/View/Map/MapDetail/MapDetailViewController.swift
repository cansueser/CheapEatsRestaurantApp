//
//  MapDetailViewController.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 3.03.2025.
//

import UIKit
import MapKit
import JVFloatLabeledTextField

final class MapDetailViewController: UIViewController {
    // MARK: - Variables
    @IBOutlet weak var provinceBackView: UIView!
    @IBOutlet weak var districtButtonBackView: UIView!
    @IBOutlet weak var neighbourhoodButtonBackView: UIView!
    @IBOutlet weak var streetTextFieldBackView: UIView!
    @IBOutlet weak var buildingNumberBackView: UIView!
    @IBOutlet weak var directionsBackView: UIView!
    @IBOutlet weak var detailMapView: MKMapView!
    @IBOutlet weak var provinceButton: UIButton!
    @IBOutlet weak var districtButton: UIButton!
    @IBOutlet weak var neighbourhoodTextField: JVFloatLabeledTextField!
    @IBOutlet weak var streetTextField: JVFloatLabeledTextField!
    @IBOutlet weak var buildingNumberTextField: JVFloatLabeledTextField!
    @IBOutlet weak var directionsTextField: JVFloatLabeledTextField!
    @IBOutlet weak var saveButton: UIButton!
    var mapDetailViewModel: MapDetailViewModelProtocol = MapDetailViewModel()
    let transparentView = UIView()
    let tableview = UITableView()
    var selectedButton = UIButton()
    var registerVC: RegisterViewController?
    var profileVC: ProfileSettingsViewController?
    var isFromProfile: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initTableView()
        mapViewConrol()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
        
        mapDetailViewModel.centerMapToLocation(mapView: detailMapView)
        mapDetailViewModel.checkLocation(cityButton: provinceButton, districtButton: districtButton)
        if isFromProfile {
            loadRestaurantDetailsForProfile()
            saveButton.setTitle("Kaydet", for: .normal)
        } else {
            saveButton.setTitle("Kaydet", for: .normal)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
  
    private func initView() {
        mapDetailViewModel.delegate = self
        provinceBackView.addRoundedBorder(cornerRadius: 2,borderWidth: 1, borderColor: .iconBG)
        districtButtonBackView.addRoundedBorder(cornerRadius: 2,borderWidth: 1, borderColor: .iconBG)
        neighbourhoodButtonBackView.addRoundedBorder(cornerRadius: 2,borderWidth: 1, borderColor: .iconBG)
        streetTextFieldBackView.addRoundedBorder(cornerRadius: 2,borderWidth: 1, borderColor: .iconBG)
        directionsBackView.addRoundedBorder(cornerRadius: 2,borderWidth: 1, borderColor: .iconBG)
        buildingNumberBackView.addRoundedBorder(cornerRadius: 2,borderWidth: 1, borderColor: .iconBG)
        setShadow(with: provinceBackView.layer, shadowOffset: true)
        setShadow(with: districtButtonBackView.layer, shadowOffset: true)
        setShadow(with: neighbourhoodButtonBackView.layer, shadowOffset: true)
        setShadow(with: streetTextFieldBackView.layer, shadowOffset: true)
        setShadow(with: directionsBackView.layer, shadowOffset: true)
        setShadow(with: buildingNumberBackView.layer, shadowOffset: true)
        saveButton.makeRounded(radius: 5)
        mapDetailViewModel.getData()
    }
    
    private func mapViewConrol(){
        mapDetailViewModel.selectedData(with: true)
        detailMapView.isScrollEnabled = false
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        detailMapView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func handleTap() {
        navigationController?.popViewController(animated: true)
    }
    
    private func initTableView() {
        tableview.clipsToBounds = true
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(DropDownCell.self, forCellReuseIdentifier: "Cell")
        tableview.layer.cornerRadius = 5
        
    }
    
    private func addTrasparentView(frames: CGRect) {
        let convertedFrame = selectedButton.convert(selectedButton.bounds, to: self.view)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,let window = windowScene.keyWindow {
            transparentView.frame = window.frame
            self.view.addSubview(transparentView)
            self.view.addSubview(tableview)
        }
        
        tableview.frame = CGRect(
            x: convertedFrame.origin.x,
            y: convertedFrame.origin.y + convertedFrame.height,
            width: convertedFrame.width,
            height: 0
        )
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        tableview.reloadData()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(removetrasparentView))
        transparentView.addGestureRecognizer(tapGestureRecognizer)
        
        transparentView.alpha = 0.0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping:1.0, initialSpringVelocity: 1.0,options: .curveEaseInOut, animations:{
            self.transparentView.alpha = 0.5
            let height: CGFloat = self.mapDetailViewModel.dataSource.count > 8 ? 400 : CGFloat(self.mapDetailViewModel.dataSource.count * 50)
            self.tableview.frame = CGRect(x: convertedFrame.origin.x, y: convertedFrame.origin.y + convertedFrame.height, width: convertedFrame.width, height: height)
            
        }, completion: nil)
    }
    
    @objc func removetrasparentView () {
        let frames = selectedButton.convert(selectedButton.bounds, to: self.view)
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0,options: .curveEaseInOut, animations:{
            self.transparentView.alpha = 0
            self.tableview.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: 0)
        }, completion:{ _ in
            self.transparentView.removeFromSuperview()
            self.tableview.removeFromSuperview()
        }
        )
    }
    
    @IBAction func provinceButtonClicked(_ sender: UIButton) {
        mapDetailViewModel.selectedData(with: true)
        selectedButton = provinceButton
        self.view.layoutIfNeeded()
        addTrasparentView(frames: provinceButton.frame)
        
        districtButton.setTitle("İlçe", for: .normal)
        districtButton.isEnabled = false
        mapDetailViewModel.clearDistrictData()
    }
    
    @IBAction func districtButtonClicked(_ sender: UIButton) {
        mapDetailViewModel.getDistrict(cityName:  provinceButton.titleLabel?.text ?? "")
        mapDetailViewModel.selectedData(with: false)
        selectedButton = districtButton
        self.view.layoutIfNeeded()
        addTrasparentView(frames: districtButton.frame)
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        if districtButton.titleLabel?.text == "İlçe" && provinceButton.titleLabel?.text == "İl" {
            showOneButtonAlert(title: "Hata", message: "İl veya İlçe seçmediniz!")
            return
        }
        guard let provinceName = provinceButton.titleLabel?.text, let districtName = districtButton.titleLabel?.text ,let neighbourhood = neighbourhoodTextField.text, let street = streetTextField.text ,let buildingNumber = buildingNumberTextField.text, let directions = directionsTextField.text else { return }
        if let location = mapDetailViewModel.location {
            let mapLocation = MapLocation(latitude: location.latitude, longitude: location.longitude, city: provinceName, district: districtName, neighbourhood: neighbourhood, street: street, buildingNumber: buildingNumber, directions: directions)
            
            if isFromProfile {
                mapDetailViewModel.updateRestaurantAddress(mapLocation: mapLocation)
            } else {
                NotificationCenter.default.post(name: NSNotification.Name("MapUpdated"), object: mapLocation)
                navigationController?.popToViewController(registerVC!, animated: true)
            }
        }
        
        
    }
    
    func loadCurrentRestaurantDetails() {
        guard let mapLocation = mapDetailViewModel.location else { return }

        neighbourhoodTextField.text = mapLocation.neighbourhood
        streetTextField.text = mapLocation.street
        buildingNumberTextField.text = mapLocation.buildingNumber
        directionsTextField.text = mapLocation.directions
    }
    
    func loadRestaurantDetailsForProfile() {
        guard RestaurantManager.shared.restaurant != nil else { return }

        let currentLocation = mapDetailViewModel.location

        mapDetailViewModel.loadLocationFromRestaurant()

        if let currentLocation = currentLocation {
            mapDetailViewModel.location?.latitude = currentLocation.latitude
            mapDetailViewModel.location?.longitude = currentLocation.longitude
        }

        if let mapLocation = mapDetailViewModel.location {
            neighbourhoodTextField.text = mapLocation.neighbourhood
            streetTextField.text = mapLocation.street
            buildingNumberTextField.text = mapLocation.buildingNumber
            directionsTextField.text = mapLocation.directions
        }
    }
    
}
extension MapDetailViewController :MapDetailViewModelOutputProtocol {
    func update() {
        print("update")
    }
    
    func error() {
        print("error")
    }
    
    func showLoading() {
        let loadingAlert = UIAlertController(title: "Güncelleniyor", message: "Adres bilgileriniz güncelleniyor...", preferredStyle: .alert)
        self.present(loadingAlert, animated: true)
    }
    
    func hideLoading() {
        if let presentedViewController = self.presentedViewController as? UIAlertController {
            presentedViewController.dismiss(animated: true)
        }
    }
    
    func updateSuccess() {
        showOneButtonAlert(title: "Başarılı", message: "Adres bilgileriniz güncellendi.", buttonTitle: "Tamam") { _ in
            self.navigationController?.popToViewController(self.profileVC!, animated: true)
        }
    }
    
    func updateFailed(error: String) {
        let alert = UIAlertController(title: "Hata", message: "Adres güncellenirken bir hata oluştu: \(error)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        self.present(alert, animated: true)
    }
}
