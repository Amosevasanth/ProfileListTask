//
//  Extension.swift
//  WhiteRabbitTest
//
//  Created by amosevasanth.s on 21/06/22.
//

import UIKit

extension UIView {
    func setCornerRadius(radius: CGFloat = 10,width: CGFloat = 0.5,color: UIColor = .lightGray) {
        self.layer.cornerRadius = radius
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
}
