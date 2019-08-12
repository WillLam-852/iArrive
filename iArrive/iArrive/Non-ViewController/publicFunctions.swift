//
//  publicFunctions.swift
//  iArrive
//
//  Created by Will Lam on 12/8/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//


import UIKit
import Toast_Swift
import TTSegmentedControl


// MARK: Public Functions

class publicFunctions {
    
    // Function for translating color hex index to UIColor
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    // Set up the Toast View Style
    func toastStyleSetUp() -> ToastStyle {
        var style = ToastStyle()
        style.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        style.cornerRadius = 27
        style.messageFont = UIFont(name: "NotoSans-Medium", size: 24)!
        style.titleColor = UIColor.white
        style.horizontalPadding = 30
        style.verticalPadding = 10
        return style
    }
    
    // Set up ENG/中文 Segment Control
    func addEngChinSegmentedControl() -> UIView {
        let engChinSegmentedControl = TTSegmentedControl()
        engChinSegmentedControl.frame = CGRect(x: 0, y: 0, width: 108, height: 31)
        engChinSegmentedControl.center = CGPoint(x: UIScreen.main.bounds.width*0.5, y: UIScreen.main.bounds.height-100)
        engChinSegmentedControl.layoutSubviews()
        engChinSegmentedControl.cornerRadius = 8
        engChinSegmentedControl.changeBackgroundColor(.clear)
        engChinSegmentedControl.changeThumbGradientColors([publicFunctions().hexStringToUIColor(hex: "#2E4365"), publicFunctions().hexStringToUIColor(hex: "#2E4365")])
        let segmentedControlStringAttribute = [NSAttributedString.Key.font : UIFont(name: "Montserrat-Bold", size: 16)!, .foregroundColor : UIColor.white]
        let selectedSegmentedControlStringAttribute = [NSAttributedString.Key.font : UIFont(name: "Montserrat-Bold", size: 16)!, .foregroundColor : UIColor.white.withAlphaComponent(0.6)]
        engChinSegmentedControl.changeAttributedTitle(NSMutableAttributedString(string: "ENG", attributes: selectedSegmentedControlStringAttribute), selectedTile: NSMutableAttributedString(string: "ENG", attributes: segmentedControlStringAttribute), atIndex: 0)
        engChinSegmentedControl.changeAttributedTitle(NSMutableAttributedString(string: "中文", attributes: selectedSegmentedControlStringAttribute), selectedTile: NSMutableAttributedString(string: "中文", attributes: segmentedControlStringAttribute), atIndex: 1)
        engChinSegmentedControl.didSelectItemWith = { (index, title) -> () in
            engChinStatus = index
        }
        return engChinSegmentedControl
    }
    
    // Function for loading sample staff list (To be deleted when deployment)
    func loadSampleStaff() {
        staffNameList.removeAll()
        staffNameList.append(staffMember.init(firstName: "Jacky", lastName: "Wong", jobTitle: "Software Engineer", isCheckedIn: false))
        staffNameList.append(staffMember.init(firstName: "Samuel", lastName: "Lee", jobTitle: "Web Designer", isCheckedIn: false))
        staffNameList.append(staffMember.init(firstName: "Jowie", lastName: "Wong", jobTitle: "General UI Designer", isCheckedIn: false))
        staffNameList.append(staffMember.init(firstName: "Kit Wai", lastName: "Fong", jobTitle: "Software Engineer", isCheckedIn: false))
        staffNameList.append(staffMember.init(firstName: "Chloe", lastName: "Wong", jobTitle: "Project Manager", isCheckedIn: false))
        staffNameList.append(staffMember.init(firstName: "Tin Yan", lastName: "Li", jobTitle: "Software Engineer", isCheckedIn: false))
    }
    
    
    // For returning a random 32-bit string
    public func ret32bitString() -> String? {
        var retString: String = ""
        for _ in 0 ..< 32 {
            retString.append(Character(UnicodeScalar(UInt32(("A" as UnicodeScalar).value) + arc4random_uniform(26))!))
        }
        return retString
    }
    
    
    // For adding an animated loading view
    public func animatedLoadingView(textColor: UIColor) -> UIView {
        let loadingView = UIView(frame: UIScreen.main.bounds)
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
        
        let loadingLabel: UILabel = {
            let loadingLabel = UILabel()
            loadingLabel.text = "Loading"
            loadingLabel.font = UIFont(name: "NotoSans-Medium", size: 24)
            loadingLabel.textColor = textColor
            loadingLabel.textAlignment = .center
            loadingLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
            loadingLabel.center = CGPoint(x: loadingView.center.x, y: loadingView.center.y-30)
            return loadingLabel
        }()
        loadingView.addSubview(loadingLabel)
        
        return loadingView
    }
}
