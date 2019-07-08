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
    @IBOutlet weak var notMeButton: UIButton!
    @IBOutlet weak var upperLayerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var checkInOutButton: UIButton!
    @IBOutlet weak var detectedName: UILabel!
    @IBOutlet weak var detectedJobTitle: UILabel!
    
    
    // MARK: Local Variables
    var checkInColor = publicFunctions().hexStringToUIColor(hex: "#3BBF00")
    var checkOutColor = publicFunctions().hexStringToUIColor(hex: "#FF2C55")
    var currentColor: UIColor?
    var currentStatus: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isLoadSampleStaff {
            publicFunctions().loadSampleStaff()
        }
        
        if isLoadSampleDetectedData {
            loadSampleDetectedData()
        }
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = currentCheckingInOutPhoto
        imageView.transform = CGAffineTransform(scaleX: -1, y: 1)
        imageView.center = view.center
        view.addSubview(imageView)
        
        if let index = staffNameList.firstIndex(where: { $0.firstName == currentCheckingInOutFirstName && $0.lastName == currentCheckingInOutLastName && $0.jobTitle == currentCheckingInOutJobTitle }) {
            if staffNameList[index].isCheckedIn {
                currentColor = checkOutColor
                currentStatus = "Check Out"
            } else {
                currentColor = checkInColor
                currentStatus = "Check In"
            }
        } else {
            print("ERROR: There is no selected staff in the staffNameList.")
        }
        
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.9
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        
        upperLayerView.layer.borderWidth = 1
        upperLayerView.layer.borderColor = currentColor?.cgColor
        upperLayerView.layer.cornerRadius = 20
        upperLayerView.clipsToBounds = true
        
        iconImageView.image = UIImage(named: "Search")
        iconImageView.layer.borderWidth = 1.0
        iconImageView.layer.masksToBounds = false
        iconImageView.layer.borderColor = UIColor.white.cgColor
        iconImageView.layer.cornerRadius = iconImageView.frame.height / 2
        iconImageView.clipsToBounds = true
        
        detectedName.text = currentCheckingInOutFirstName! + " " + currentCheckingInOutLastName!
        detectedJobTitle.text = currentCheckingInOutJobTitle
        
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
        
        checkInOutButton.backgroundColor = currentColor
        checkInOutButton.titleLabel?.numberOfLines = 0
        checkInOutButton.titleLabel?.textAlignment = .center
        checkInOutButton.setAttributedTitle(string, for: .normal)
        
        notMeButton.layer.cornerRadius = 28
        
        self.view.insertSubview(imageView, at: 0)
        self.view.insertSubview(blurEffectView, at: 1)
        self.view.insertSubview(upperLayerView, at: 2)
        upperLayerView.insertSubview(iconImageView, at: 3)
    }
    
    
    // MARK: Navigation
    
    @IBAction func pressedCheckInOutButton(_ sender: UIButton) {
        if let index = staffNameList.firstIndex(where: { $0.firstName == currentCheckingInOutFirstName && $0.lastName == currentCheckingInOutLastName && $0.jobTitle == currentCheckingInOutJobTitle }) {
            if staffNameList[index].isCheckedIn {
                staffNameList[index].isCheckedIn = false
                print(currentCheckingInOutFirstName ?? "", "Check out successfully")
            } else {
                staffNameList[index].isCheckedIn = true
                print(currentCheckingInOutFirstName ?? "", "Check in successfully")
            }
        } else {
            print("ERROR: There is no selected staff in the staffNameList.")
        }
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressedTryAgainButton(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    
    
    // To Be Deleted
    
    private func loadSampleDetectedData() {
        currentCheckingInOutFirstName = "Samuel"
        currentCheckingInOutLastName = "Lee"
        currentCheckingInOutJobTitle = "Web Designer"
        if currentCheckingInOutTime == nil {
            currentCheckingInOutTime = "15:00"
        }
    }
    

}
