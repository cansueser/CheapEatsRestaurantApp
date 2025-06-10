//
//  ShowBanner.swift
//  CheapEatsRestaurantApp
//
//  Created by CANSU on 10.06.2025.
//

import SwiftEntryKit
import UIKit

protocol ShowBanner {
    func showOrderNotificationBanner(orderNo: String, quantity: Int)
}

extension ShowBanner {
    func showOrderNotificationBanner(orderNo: String, quantity: Int) {
        var attributes = EKAttributes.topNote
        attributes.displayDuration = .infinity
        attributes.entryInteraction = .dismiss
        attributes.screenInteraction = .forward
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)

        let backgroundColor = EKColor(UIColor(named: "title") ?? .title)
        attributes.entryBackground = .color(color: backgroundColor)

        let title = EKProperty.LabelContent(
            text: "Yeni Sipariş!",
            style: .init(font: .boldSystemFont(ofSize: 16), color: .white)
        )
        let description = EKProperty.LabelContent(
            text: "\(orderNo) numaralı sipariş – \(quantity) adet ürün",
            style: .init(font: .systemFont(ofSize: 14), color: .white)
        )
        let simpleMessage = EKSimpleMessage(title: title, description: description)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        let contentView = EKNotificationMessageView(with: notificationMessage)

        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
}

extension UIViewController: ShowBanner {}
extension HomeViewModel: ShowBanner {}
