//
//  globalVariablesFunctions.swift
//  iArrive
//
//  Created by Lam Wun Yin on 26/6/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//

import UIKit
import AFNetworking
import Toast_Swift
import TTSegmentedControl


// MARK: Global Variables

// For Storing the Staff Member List Data
var staffNameList = [staffMember] ()

// For selecting language
var engChinStatus = 0   // 0 for English, 1 for Chinese

// Login Information (For Section B)
var companyName: String?

// Staff Member Information (For Section B1)
var currentCheckingInOutFirstName: String?
var currentCheckingInOutLastName: String?
var currentCheckingInOutJobTitle: String?
var currentCheckingInOutDate: String?
var currentCheckingInOutTime: String?
var currentCheckingInOutPhoto: UIImage?

// Staff Member Information (For Section C)
var currentRegisteringFirstName: String?
var currentRegisteringLastName: String?
var currentRegisteringJobTitle: String?

// For sending and retriving JSON data to/from database
var token: String?
var orgID: String?

// For Loading Sample Data and Debugging (Deleted after deployment)
var isLoadSampleStaff = true
var isLoadSampleDetectedData = true



// MARK: Global Constants

// URL for Term of Service, Privacy Policy, and Forgot Password
let termOfServiceLink = "https://www.google.com/search?q=term+of+service"
let privacyPolicyLink = "https://www.google.com/search?q=privacy+policy"
let forgotPasswordLink = "https://www.google.com/search?q=forgot+password"

// Position for Toast View (determined by Screen Size)
let toast_x = UIScreen.main.bounds.width / 2
let toast_y = UIScreen.main.bounds.height * 3/4
let toast_postion = CGPoint(x: toast_x, y: toast_y)

// For sending and retriving data to/from database
let baseURL = "https://iarrive.apptech.com.hk/api"



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
}
