//
//  B1-1_PhotoDetectedViewController.swift
//  iArrive
//
//  Created by Will Lam on 4/7/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//

import UIKit

class B1_1_PhotoDetectedViewController: UIViewController {

    
    // MARK: Properties
    @IBOutlet weak var upperLayerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var detectedNameLabel: UILabel!
    @IBOutlet weak var detectedJobTitleLabel: UILabel!
    @IBOutlet weak var checkInOutButton: UIButton!
    @IBOutlet weak var notMeButton: UIButton!
    @IBOutlet weak var tryAgainButton: UIButton!
    var backgroundImageView : UIImageView!
    
    
    // MARK: Local Variables
    let checkInColor = publicFunctions().hexStringToUIColor(hex: "#3BBF00")
    let checkOutColor = publicFunctions().hexStringToUIColor(hex: "#FF2C55")
    var currentColor: UIColor?
    var currentStatus: String?
    var autoCheckInOut: DispatchWorkItem?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load Sample Staff for debugging (Delete after deployment)
//        if isLoadSampleStaff {
//            publicFunctions().loadSampleStaff()
//        }
        
        // Load Sample Detected Staff Member Infomation for debugging (Delete after deployment)
        if isLoadSampleDetectedData {
            loadSampleDetectedData()
        }
        
        // Determine the current detected staff need to check in or check out
        if let index = staffNameList.firstIndex(where: { $0.firstName == currentCheckingInOutFirstName && $0.lastName == currentCheckingInOutLastName && $0.jobTitle == currentCheckingInOutJobTitle }) {
            if staffNameList[index].isCheckedIn {
                currentColor = checkOutColor
                currentStatus = "Check Out"
            } else {
                currentColor = checkInColor
                currentStatus = "Check In"
            }
        } else {
            print("ERROR: There is no detected staff in the staffNameList.")
        }
        
        // Set up Background Image with Blur Effect
        backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundImageView.image = currentCheckingInOutPhoto
        backgroundImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
        backgroundImageView.center = view.center
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.9
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Set up Upper Layer View (with different colors for check in / out)
        upperLayerView.frame = CGRect(x: 171, y: 96, width: 426, height: 648).centreRatio()
        upperLayerView.layer.borderWidth = 1
        upperLayerView.layer.borderColor = currentColor?.cgColor
        upperLayerView.layer.cornerRadius = 20
        upperLayerView.clipsToBounds = true
        
        // Set up Icon Image Vice (with circle border)
        iconImageView.frame = CGRect(x: 73, y: 69, width: 280, height: 280)
        iconImageView.image = UIImage(named: "Search") // To Be changed
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.layer.borderWidth = 1.0
        iconImageView.layer.masksToBounds = false
        iconImageView.layer.borderColor = UIColor.white.cgColor
        iconImageView.layer.cornerRadius = iconImageView.frame.height / 2
        iconImageView.clipsToBounds = true
        
        // Set up Detected Name and Detected Job Title Labels
        detectedNameLabel.frame = CGRect(x: 0, y: 373, width: 426, height: 44)
        detectedJobTitleLabel.frame = CGRect(x: 0, y: 417, width: 426, height: 44)
        detectedNameLabel.text = currentCheckingInOutFirstName! + " " + currentCheckingInOutLastName!
        detectedJobTitleLabel.text = currentCheckingInOutJobTitle
        
        // Set up Check In / Out Button (with different labels, background colors, current time for check in / out)
        var labelText = """
        checkInOrOut
        currentTime
        """
        labelText = labelText.replacingOccurrences(of: "checkInOrOut", with: currentStatus!)
        labelText = labelText.replacingOccurrences(of: "currentTime", with: currentCheckingInOutTime!)
        let nameStringAttribute = [NSAttributedString.Key.font : UIFont(name: "NotoSans-Bold", size: 24)!, .foregroundColor : UIColor.white, ]
        let string = NSMutableAttributedString(string: labelText, attributes: nameStringAttribute)
        let textRange = string.mutableString.range(of: currentCheckingInOutTime!)
        string.addAttributes([.font: UIFont(name: "Montserrat-Medium", size: 56)!, .foregroundColor : UIColor.white], range: textRange)
        checkInOutButton.frame = CGRect(x: 0, y: 507, width: 426, height: 141)
        checkInOutButton.backgroundColor = currentColor
        checkInOutButton.titleLabel?.numberOfLines = 0
        checkInOutButton.titleLabel?.textAlignment = .center
        checkInOutButton.setAttributedTitle(string, for: .normal)
        
        // Set up Not Me Button
        notMeButton.frame = CGRect(x: 298, y: 778, width: 172, height: 56).centreRatio()
        notMeButton.layer.cornerRadius = 28
        
