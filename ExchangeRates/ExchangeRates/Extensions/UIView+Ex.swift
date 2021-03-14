//
//  UIView+Ex.swift
//  ExchangeRates
//
//  Created by Сергей Иотченко on 18.02.21.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach {
            self.addSubview($0)
        }
    }
}
