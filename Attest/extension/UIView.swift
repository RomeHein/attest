//
//  UIView.swift
//  Attest
//
//  Created by Dev on 18/03/2020.
//  Copyright © 2020 Dev. All rights reserved.
//

import UIKit

extension UIView {
    func round(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