        // Set up Try Again Button
        tryAgainButton.frame = CGRect(x: 44, y: 932, width: 175, height: 35).fixedToScreenRatio(false)
        tryAgainButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -5)
        tryAgainButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tryAgainButton.setTitle("     Try Again", for: .normal)
        if self.backgroundImageView.getColor(at: tryAgainButton.center).isDarkColor && (self.backgroundImageView.getColor(at: CGPoint(x: tryAgainButton.center.x - 50, y: tryAgainButton.center.y - 50)).isDarkColor || self.backgroundImageView.getColor(at: CGPoint(x: tryAgainButton.center.x + 50, y: tryAgainButton.center.y + 50)).isDarkColor) {
            tryAgainButton.setTitleColor(UIColor.white, for: .normal)
            tryAgainButton.setTitleColor(UIColor.white.withAlphaComponent(0.3), for: .highlighted)
            tryAgainButton.setImage(UIImage(named: "WhiteTryAgainArrow"), for: .normal)
            tryAgainButton.setImage(UIImage(named: "HighlightedWhiteTryAgainArrow"), for: .highlighted)
        } else {
            tryAgainButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365"), for: .normal)
            tryAgainButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(0.5), for: .highlighted)
            tryAgainButton.setImage(UIImage(named: "TryAgainBack"), for: .normal)
            tryAgainButton.setImage(UIImage(named: "HighlightedTryAgainArrow"), for: .highlighted)
        }
        
        // Rearrange the order of Different layers
        self.view.insertSubview(backgroundImageView, at: 0)
        self.view.insertSubview(blurEffectView, at: 1)
        self.view.insertSubview(upperLayerView, at: 2)
        upperLayerView.insertSubview(iconImageView, at: 3)
    }
    

    // Back to Sign In / Out Camera Page when user has no actions for 20 seconds with Check In / Out status updated
    override func viewWillAppear(_ animated: Bool) {
        autoCheckInOut = DispatchWorkItem(block: {
            if let index = staffNameList.firstIndex(where: { $0.firstName == currentCheckingInOutFirstName && $0.lastName == currentCheckingInOutLastName && $0.jobTitle == currentCheckingInOutJobTitle }) {
                if staffNameList[index].isCheckedIn {
                    staffNameList[index].isCheckedIn = false
                    print(currentCheckingInOutFirstName ?? "", currentCheckingInOutLastName ?? "",  "Check out successfully")
                    self.dismiss(animated: true, completion: nil)
                } else {
                    staffNameList[index].isCheckedIn = true
                    print(currentCheckingInOutFirstName ?? "", currentCheckingInOutLastName ?? "",  "Check in successfully")
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                print("ERROR: There is no selected staff in the staffNameList.")
            }
        })
        // Back to Sign In / Out Camera Page when user has no actions for 20 seconds with Check In / Out status updated
        DispatchQueue.main.asyncAfter(deadline: .now() + 20, execute: autoCheckInOut!)
    }
    
    
    
    // MARK: Private Methods
    
    // Load Sample Detected Staff Member Infomation for debugging (Delete after deployment)
    private func loadSampleDetectedData() {
        let sampleCheckingInOutStaffMember = staffNameList.randomItem()
        currentCheckingInOutFirstName = sampleCheckingInOutStaffMember?.firstName
        currentCheckingInOutLastName = sampleCheckingInOutStaffMember?.lastName
        currentCheckingInOutJobTitle = sampleCheckingInOutStaffMember?.jobTitle
        if currentCheckingInOutTime == nil {
            currentCheckingInOutTime = "15:00"
        }
    }
    
    
    
    // MARK: Navigation
    
    // Back to Sign In / Out Camera Page when user presses Check In / Out Button with Check In / Out status updated
    @IBAction func pressedCheckInOutButton(_ sender: UIButton) {
        if let index = staffNameList.firstIndex(where: { $0.firstName == currentCheckingInOutFirstName && $0.lastName == currentCheckingInOutLastName && $0.jobTitle == currentCheckingInOutJobTitle }) {
            if staffNameList[index].isCheckedIn {
                staffNameList[index].isCheckedIn = false
                self.view.window?.hideAllToasts()
                self.view.window?.makeToast(currentCheckingInOutFirstName! + " " + currentCheckingInOutLastName! + " Check Out Successfully", duration: 5.0, point: toast_postion, title: nil, image: nil, style: publicFunctions().toastStyleSetUp(), completion: nil)
            } else {
                staffNameList[index].isCheckedIn = true
                self.view.window?.hideAllToasts()
                self.view.window?.makeToast(currentCheckingInOutFirstName! + " " + currentCheckingInOutLastName! + " Check In Successfully", duration: 5.0, point: toast_postion, title: nil, image: nil, style: publicFunctions().toastStyleSetUp(), completion: nil)
            }
        } else {
            print("ERROR: There is no selected staff in the staffNameList.")
        }
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressedNotMeButton(_ sender: UIButton) {
        autoCheckInOut?.cancel()
    }
    
    // Back to Camera View when user presses Try Again Button
    @IBAction func pressedTryAgainButton(_ sender: UIButton) {
        autoCheckInOut?.cancel()
        dismiss(animated: false, completion: nil)
    }
    
}
