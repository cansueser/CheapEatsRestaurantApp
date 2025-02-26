//
//  ProductManageViewController+EastTipView.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 26.02.2025.
//
import UIKit
import EasyTipView

extension ProductManageViewController:  UIToolTipInteractionDelegate ,EasyTipViewDelegate {
    
    func easyTipViewDidTap(_ tipView: EasyTipView) {
        tipView.dismiss()
    }
   
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        preferences.animating.dismissTransform = CGAffineTransform(translationX: 0, y: -15)
        preferences.animating.showInitialTransform = CGAffineTransform(translationX: 0, y: -15)
        preferences.animating.showInitialAlpha = 0
        preferences.animating.showDuration = 1.5
        preferences.animating.dismissDuration = 1.5
    }
    
    func showToolTip() {
        tipView = EasyTipView(text: "Önerilen sabit indirimler!",
                              preferences: self.preferences,
                              delegate: self)
        tipView?.show(forView: self.infoButton, withinSuperview: self.mainView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tipView?.dismiss()
            self.tipView = nil
        }
    }
}
