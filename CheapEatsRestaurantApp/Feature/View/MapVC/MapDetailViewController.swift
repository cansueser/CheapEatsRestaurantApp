//
//  MapDetailViewController.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 3.03.2025.
//

import UIKit
import MapKit
import JVFloatLabeledTextField
class CellClass: UITableViewCell {}
class MapDetailViewController: UIViewController {
    // MARK: - Variables
@IBOutlet weak var provinceBackView: UIView!
@IBOutlet weak var districtButtonBackView: UIView!
@IBOutlet weak var neighbourhoodButtonBackView: UIView!
@IBOutlet weak var streetTextFieldBackView: UIView!
@IBOutlet weak var buildingNumberBackView: UIView!
    @IBOutlet weak var directionsBackView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var provinceButton: UIButton!
    @IBOutlet weak var districtButton: UIButton!
    @IBOutlet weak var neighbourhoodTextField: JVFloatLabeledTextField!
    @IBOutlet weak var streetTextField: JVFloatLabeledTextField!
    @IBOutlet weak var buildingNumberTextField: JVFloatLabeledTextField!
    @IBOutlet weak var directionsTextField: JVFloatLabeledTextField!
    @IBOutlet weak var saveButton: UIButton!
    
    let transparentView = UIView()
    let tableview = UITableView()
    var selectedButton = UIButton()
    var dataSource = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
    }
    func initView() {
        tableview.clipsToBounds = true
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(CellClass.self, forCellReuseIdentifier: "Cell")
        tableview.layer.cornerRadius = 5
        provinceBackView.addRoundedBorder(cornerRadius: 2,borderWidth: 1, borderColor: .iconBG)
        districtButtonBackView.addRoundedBorder(cornerRadius: 2,borderWidth: 1, borderColor: .iconBG)
        neighbourhoodButtonBackView.addRoundedBorder(cornerRadius: 2,borderWidth: 1, borderColor: .iconBG)
        streetTextFieldBackView.addRoundedBorder(cornerRadius: 2,borderWidth: 1, borderColor: .iconBG)
        directionsBackView.addRoundedBorder(cornerRadius: 2,borderWidth: 1, borderColor: .iconBG)
    }
    
    func addTrasparentView(frames: CGRect) {
        let convertedFrame = selectedButton.convert(selectedButton.bounds, to: self.view)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,let window = windowScene.keyWindow {
            transparentView.frame = window.frame ?? self.view.frame
            self.view.addSubview(transparentView)
            self.view.addSubview(tableview)
        }
        
         tableview.frame = CGRect(
            x: convertedFrame.origin.x,
            y: convertedFrame.origin.y + convertedFrame.height, // Dönüştürülmüş y değeri
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
            self.tableview.frame = CGRect(x: convertedFrame.origin.x, y: convertedFrame.origin.y + convertedFrame.height, width: convertedFrame.width, height: CGFloat(self.dataSource.count * 50))
            
        }, completion: nil)
    }
    @objc func removetrasparentView () {
        let frames = selectedButton.convert(selectedButton.bounds, to: self.view)
        //let frames = selectedButton.frame
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
        dataSource = ["Çorum","Ankara","Bolu","Urfa","Antep","Tokat","Samsun","Rize","Amasya"]
        selectedButton = provinceButton
        self.view.layoutIfNeeded() // provinceButtonClicked içinde
        addTrasparentView(frames: provinceButton.frame)
        
    }
    
    @IBAction func districtButtonClicked(_ sender: UIButton) {
        dataSource =  ["İskilip","Merkez","Laçin","OrtaKöy","altındağ","bahçelievler","buhara","keçiören"]
        selectedButton = districtButton
        self.view.layoutIfNeeded() // provinceButtonClicked içinde
        addTrasparentView(frames: districtButton.frame)
        
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
    }
    
}
extension MapDetailViewController :UITableViewDataSource ,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedButton.setTitle(dataSource[indexPath.row], for: .normal)
        removetrasparentView()
        
    }
}
