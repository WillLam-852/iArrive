//
//  C1_VideoRegisterViewController.swift
//  iArrive
//
//  Created by Will Lam on 14/8/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//

import UIKit

class C1_VideoRegisterViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var imageInsidePreviewView: UIImageView!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
        
        // Associate Button objects with action methods (For updating button background colors and shadows)
        startButton.addTarget(self, action: #selector(buttonPressing), for: .touchDown)
        startButton.addTarget(self, action: #selector(buttonPressedInside), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(buttonDraggedInside), for: .touchDragInside)
        startButton.addTarget(self, action: #selector(buttonDraggedOutside), for: .touchDragOutside)
    }
    
    
    // MARK: Action Methods for Buttons
    // For updating button background colors and shadows
    
    @objc func buttonPressing(_ sender: AnyObject?) {
        startButtonPressing()
    }
    
    @objc func buttonPressedInside(_ sender: AnyObject?) {
        startButtonPressing()
        backButtonPressing()
    }
    
    @objc func buttonDraggedInside(_ sender: AnyObject?) {
        startButtonPressing()
    }
    
    @objc func buttonDraggedOutside(_ sender: AnyObject?) {
        startButtonUnpressing()
    }
    
    
    // MARK: Private Methods
    
    // Start Button Pressing Status
    private func startButtonPressing() {
        startButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#38C9FF").withAlphaComponent(0.5), for: .normal)
        startButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        startButton.layer.hideShadow()
    }
    
    // Start Button Unpressing Status
    private func startButtonUnpressing() {
        startButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(1), for: .normal)
        startButton.backgroundColor = UIColor.white.withAlphaComponent(1)
        startButton.layer.showShadow()
    }
    
    // Back Button Pressing Status
    private func backButtonPressing() {
        backButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(0.5), for: .normal)
        backButton.setImage(UIImage(named: "HighlightedBackArrow"), for: .normal)
    }
    
    // Back Button Unressing Status
    private func backButtonUnpressing() {
        backButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(1), for: .normal)
        backButton.setImage(UIImage(named: "Back_3"), for: .normal)
    }
    
    // Set up Elements
    private func setUpElements() {
        // Set up Background Color
        self.view.backgroundColor = publicFunctions().hexStringToUIColor(hex: "#F7F7F7")
        
        // Set up Time Label
        timeLabel.frame = CGRect(x: 272, y: 111, width: 225, height: 62).x_centreRatio().y_fixedToScreenRatio(false)
        timeLabel.text = "00:03"
        timeLabel.isHidden = true
        
        // Set up Camera Preview View
        previewView.frame = CGRect(x: 244, y: 201, width: 280, height: 280).fixedToScreenRatio(true)
        previewView.frame = CGRect(x: previewView.frame.minX, y: previewView.frame.minY, width: previewView.frame.height, height: previewView.frame.height)
        previewView.center.x = self.view.center.x
        previewView.layer.borderWidth = 1.0
        previewView.layer.masksToBounds = false
        previewView.layer.borderColor = UIColor.white.cgColor
        previewView.layer.cornerRadius = previewView.frame.height / 2
        previewView.clipsToBounds = true
        previewView.backgroundColor = .blue
        
        // Set up Image Inside Preview View
        imageInsidePreviewView.frame = CGRect(x: 0, y: 0, width: previewView.bounds.width, height: previewView.bounds.height)
        previewView.insertSubview(imageInsidePreviewView, at: 1)
        
        // Set up labels
        recordLabel.frame = CGRect(x: 300, y: 657, width: 169, height: 33).x_centreRatio().y_fixedToScreenRatio(false)
        positionLabel.frame = CGRect(x: 197, y: 698, width: 374, height: 45).x_centreRatio().y_fixedToScreenRatio(false)
        recordLabel.text = "Record a video"
        positionLabel.isHidden = false
        
        // Set up Back Button
        backButton.frame = CGRect(x: 77, y: 782, width: 117, height: 33).fixedToScreenRatio(false)
        backButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(1), for: .normal)
        backButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(0.5), for: .highlighted)
        backButton.setImage(UIImage(named: "Back_3"), for: .normal)
        backButton.setImage(UIImage(named: "HighlightedBackArrow"), for: .highlighted)
        backButton.isEnabled = true
        
        // Set up Start Button
        startButton.frame = CGRect(x: 224, y: 770, width: 320, height: 56).x_centreRatio().y_fixedToScreenRatio(false)
        startButton.layer.cornerRadius = 4.0
        startButton.layer.applySketchShadow(
            color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.16),
            x: 0,
            y: 3,
            blur: 6,
            spread: 0)
        startButton.isEnabled = true
    }
    
    
    // MARK: Navigation

    @IBAction func pressedBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressedStartButton(_ sender: UIButton) {
        timeLabel.isHidden = false
        recordLabel.text = "Recording..."
        positionLabel.isHidden = true
        backButton.isEnabled = false
        startButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.timeLabel.text = "00:02"
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            self.timeLabel.text = "00:01"
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            self.timeLabel.text = "00:00"
            self.startButtonUnpressing()
            self.backButtonUnpressing()
            let alert = UIAlertController(title: "Add Success", message: "New staff has been added successfully! Take effect after\n5 minutes.", preferredStyle: .alert)
            
//            let alert = UIAlertController(title: "Error", message: "Fail to upload your video, please try again later.", preferredStyle: .alert)
//            let alert = UIAlertController(title: "Error", message: "Fail to create employee information.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                staffNameList.append(staffMember(firstName: currentRegisteringFirstName!, lastName: currentRegisteringLastName!, jobTitle: currentRegisteringJobTitle!, isCheckedIn: false))
                currentRegisteringFirstName = nil
                currentRegisteringLastName = nil
                currentRegisteringJobTitle = nil
                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true)
        })
    }
    
    
}
