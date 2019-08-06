//
//  extension.swift
//  iArrive
//
//  Created by Will Lam on 11/7/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//

import UIKit
import os.log
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
    
    // Based on ratio from the top border / left border
    func fixedToScreenRatio(_ widthHeightChange: Bool) -> CGRect {
        var newPosition = CGRect()
        let newX = minX / 768.0 * screenWidth
        let newY = minY / 1024.0 * screenHeight
        var newWidth = width
        var newHeight = height
        if widthHeightChange {
            newWidth = width / 768.0 * screenWidth
            newHeight = height / 1024.0 * screenHeight
        }
        newPosition = CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
        return newPosition
    }
    
    func x_fixedToScreenRatio(_ widthHeightChange: Bool) -> CGRect {
        var newPosition = CGRect()
        let newX = minX
        let newY = minY / 1024.0 * screenHeight
        var newWidth = width
        var newHeight = height
        if widthHeightChange {
            newWidth = width / 768.0 * screenWidth
            newHeight = height / 1024.0 * screenHeight
        }
        newPosition = CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
        return newPosition
    }
    
    func y_fixedToScreenRatio(_ widthHeightChange: Bool) -> CGRect {
        var newPosition = CGRect()
        let newX = minX
        let newY = minY / 1024.0 * screenHeight
        var newWidth = width
        var newHeight = height
        if widthHeightChange {
            newWidth = width / 768.0 * screenWidth
            newHeight = height / 1024.0 * screenHeight
        }
        newPosition = CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
        return newPosition
    }
    
    // Based on ratio from the centre
    func centreRatio() -> CGRect {
        return CGRect(x: screenCentreX-(384.0-minX), y: screenCentreY-(512.0-minY), width: width, height: height)
    }
    
    func x_centreRatio() -> CGRect {
        return CGRect(x: screenCentreX-(384.0-minX), y: minY, width: width, height: height)
    }
    
    func y_centreRatio() -> CGRect {
        return CGRect(x: minX, y: screenCentreY-(512.0-minY), width: width, height: height)
    }
}


// Extension on UILabel to make a duplicated label
extension UILabel {
    func copyLabel() -> UILabel {
        let label = UILabel()
        label.font = self.font
        label.frame = self.frame
        label.text = self.text
        label.textColor = self.textColor
        label.backgroundColor = self.backgroundColor
        return label
    }
}


// Extension on UIColor to determine if it is light or dark color
extension UIColor
{
    var isDarkColor: Bool {
        var r, g, b, a: CGFloat
        (r, g, b, a) = (0, 0, 0, 0)
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        let lum = 0.2126 * r + 0.7152 * g + 0.0722 * b
        print(lum)
        return  lum < 0.55 ? true : false
    }
}


// Extension on UIView to get a color from a point
extension UIView {
    func getColor(at point: CGPoint) -> UIColor{
        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        context.translateBy(x: -point.x, y: -point.y)
        self.layer.render(in: context)
        let color = UIColor(red:   CGFloat(pixel[0]) / 255.0,
                            green: CGFloat(pixel[1]) / 255.0,
                            blue:  CGFloat(pixel[2]) / 255.0,
                            alpha: CGFloat(pixel[3]) / 255.0)
        pixel.deallocate()
        return color
    }
}
