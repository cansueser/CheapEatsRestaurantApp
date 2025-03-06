//
//  MapViewModel.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 3.03.2025.
//

import UIKit

protocol MapViewModelProtocol{
    var delegate: MapViewModelOutputProtocol? { get set}
}

protocol MapViewModelOutputProtocol: AnyObject {
    func update()
    func error()
}

final class MapViewModel {
    weak var delegate: MapViewModelOutputProtocol?
}


extension MapViewModel : MapViewModelProtocol{}
