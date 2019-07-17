//
//  B_SignInViewController.swift
//  iArrive
//
//  Created by Lam Wun Yin on 27/6/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//

import UIKit

class B_SignInViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var checkInOutButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var bottomBar: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up Background and Bottom Bar Color
        addBackgroundGradientColors()
        bottomBar.backgroundColor = UIColor(white: 1, alpha: 0.1)
        
        // Set up Greeting Label (with time conditions and username)
        let currentHour = Calendar.current.component(.hour, from: Date())
        var normalText = ""
        if (currentHour >= 6 && currentHour < 12) {
            normalText = "Good morning "
        } else if (currentHour >= 12 && currentHour < 18) {
            normalText = "Good afternoon "
        } else if (currentHour >= 18 && currentHour < 24) {
            normalText = "Good evening "
        } else {
            normalText = "Good night "
        }
        let normalAttrs = [NSAttributedString.Key.font : UIFont(name: "NotoSans-Medium", size: 24)]
        let boldText = username! + " !"
        let boldAttrs = [NSAttributedString.Key.font : UIFont(name: "NotoSans-ExtraBold", size: 24)]
        let attributedString = NSMutableAttributedString(string: normalText, attributes: normalAttrs as [NSAttributedString.Key : Any])
        attributedString.append(NSMutableAttributedString(string: boldText, attributes: boldAttrs as [NSAttributedString.Key : Any]))
        greetingLabel.attributedText = attributedString

        // Set up Logout Button
        logoutButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#3BACD0").withAlphaComponent(1.0), for: .normal)
        logoutButton.setTitleColor(UIColor.black.withAlphaComponent(0.5), for: .highlighted)
        
        // Set up Check In / Out Button
        checkInOutButton.layer.applySketchShadow(
            color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.25),
            alpha: 1.0,
            x: 3,
            y: 3,
            blur: 4,
            spread: 0)
        checkInOutButton.layer.cornerRadius = 4.0
        
        // Set up Register Button
        registerButton.backgroundColor = publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(0.1)
        registerButton.layer.cornerRadius = 4.0
        
        // Associate Button objects with action methods (For updating button background colors and shadows)
        checkInOutButton.addTarget(self, action: #selector(buttonPressing), for: .touchDown)
        checkInOutButton.addTarget(self, action: #selector(buttonPressedInside), for: .touchUpInside)
        checkInOutButton.addTarget(self, action: #selector(buttonDraggedInside), for: .touchDragInside)
        checkInOutButton.addTarget(self, action: #selector(buttonDraggedOutside), for: .touchDragOutside)
        registerButton.addTarget(self, action: #selector(buttonPressing), for: .touchDown)
        registerButton.addTarget(self, action: #selector(buttonPressedInside), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(buttonDraggedInside), for: .touchDragInside)
        registerButton.addTarget(self, action: #selector(buttonDraggedOutside), for: .touchDragOutside)
    }
    
    
    
    // MARK: Action Methods for Buttons
    // For updating button background colors and shadows
    
    @objc func buttonPressing(_ sender: AnyObject?) {
        if sender === checkInOutButton {
            checkInOutButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            checkInOutButton.layer.shadowOffset = .zero
        } else if sender === registerButton {
            registerButton.backgroundColor = publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(0.5)
        }
    }
    
    @objc func buttonPressedInside(_ sender: AnyObject?) {
        if sender === checkInOutButton {
            checkInOutButton.backgroundColor = UIColor.white.withAlphaComponent(1.0)
            checkInOutButton.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        } else if sender === registerButton {
            registerButton.backgroundColor = publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(0.1)
        }
    }
    
    @objc func buttonDraggedInside(_ sender: AnyObject?) {
        if sender === checkInOutButton {
            checkInOutButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            checkInOutButton.layer.shadowOffset = .zero
        } else if sender === registerButton {
            registerButton.backgroundColor = publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(0.5)
        }
    }
    
    @objc func buttonDraggedOutside(_ sender: AnyObject?) {
        if sender === checkInOutButton {
            checkInOutButton.backgroundColor = UIColor.white.withAlphaComponent(1.0)
            checkInOutButton.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        } else if sender === registerButton {
            registerButton.backgroundColor = publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(0.1)
        }
    }
    

    
    // MARK: Private Methods
    
    // Add Background Gradient Colors
    private func addBackgroundGradientColors() {
        view.backgroundColor = UIColor.clear
        let backgroundLayer = backgroundGradientColors().gl
        backgroundLayer.frame = view.frame
        view.layer.insertSublayer(backgroundLayer, at: 0)
    }

    
    
    // MARK: Navigations
    
    // Back to Login Page when user presses Logout Button
    @IBAction func pressedLogoutButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
