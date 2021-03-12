//
//  UIView+ConfigureGradient.swift
//  Top Pop
//
//  Created by Jozo Mostarac on 12/03/2021.
//

import UIKit

extension UIView {
    func configureGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemTeal.cgColor, UIColor.systemPink.cgColor]
        gradient.locations = [0, 1]
        self.layer.addSublayer(gradient)
        gradient.frame = self.frame
    }
}
