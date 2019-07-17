//
//  usefulTools.swift
//  iArrive
//
//  Created by Will Lam on 16/7/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//

import Foundation
import UIKit


class usefulTools {
    
    
    // For returning a random 32-bit string
    public func ret32bitString() -> String? {
        var retString: String = ""
        for _ in 0 ..< 32 {
            retString.append(Character(UnicodeScalar(UInt32(("A" as UnicodeScalar).value) + arc4random_uniform(26))!))
        }
        return retString
    }
    
    
    // For adding an animated loading view
    public func animatedLoadingView() -> UIView {
        let loadingView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 100))
        loadingView.contentMode = .scaleAspectFit
        loadingView.backgroundColor = UIColor.clear
        
        let dot1 = CAShapeLayer()
        let dot2 = CAShapeLayer()
        let dot3 = CAShapeLayer()
        let dot4 = CAShapeLayer()
        
        dot1.path = UIBezierPath(arcCenter: CGPoint(x: loadingView.center.x-30,y: loadingView.center.y), radius: CGFloat(5), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true).cgPath
        dot1.fillColor = UIColor.white.cgColor
        
        dot2.path = UIBezierPath(arcCenter: CGPoint(x: loadingView.center.x-10,y: loadingView.center.y), radius: CGFloat(5), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true).cgPath
        dot2.fillColor = UIColor.white.cgColor
        
        dot3.path = UIBezierPath(arcCenter: CGPoint(x: loadingView.center.x+10,y: loadingView.center.y), radius: CGFloat(5), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true).cgPath
        dot3.fillColor = UIColor.white.cgColor
        
        dot4.path = UIBezierPath(arcCenter: CGPoint(x: loadingView.center.x+30,y: loadingView.center.y), radius: CGFloat(5), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true).cgPath
        dot4.fillColor = UIColor.white.cgColor
        
        let animcolor = CABasicAnimation(keyPath: "fillColor")
        animcolor.fromValue         = UIColor.white.cgColor
        animcolor.toValue           = UIColor.black.cgColor
        animcolor.duration          = 1.0
        animcolor.repeatCount       = .infinity
        animcolor.autoreverses      = true
        
        animcolor.beginTime = CACurrentMediaTime()
        dot1.add(animcolor, forKey: "fillColor")
        
        animcolor.beginTime = CACurrentMediaTime() + 0.25
        dot2.add(animcolor, forKey: "fillColor")
        
        animcolor.beginTime = CACurrentMediaTime() + 0.5
        dot3.add(animcolor, forKey: "fillColor")
        
        animcolor.beginTime = CACurrentMediaTime() + 0.75
        dot4.add(animcolor, forKey: "fillColor")
        
        loadingView.layer.addSublayer(dot1)
        loadingView.layer.addSublayer(dot2)
        loadingView.layer.addSublayer(dot3)
        loadingView.layer.addSublayer(dot4)
        loadingView.center = CGPoint(x: UIScreen.main.bounds.size.width*0.5, y: UIScreen.main.bounds.size.height*0.5)
        
        return loadingView
    }
    
}
