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
    @IBOutlet weak var addMemberButton: UIButton!
    @IBOutlet weak var bottomBar: UILabel!
    
    // MARK: Properties (for animation)
    let registerLabel = UILabel()
    let nextButton = UIButton()
    let explainTextView = UITextView()
    let cancelButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up Background and Bottom Bar Color
        addBackgroundGradientColors()
        bottomBar.backgroundColor = UIColor(white: 1, alpha: 0.1)
        
        setUpGreetingLabelLogoutButtonAddMemberButton()
        
        // Set up Check In / Out Button
        checkInOutButton.layer.cornerRadius = 4.0
        checkInOutButton.layer.applySketchShadow(
            color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.16),
            x: 0,
            y: 3,
            blur: 6,
            spread: 0)
        
        // Set up English/Chinese Segmented Control
        let engChinSegmentedControl = publicFunctions().addEngChinSegmentedControl()
        view.addSubview(engChinSegmentedControl)
        
        // Associate Button objects with action methods (For updating button background colors and shadows)
        checkInOutButton.addTarget(self, action: #selector(buttonPressing), for: .touchDown)
        checkInOutButton.addTarget(self, action: #selector(buttonPressedInside), for: .touchUpInside)
        checkInOutButton.addTarget(self, action: #selector(buttonDraggedInside), for: .touchDragInside)
        checkInOutButton.addTarget(self, action: #selector(buttonDraggedOutside), for: .touchDragOutside)
        addMemberButton.addTarget(self, action: #selector(buttonPressing), for: .touchDown)
        addMemberButton.addTarget(self, action: #selector(buttonPressedInside), for: .touchUpInside)
        addMemberButton.addTarget(self, action: #selector(buttonDraggedInside), for: .touchDragInside)
        addMemberButton.addTarget(self, action: #selector(buttonDraggedOutside), for: .touchDragOutside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for item in [greetingLabel, logoutButton, checkInOutButton] {
            item!.layer.opacity = 1.0
        }
        configurateAppearingElements()
        for item in [registerLabel, nextButton, explainTextView, cancelButton] {
            item.layer.opacity = 0.0
        }
        // Set up Add Member Button
        addMemberButton.frame = CGRect(x: 224.0, y: 516.0, width: 320.0, height: 56.0)
        addMemberButton.setTitle("Add Member", for: .normal)
        addMemberButton.backgroundColor = publicFunctions().hexStringToUIColor(hex: "#0027FF").withAlphaComponent(0.2)
        addMemberButton.layer.cornerRadius = 4.0
        addMemberButton.layer.opacity = 1.0
    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        UIView.animate(withDuration: 0.5, delay: 0.0, options: [],
//                       animations: {
//                        for item in [self.greetingLabel, self.logoutButton, self.addMemberButton] {
//                            item!.layer.opacity = 1.0
//                        }
//        },
//                       completion: nil)
//
//    }
    
    // MARK: Action Methods for Buttons
    // For updating button background colors and shadows
    
    @objc func buttonPressing(_ sender: AnyObject?) {
        if sender === checkInOutButton {
            checkInOutButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            checkInOutButton.layer.hideShadow()
        } else if sender === addMemberButton {
            addMemberButton.backgroundColor = publicFunctions().hexStringToUIColor(hex: "#0027FF").withAlphaComponent(0.1)
        }
    }
    
    @objc func buttonPressedInside(_ sender: AnyObject?) {
        if sender === checkInOutButton {
            checkInOutButton.backgroundColor = UIColor.white.withAlphaComponent(1.0)
            checkInOutButton.layer.showShadow()
        } else if sender === addMemberButton {
            addMemberButton.backgroundColor = publicFunctions().hexStringToUIColor(hex: "#0027FF").withAlphaComponent(0.2)
        }
    }
    
    @objc func buttonDraggedInside(_ sender: AnyObject?) {
        if sender === checkInOutButton {
            checkInOutButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            checkInOutButton.layer.hideShadow()
        } else if sender === addMemberButton {
            addMemberButton.backgroundColor = publicFunctions().hexStringToUIColor(hex: "#0027FF").withAlphaComponent(0.1)
        }
    }
    
    @objc func buttonDraggedOutside(_ sender: AnyObject?) {
        if sender === checkInOutButton {
            checkInOutButton.backgroundColor = UIColor.white.withAlphaComponent(1.0)
            checkInOutButton.layer.showShadow()
        } else if sender === addMemberButton {
            addMemberButton.backgroundColor = publicFunctions().hexStringToUIColor(hex: "#0027FF").withAlphaComponent(0.2)
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
    
    private func setUpGreetingLabelLogoutButtonAddMemberButton() {
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
        let boldText = (companyName ?? UserDefaults.standard.string(forKey: "companyName")!) + " !"
        let boldAttrs = [NSAttributedString.Key.font : UIFont(name: "NotoSans-ExtraBold", size: 24)]
        let attributedString = NSMutableAttributedString(string: normalText, attributes: normalAttrs as [NSAttributedString.Key : Any])
        attributedString.append(NSMutableAttributedString(string: boldText, attributes: boldAttrs as [NSAttributedString.Key : Any]))
        greetingLabel.attributedText = attributedString
        
        // Set up Logout Button
        logoutButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#3BACD0").withAlphaComponent(1.0), for: .normal)
        logoutButton.setTitleColor(UIColor.black.withAlphaComponent(0.5), for: .highlighted)
        
        // Set up Add Member Button
        addMemberButton.backgroundColor = publicFunctions().hexStringToUIColor(hex: "#0027FF").withAlphaComponent(0.2)
        addMemberButton.layer.cornerRadius = 4.0
    }

    
    
    // MARK: Navigations
    
    // Back to Login Page when user presses Logout Button
    @IBAction func pressedLogoutButton(_ sender: Any) {
        if UserDefaults.standard.bool(forKey: "isUserLoggedIn") {
            self.performSegue(withIdentifier: "SignIntoLogInSegue", sender: self)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        UserDefaults.standard.synchronize()
    }
    
    @IBAction func pressedAddMemberButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [], animations: {
            for item in [self.greetingLabel, self.logoutButton, self.checkInOutButton] {
                item!.layer.opacity = 0.0
            }
            for item in [self.registerLabel, self.nextButton, self.explainTextView, self.cancelButton] {
                item.layer.opacity = 1.0
            }
            self.addMemberButton.setTitle("", for: .normal)
            self.addMemberButton.frame = self.view.frame
            self.addMemberButton.backgroundColor = publicFunctions().hexStringToUIColor(hex: "#0027FF").withAlphaComponent(0.1)
            self.addMemberButton.layer.opacity = 0.5
        }, completion: { finished in
            self.performSegue(withIdentifier: "SignIntoRegisterSegue", sender: self)
        })
    }
    
    private func configurateAppearingElements() {
        registerLabel.frame = CGRect(x: 297.0, y: 154.0, width: 174.0, height: 43.0)
        nextButton.frame = CGRect(x: 224.0, y: 554.0, width: 320.0, height: 56.0)
        explainTextView.frame = CGRect(x: 224.0, y: 618.0, width: 320.0, height: 61.0)
        cancelButton.frame = CGRect(x: 175.0, y: 736.0, width: 158.0, height: 33.0)
        
        registerLabel.font = UIFont(name: "NotoSans-Regular", size: 32.0)
        registerLabel.textColor = .white
        registerLabel.textAlignment = .center
        registerLabel.text = "Register"
        
        // Set up Next Button
        nextButton.setTitle("Next", for: .normal)
        nextButton.titleLabel?.font = UIFont(name: "NotoSans-Medium", size: 24.0)
        nextButton.layer.cornerRadius = 4.0
        nextButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(0.3), for: .normal)
        nextButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        
        // Set up Text View with Required Fonts and URLs
        let labelText = """
        By registering, you agree to the iArrive
        Terms of Service and Privacy Policy
        """
        let stringAttribute = [NSAttributedString.Key.font : UIFont(name: "NotoSans-Regular", size: 16)!, .foregroundColor : UIColor.white]
        let string = NSMutableAttributedString(string: labelText, attributes: stringAttribute)
        var textRange = string.mutableString.range(of: "Terms of Service")
        string.addAttribute(.link, value: termOfServiceLink, range: textRange)
        textRange = string.mutableString.range(of: "Privacy Policy")
        string.addAttribute(.link, value: privacyPolicyLink, range: textRange)
        let linkAttribute = [NSAttributedString.Key.font: UIFont(name: "NotoSans-Medium", size: 16)!, .foregroundColor : publicFunctions().hexStringToUIColor(hex: "#C9F4FF"), .underlineStyle: 1] as [NSAttributedString.Key : Any]
        explainTextView.isEditable = false
        explainTextView.dataDetectorTypes = .link
        explainTextView.attributedText = string
        explainTextView.linkTextAttributes = linkAttribute
        explainTextView.textAlignment = .center
        explainTextView.backgroundColor = .clear
        
        // Set up Cancel Button
        cancelButton.setTitle("     Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: "NotoSans-Medium", size: 24.0)
        cancelButton.setTitleColor(UIColor.darkGray.withAlphaComponent(0.5), for: .highlighted)
        cancelButton.setImage(UIImage(named: "Back_2"), for: .normal)
        cancelButton.contentVerticalAlignment = .fill
        cancelButton.contentHorizontalAlignment = .fill
        cancelButton.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 10.0)
        
        for item in [registerLabel, nextButton, explainTextView, cancelButton] {
            self.view.insertSubview(item, at: 1)
            self.view.bringSubviewToFront(item)
        }
    }
}
