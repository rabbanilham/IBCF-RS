//
//  UIStackView+Extension.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 25/03/23.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }
}
