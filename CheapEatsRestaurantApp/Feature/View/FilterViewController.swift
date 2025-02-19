//
//  FilterViewController.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 11.12.2024.
//

import Foundation
import UIKit
final class FilterViewController: UIViewController {
    //MARK: -Variables
    weak var delegate: FilterTypeViewModelOutputProtocol?
    var filterDeliveryTypeViewModel: FilterTypeViewModelProtocol = FilterTypeViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // orderDeliveryType.layer.shadowOpacity = 0
    }
    override func viewWillAppear(_ animated: Bool) {
        //  distanceSegment.selectedSegmentIndex = filterDeliveryTypeViewModel.selectedDistance
    }
    
    @IBAction func distanceSegmentChanged(_ sender: UISegmentedControl) {
        //     filterDeliveryTypeViewModel.selectedDistance = sender.selectedSegmentIndex
        
    }
    
}

