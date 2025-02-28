//
//  LoadingIndicator.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 28.02.2025.
//

import UIKit
import NVActivityIndicatorView

extension UIViewController {
    func createLoadingIndicator(in view: UIView) -> NVActivityIndicatorView {
        let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let loadIndicator = NVActivityIndicatorView(
            frame: frame,
            type: .ballRotateChase,
            color: .button,
            padding: 0
        )
        loadIndicator.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        view.addSubview(loadIndicator)
        view.isHidden = true
        loadIndicator.isHidden = true
        return loadIndicator
    }
}
