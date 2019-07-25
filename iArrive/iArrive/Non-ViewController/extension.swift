//
//  extension.swift
//  iArrive
//
//  Created by Will Lam on 11/7/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//

import UIKit
import Alamofire


// MARK: Extension

// Extension on Text Field for adding padding
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}


// Extension on layer for adding shadow
extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0)
    {
        shadowColor = color.cgColor
        shadowOffset = CGSize(width: x, height: y)
        shadowOpacity = 1.0
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
    
    func showShadow() {
        shadowOpacity = 1.0
    }
    
    func hideShadow() {
        shadowOpacity = 0.0
    }
}


// Extension on array to generate random element inside the array
extension Array {
    func randomItem() -> Element? {
        if isEmpty { return nil }
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}


// Extension on String for Alamofire request body
extension String: ParameterEncoding {
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
}


// Extension on CGRect to make a flexible size for different screensize devices
extension CGRect {
    func fixedToScreenRatio() -> CGRect {
        var newPosition = CGRect()
        let newX = minX / 768.0 * UIScreen.main.bounds.width
        let newY = minY / 1024.0 * UIScreen.main.bounds.height
        let newWidth = width / 768.0 * UIScreen.main.bounds.width
        let newHeight = height / 1024.0 * UIScreen.main.bounds.height
        newPosition = CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
        return newPosition
    }
}
