//
//  class.swift
//  iArrive
//
//  Created by Will Lam on 12/8/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//


import UIKit

// MARK: Global Classes

// For Outputing Background Gradient Colors in Section B and Section C
class backgroundGradientColors {
    var gl: CAGradientLayer
    init() {
        let colorTop = publicFunctions().hexStringToUIColor(hex: "#38C9FF").cgColor
        let colorBottom = publicFunctions().hexStringToUIColor(hex: "#00D8FF").cgColor
        self.gl = CAGradientLayer()
        self.gl.colors = [colorTop, colorBottom]
        self.gl.locations = [0.0, 1.0]
    }
}

// For "Keep Me Login" checkbox in Section B (Login Page)
class CheckBox: UIButton {
    let checkedImage = UIImage(named: "ic_check_box")! as UIImage
    let uncheckedImage = UIImage(named: "ic_check_box_outline_blank")! as UIImage
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
