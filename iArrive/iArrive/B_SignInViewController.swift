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
    let appearingApptechImage = UIImageView()
    let appearingiArriveImage = UILabel()
    let appearingUserNameTextField = animatedTextField()
    let appearingPasswordTextField = animatedTextField()
    let appearingKeepMeLoginButton = CheckBox()
    let appearingForgotPasswordButton = UIButton()
    let appearingExplainTextView = UITextView()
    
    let appearingRegisterLabel = UILabel()
    let appearingFirstNameTextField = animatedTextField()
    let appearingLastNameTextField = animatedTextField()
    let appearingJobTitleTextField = animatedTextField()
    let appearingNextButton = UIButton()
    let appearingExplainTextView2 = UITextView()
    let appearingCancelButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurateElements()
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
        configurateAppearingElements()
        for item in [greetingLabel, logoutButton, checkInOutButton] {
            item!.layer.opacity = 1.0
        }
        // Set up Add Member Button
        addMemberButton.frame = CGRect(x: 224.0, y: 516.0, width: 320.0, height: 56.0).fixedToScreenRatio()
        addMemberButton.setTitle("Add Member", for: .normal)
        addMemberButton.backgroundColor = publicFunctions().hexStringToUIColor(hex: "#0027FF").withAlphaComponent(0.2)
        addMemberButton.layer.cornerRadius = 4.0
        addMemberButton.layer.opacity = 1.0
        addMemberButton.isEnabled = true
    }
    
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

    
    // MARK: Navigations
    
    // Back to Login Page when user presses Logout Button
    @IBAction func pressedLogoutButton(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            for item in [self.greetingLabel, self.logoutButton, self.addMemberButton] {
                item!.layer.opacity = 0.0
            }
            for item in [self.appearingApptechImage, self.appearingiArriveImage,  self.appearingKeepMeLoginButton, self.appearingForgotPasswordButton, self.appearingExplainTextView] {
                item.layer.opacity = 1.0
            }
            for item in [self.appearingUserNameTextField, self.appearingPasswordTextField] {
                item.layer.opacity = 0.5
            }
            self.checkInOutButton.layer.hideShadow()
            self.checkInOutButton.frame = CGRect(x: 224.0, y: 600.0, width: 320.0, height: 56.0).fixedToScreenRatio()
            self.checkInOutButton.setTitle("Login", for: .normal)
            self.checkInOutButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#38C9FF").withAlphaComponent(0.5), for: .normal)
            self.checkInOutButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        }, completion: { finished in
            if UserDefaults.standard.bool(forKey: "isUserLoggedIn") {
                self.performSegue(withIdentifier: "SignIntoLogInSegue", sender: self)
                isengChinSegmentedControl = false
                isLoadedLoginPage = true
                UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
                UserDefaults.standard.synchronize()
            } else {
                self.dismiss(animated: false, completion: nil)
            }
        })
    }
    
    @IBAction func pressedAddMemberButton(_ sender: UIButton) {
        self.addMemberButton.isEnabled = false
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [], animations: {
            for item in [self.greetingLabel, self.logoutButton, self.checkInOutButton] {
                item!.layer.opacity = 0.0
            }
            for item in [self.appearingRegisterLabel, self.appearingNextButton, self.appearingExplainTextView2, self.appearingCancelButton] {
                item.layer.opacity = 1.0
            }
            self.addMemberButton.setTitle("", for: .normal)
            self.addMemberButton.frame = self.view.frame
            self.addMemberButton.backgroundColor = publicFunctions().hexStringToUIColor(hex: "#0027FF").withAlphaComponent(0.1)
            self.addMemberButton.layer.opacity = 0.5
        }, completion: nil)
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5.0, options: [.curveEaseOut], animations: {
            self.appearingFirstNameTextField.center.x -= 200
            self.appearingFirstNameTextField.layer.opacity = 0.5
        }, completion: nil)
        UIView.animate(withDuration: 1.0, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 5.0, options: [.curveEaseOut], animations: {
            self.appearingLastNameTextField.center.x -= 200
            self.appearingLastNameTextField.layer.opacity = 0.5
        }, completion: nil)
        UIView.animate(withDuration: 1.0, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 5.0, options: [.curveEaseOut], animations: {
            self.appearingJobTitleTextField.center.x -= 200
            self.appearingJobTitleTextField.layer.opacity = 0.5
        }, completion: { finished in
            self.performSegue(withIdentifier: "SignIntoRegisterSegue", sender: self)
        })
    }
    
    
    
    // MARK: Configurate Elements
    
    private func configurateElements() {
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
    }
    
    
    private func configurateAppearingElements() {
        // Set up Appearing elements positions
        appearingApptechImage.frame = CGRect(x: 319.0, y: 130.0, width: 130.0, height: 128.0).fixedToScreenRatio()
        appearingiArriveImage.frame = CGRect(x: 322.0, y: 279.0, width: 124.0, height: 44.0).fixedToScreenRatio()
        appearingUserNameTextField.frame = CGRect(x: 224.0, y: 356.0, width: 320.0, height: 64.0).fixedToScreenRatio()
        appearingPasswordTextField.frame = CGRect(x: 224.0, y: 438.0, width: 320.0, height: 64.0).fixedToScreenRatio()
        appearingKeepMeLoginButton.frame = CGRect(x: 224.0, y: 530.0, width: 150.0, height: 34.0).fixedToScreenRatio()
        appearingForgotPasswordButton.frame = CGRect(x: 398.0, y: 530.0, width: 146.0, height: 34.0).fixedToScreenRatio()
        appearingExplainTextView.frame = CGRect(x: 224.0, y: 664.0, width: 320.0, height: 60.0).fixedToScreenRatio()
        
        appearingRegisterLabel.frame = CGRect(x: 297.0, y: 154.0, width: 174.0, height: 43.0).fixedToScreenRatio()
        appearingFirstNameTextField.frame = CGRect(x: 224.0, y: 260.0, width: 320.0, height: 64.0).fixedToScreenRatio()
        appearingLastNameTextField.frame = CGRect(x: 224.0, y: 340.0, width: 320.0, height: 64.0).fixedToScreenRatio()
        appearingJobTitleTextField.frame = CGRect(x: 224.0, y: 420.0, width: 320.0, height: 64.0).fixedToScreenRatio()
        appearingNextButton.frame = CGRect(x: 224.0, y: 554.0, width: 320.0, height: 56.0).fixedToScreenRatio()
        appearingExplainTextView2.frame = CGRect(x: 224.0, y: 618.0, width: 320.0, height: 61.0).fixedToScreenRatio()
        appearingCancelButton.frame = CGRect(x: 175.0, y: 736.0, width: 158.0, height: 33.0).fixedToScreenRatio()
        
        // Set up ApptechImage and iArriveImage
        appearingApptechImage.image = UIImage(named: "Logo")
        appearingApptechImage.contentMode = .scaleAspectFit
        appearingiArriveImage.text = "iArrive"
        appearingiArriveImage.font = UIFont(name: "Montserrat-Bold", size: 36.0)
        appearingiArriveImage.textColor = .white
        
        // Set up UserNameTextField and PasswordTextField
        appearingUserNameTextField.placeholderText = "User Name"
        appearingPasswordTextField.placeholderText = "Password"
        appearingPasswordTextField.mainTextField.isSecureTextEntry = true
        appearingUserNameTextField.isUserInteractionEnabled = false
        appearingPasswordTextField.isUserInteractionEnabled = false
        
        appearingUserNameTextField.text = ""
        appearingPasswordTextField.text = ""
            
        // TO BE DELETED
//        appearingUserNameTextField.text = "richard.zhang@apptech.com.hk"
//        appearingPasswordTextField.text = "123456"
        
        // Set up Keep Me Login and Forgot Password Buttons
        appearingKeepMeLoginButton.setTitle("    Keep Me Login", for: .normal)
        appearingKeepMeLoginButton.titleLabel?.font = UIFont(name: "NotoSans-Bold", size: 16.0)
        appearingKeepMeLoginButton.setTitleColor(.white, for: .normal)
        appearingKeepMeLoginButton.setImage(UIImage(named: "ic_check_box_outline_blank"), for: .normal)
        appearingKeepMeLoginButton.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 2.0, bottom: 0.0, right: 0.0)
        appearingKeepMeLoginButton.imageEdgeInsets = UIEdgeInsets(top: 5.0, left: 0.0, bottom: 5.0, right: -8.0)
        appearingKeepMeLoginButton.contentHorizontalAlignment = .fill
        appearingKeepMeLoginButton.contentVerticalAlignment = .fill
        appearingForgotPasswordButton.setTitle("Forgot Password ?", for: .normal)
        appearingForgotPasswordButton.titleLabel?.font = UIFont(name: "NotoSans-Bold", size: 16.0)
        appearingForgotPasswordButton.setTitleColor(.white, for: .normal)
        
        // Set up Text View with Required Fonts and URLs
        var labelText = """
        By Logging in, you agree to the iArrive
        Terms of Service and Privacy Policy
        """
        var stringAttribute = [NSAttributedString.Key.font : UIFont(name: "NotoSans-Regular", size: 16)!, .foregroundColor : UIColor.white]
        var string = NSMutableAttributedString(string: labelText, attributes: stringAttribute)
        var textRange = string.mutableString.range(of: "Terms of Service")
        string.addAttribute(.link, value: termOfServiceLink, range: textRange)
        textRange = string.mutableString.range(of: "Privacy Policy")
        string.addAttribute(.link, value: privacyPolicyLink, range: textRange)
        var linkAttribute = [NSAttributedString.Key.font: UIFont(name: "NotoSans-Medium", size: 16)!, .foregroundColor: publicFunctions().hexStringToUIColor(hex: "#C9F4FF"), .underlineStyle: 1] as [NSAttributedString.Key : Any]
        appearingExplainTextView.isEditable = false
        appearingExplainTextView.dataDetectorTypes = .link
        appearingExplainTextView.attributedText = string
        appearingExplainTextView.linkTextAttributes = linkAttribute
        appearingExplainTextView.textAlignment = .center
        appearingExplainTextView.backgroundColor = .clear
    
        // Set up Register Label
        appearingRegisterLabel.font = UIFont(name: "NotoSans-Regular", size: 32.0)
        appearingRegisterLabel.textColor = .white
        appearingRegisterLabel.textAlignment = .center
        appearingRegisterLabel.text = "Register"
        
        // Set up Text Fields
        appearingFirstNameTextField.placeholderText = "First Name"
        appearingLastNameTextField.placeholderText = "Last Name"
        appearingJobTitleTextField.placeholderText = "Job Title"
        for appearingtextfield in [appearingFirstNameTextField, appearingLastNameTextField, appearingJobTitleTextField] {
            appearingtextfield.text = ""
            appearingtextfield.isUserInteractionEnabled = false
        }
        
        // Set up Next Button
        appearingNextButton.setTitle("Next", for: .normal)
        appearingNextButton.titleLabel?.font = UIFont(name: "NotoSans-Medium", size: 24.0)
        appearingNextButton.layer.cornerRadius = 4.0
        appearingNextButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(0.3), for: .normal)
        appearingNextButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        
        // Set up Text View with Required Fonts and URLs
        labelText = """
        By registering, you agree to the iArrive
        Terms of Service and Privacy Policy
        """
        stringAttribute = [NSAttributedString.Key.font : UIFont(name: "NotoSans-Regular", size: 16)!, .foregroundColor : UIColor.white]
        string = NSMutableAttributedString(string: labelText, attributes: stringAttribute)
        textRange = string.mutableString.range(of: "Terms of Service")
        string.addAttribute(.link, value: termOfServiceLink, range: textRange)
        textRange = string.mutableString.range(of: "Privacy Policy")
        string.addAttribute(.link, value: privacyPolicyLink, range: textRange)
        linkAttribute = [NSAttributedString.Key.font: UIFont(name: "NotoSans-Medium", size: 16)!, .foregroundColor : publicFunctions().hexStringToUIColor(hex: "#C9F4FF"), .underlineStyle: 1] as [NSAttributedString.Key : Any]
        appearingExplainTextView2.isEditable = false
        appearingExplainTextView2.dataDetectorTypes = .link
        appearingExplainTextView2.attributedText = string
        appearingExplainTextView2.linkTextAttributes = linkAttribute
        appearingExplainTextView2.textAlignment = .center
        appearingExplainTextView2.backgroundColor = .clear
        
        // Set up Cancel Button
        appearingCancelButton.setTitle("     Cancel", for: .normal)
        appearingCancelButton.titleLabel?.font = UIFont(name: "NotoSans-Medium", size: 24.0)
        appearingCancelButton.setTitleColor(UIColor.darkGray.withAlphaComponent(0.5), for: .highlighted)
        appearingCancelButton.setImage(UIImage(named: "Back_2"), for: .normal)
        appearingCancelButton.contentVerticalAlignment = .fill
        appearingCancelButton.contentHorizontalAlignment = .fill
        appearingCancelButton.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 10.0)

        for item in [appearingApptechImage, appearingiArriveImage, appearingUserNameTextField, appearingPasswordTextField, appearingKeepMeLoginButton, appearingForgotPasswordButton, appearingExplainTextView, appearingRegisterLabel, appearingFirstNameTextField, appearingLastNameTextField, appearingJobTitleTextField, appearingNextButton, appearingExplainTextView2, appearingCancelButton] {
            self.view.insertSubview(item, at: 1)
            self.view.bringSubviewToFront(item)
            item.layer.opacity = 0.0
        }
        
        for item in [appearingFirstNameTextField, appearingLastNameTextField, appearingJobTitleTextField] {
            item.center.x += 200
        }
    }
}
