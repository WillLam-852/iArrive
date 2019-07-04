//
//  globalVariablesFunctions.swift
//  iArrive
//
//  Created by Lam Wun Yin on 26/6/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//

import UIKit


// MARK: Global Variables

var organization = "AppTech"    // Campany Name
var isLogin = false     // True for logged in, False otherwise
var currentRegisteringFirstName = ""
var currentRegisteringLastName = ""
var currentRegisteringJobTitle = ""
var staffNameList = [staffMember] ()
var currentCheckingInOutFirstName = ""
var currentCheckingInOutLastName = ""
var currentCheckingInOutJobTitle = ""
var currentCheckingInOutPhoto: UIImage?
var isLoadSampleStaff = true


// MARK: Global Classes

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
    
    // Function for sample staff list
    func loadSampleStaff() {
        staffNameList.removeAll()
        staffNameList.append(staffMember.init(firstName: "Jacky", lastName: "Wong", jobTitle: "Software Engineer", isCheckedIn: false))
        staffNameList.append(staffMember.init(firstName: "Samuel", lastName: "Lee", jobTitle: "Web Designer", isCheckedIn: false))
        staffNameList.append(staffMember.init(firstName: "Jowie", lastName: "Wong", jobTitle: "General UI Designer", isCheckedIn: false))
        staffNameList.append(staffMember.init(firstName: "Kit Wai", lastName: "Fong", jobTitle: "Software Engineer", isCheckedIn: false))
        staffNameList.append(staffMember.init(firstName: "Chloe", lastName: "Wong", jobTitle: "Project Manager", isCheckedIn: false))
        staffNameList.append(staffMember.init(firstName: "Tin Yan", lastName: "Li", jobTitle: "Software Engineer", isCheckedIn: false))
    }
}



// MARK: Extension

// Add Toast method function in UIView Extension so can use in whole project.
extension UIView
{
    func showToast(toastMessage:String,duration:CGFloat)
    {
        //View to blur bg and stopping user interaction
        let bgView = UIView(frame: self.frame)
        bgView.backgroundColor = UIColor(red: CGFloat(255.0/255.0), green: CGFloat(255.0/255.0), blue: CGFloat(255.0/255.0), alpha: CGFloat(0.6))
        bgView.tag = 555
        
        //Label For showing toast text
        let lblMessage = UILabel()
        lblMessage.numberOfLines = 0
        lblMessage.lineBreakMode = .byWordWrapping
        lblMessage.textColor = .white
        lblMessage.backgroundColor = publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(1)
        lblMessage.textAlignment = .center
        lblMessage.font = UIFont.init(name: "Helvetica Neue", size: 17)
        lblMessage.text = toastMessage
        
        //calculating toast label frame as per message content
        let maxSizeTitle : CGSize = CGSize(width: self.bounds.size.width-16, height: self.bounds.size.height)
        var expectedSizeTitle : CGSize = lblMessage.sizeThatFits(maxSizeTitle)
        // UILabel can return a size larger than the max size when the number of lines is 1
        expectedSizeTitle = CGSize(width:maxSizeTitle.width.getminimum(value2:expectedSizeTitle.width), height: maxSizeTitle.height.getminimum(value2:expectedSizeTitle.height))
        lblMessage.frame = CGRect(x:((self.bounds.size.width)/2) - ((expectedSizeTitle.width+16)/2) , y: (self.bounds.size.height/2) - ((expectedSizeTitle.height+16)/2), width: expectedSizeTitle.width+16, height: expectedSizeTitle.height+16)
        lblMessage.layer.cornerRadius = 8
        lblMessage.layer.masksToBounds = true
        lblMessage.padding = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        bgView.addSubview(lblMessage)
        self.addSubview(bgView)
        lblMessage.alpha = 0
        
        UIView.animateKeyframes(withDuration:TimeInterval(duration) , delay: 0, options: [] , animations: {
            lblMessage.alpha = 1
        }, completion: {
            sucess in
            UIView.animate(withDuration:TimeInterval(duration), delay: 8, options: [] , animations: {
                lblMessage.alpha = 0
                bgView.alpha = 0
            })
            bgView.removeFromSuperview()
        })
    }
}
extension CGFloat
{
    func getminimum(value2:CGFloat)->CGFloat
    {
        if self < value2
        {
            return self
        }
        else
        {
            return value2
        }
    }
}

// Extension on UILabel for adding insets - for adding padding in top, bottom, right, left.

extension UILabel
{
    private struct AssociatedKeys {
        static var padding = UIEdgeInsets()
    }
    
    var padding: UIEdgeInsets? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.padding) as? UIEdgeInsets
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.padding, newValue as UIEdgeInsets?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    override open func draw(_ rect: CGRect) {
        if let insets = padding {
            self.drawText(in: rect.inset(by: insets))
        } else {
            self.drawText(in: rect)
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            if let insets = padding {
                contentSize.height += insets.top + insets.bottom
                contentSize.width += insets.left + insets.right
            }
            return contentSize
        }
    }
}

extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}

extension UIButton{
    
    func setImage(image: UIImage?, inFrame frame: CGRect?, forState state: UIControl.State){
        self.setImage(image, for: state)
        
        if let frame = frame{
            self.imageEdgeInsets = UIEdgeInsets(
                top: frame.minY - self.frame.minY,
                left: frame.minX - self.frame.minX,
                bottom: self.frame.maxY - frame.maxY,
                right: self.frame.maxX - frame.maxX
            )
        }
    }
    
}
