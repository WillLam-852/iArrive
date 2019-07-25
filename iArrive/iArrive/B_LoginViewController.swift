//
//  B_LoginViewController.swift
//  iArrive
//
//  Created by Lam Wun Yin on 26/6/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class B_LoginViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    
    // MARK: Properties
    @IBOutlet weak var ApptechImage: UIImageView!
    @IBOutlet weak var iArriveImage: UILabel!
    @IBOutlet weak var userNameTextField: FloatLabelTextField!
    @IBOutlet weak var passwordTextField: FloatLabelTextField!
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var keepMeLoginButton: CheckBox!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var explainTextView: UITextView!
    @IBOutlet weak var bottomBar: UILabel!
    @IBOutlet weak var poweredByLabel: UILabel!
    @IBOutlet weak var bottomBarLogoImage: UIImageView!
    
    // MARK: Properties (for animation)
    let disappearingApptechImage = UIImageView()
    let disappearingAppIconImage = UIImageView()
    let appearingGreetingLabel = UILabel()
    let appearingLogoutButton = UIButton()
    let appearingAddMemberButton = UIButton()
    
    // MARK: Local Variable
    var engChinSegmentedControl = UIView()
    var isShownPassword = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Update delegate
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        explainTextView.delegate = self
        
        // Associate Text Field objects with action methods (For updating Login button and Show Password button states)
        userNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        userNameTextField.addTarget(self, action: #selector(textFieldTap), for: .touchDown)
        passwordTextField.addTarget(self, action: #selector(textFieldTap), for: .touchDown)
        
        // Associate Button objects with action methods (For updating button background colors and shadows)
        loginButton.addTarget(self, action: #selector(buttonPressing), for: .touchDown)
        loginButton.addTarget(self, action: #selector(buttonPressedInside), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(buttonDraggedInside), for: .touchDragInside)
        loginButton.addTarget(self, action: #selector(buttonDraggedOutside), for: .touchDragOutside)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userNameTextField.text = ""
        passwordTextField.text = ""
        
        // TO BE DELETED
        userNameTextField.text = "richard.zhang@apptech.com.hk"
        passwordTextField.text = "123456"
        
        configurateElements()
        configurateDisappearingElements()
        
        // For first-time open the app
        if !isLoadedLoginPage {
            iArriveImage.frame = CGRect(x: 322.0, y: 546.0, width: 124.0, height: 44.0).fixedToScreenRatio()
            for item in [ApptechImage, explainTextView, engChinSegmentedControl, bottomBar, poweredByLabel, bottomBarLogoImage] {
                item!.layer.opacity = 0.0
            }
            for item in [userNameTextField, passwordTextField, keepMeLoginButton, forgotPasswordButton, loginButton] {
                item!.center.x += 250
                item!.layer.opacity = 0.0
            }
        } else { // For showing the view after logging out
            for item in [disappearingApptechImage, disappearingAppIconImage, appearingGreetingLabel, appearingLogoutButton, appearingAddMemberButton] {
                item.layer.opacity = 0.0
            }
        }
        updatedLoginButtonState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Set up Fade-in animation
        if !isLoadedLoginPage {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [],
                           animations: {
                self.disappearingApptechImage.layer.opacity = 0.0
                self.disappearingAppIconImage.layer.opacity = 0.0
            },
                           completion: nil)
            UIView.animate(withDuration: 0.8, delay: 0.0, options: [],
                           animations: {
                            self.iArriveImage.frame = CGRect(x: 322.0, y: 279.0, width: 124.0, height: 44.0).fixedToScreenRatio()
            },
                           completion: nil)
            UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseInOut,
                           animations: {
                            for item in [self.ApptechImage, self.explainTextView, self.engChinSegmentedControl, self.bottomBar, self.poweredByLabel, self.bottomBarLogoImage] {
                                item!.layer.opacity = 1.0
                            }
            },
                           completion: nil)
            UIView.animate(withDuration: 0.7, delay: 0.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 7.0, options: [.curveEaseOut], animations: {
                self.userNameTextField.center.x -= 250
                self.userNameTextField.layer.opacity = 1.0
            }, completion: nil)
            UIView.animate(withDuration: 0.7, delay: 0.6, usingSpringWithDamping: 0.7, initialSpringVelocity: 7.0, options: [.curveEaseOut], animations: {
                self.passwordTextField.center.x -= 250
                self.passwordTextField.layer.opacity = 1.0
            }, completion: nil)
            UIView.animate(withDuration: 0.7, delay: 0.7, usingSpringWithDamping: 0.7, initialSpringVelocity: 7.0, options: [.curveEaseOut], animations: {
                self.keepMeLoginButton.center.x -= 250
                self.forgotPasswordButton.center.x -= 250
                self.keepMeLoginButton.layer.opacity = 1.0
                self.forgotPasswordButton.layer.opacity = 1.0
            }, completion: nil)
            UIView.animate(withDuration: 0.7, delay: 0.8, usingSpringWithDamping: 0.7, initialSpringVelocity: 7.0, options: [.curveEaseOut], animations: {
                self.loginButton.center.x -= 250
                self.loginButton.layer.opacity = 1.0
            }, completion: nil)
            isLoadedLoginPage = true
        }
    }
    
    // Hide keyboard when user tap space outside text field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        showPasswordButton.isHidden = true
    }
    
    
    
    // MARK: Action Methods for Text Fields
    // For updating Login button and Show Password button states
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        updatedLoginButtonState()
    }
    
    @objc func textFieldTap(_ textField: UITextField) {
        if textField === userNameTextField {
            showPasswordButton.isHidden = true
        } else {
            showPasswordButton.isHidden = false
        }
    }
    
    
    
    // MARK: Action Methods for Buttons
    // For updating button background colors and shadows
    
    @objc func buttonPressing(_ sender: AnyObject?) {
        disableLoginButton()
    }
    
    @objc func buttonPressedInside(_ sender: AnyObject?) {
        enableLoginButton()
    }
    
    @objc func buttonDraggedInside(_ sender: AnyObject?) {
        disableLoginButton()
    }
    
    @objc func buttonDraggedOutside(_ sender: AnyObject?) {
        enableLoginButton()
    }

    
    
    // MARK: UITextFieldDelegate
    
    // Actions when user hits the "Done" button in the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === userNameTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    
    
    // MARK: UITextViewDelegate
    
    // Set up the URL links in the Text View
    private func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        if (URL.absoluteString == termOfServiceLink) {
            UIApplication.shared.open(URL as URL)
        } else if (URL.absoluteString == privacyPolicyLink) {
            UIApplication.shared.open(URL as URL)
        }
        return false
    }
    
    
    
    // MARK: Private Methods
    
    // Add Background Gradient Colors
    private func addBackgroundGradientColors() {
        view.backgroundColor = UIColor.clear
        let backgroundLayer = backgroundGradientColors().gl
        backgroundLayer.frame = view.frame
        view.layer.insertSublayer(backgroundLayer, at: 0)
    }
    
    // Update Login Button State
    private func updatedLoginButtonState() {
        let userNameText = userNameTextField.text ?? ""
        let passwordText = passwordTextField.text ?? ""
        loginButton.isEnabled = !userNameText.isEmpty && !passwordText.isEmpty
        if loginButton.isEnabled {
            enableLoginButton()
        } else {
            disableLoginButton()
        }
    }
    
    private func enableLoginButton() {
        loginButton.backgroundColor = UIColor.white.withAlphaComponent(1)
        loginButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(1), for: .normal)
        loginButton.layer.showShadow()
    }
    
    private func disableLoginButton() {
        loginButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        loginButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#38C9FF").withAlphaComponent(0.5), for: .normal)
        loginButton.layer.hideShadow()
    }
    
    
    // MARK: Actions
    
    // Hide / Unhide Password when user presses Show Password Button
    @IBAction func pressedShowPasswordButton(_ sender: Any) {
        if !isShownPassword {
            passwordTextField.isSecureTextEntry = false
            showPasswordButton.setImage(UIImage(named: "Unshow"), for: .normal)
            isShownPassword = true
        } else {
            passwordTextField.isSecureTextEntry = true
            showPasswordButton.setImage(UIImage(named: "Show"), for: .normal)
            isShownPassword = false
        }
    }
    
    // Open URL when user presses Forgot Passord Button
    @IBAction func pressedForgotPassordButton(_ sender: Any) {
        UIApplication.shared.open(NSURL(string: forgotPasswordLink)! as URL)
    }
    
    
    
    // MARK: Navigation
    
    // Go to Sign In Page if the username and password are matched (otherwise an alert message appears)
    @IBAction func pressedLoginButton(_ sender: Any) {
        API().LogInAPI(username: userNameTextField.text!, password: passwordTextField.text!) { (responseObject, error, isLogIn) in
            if isLogIn {
                self.configurateAppearingElements()
                if self.keepMeLoginButton.isChecked {
                    UserDefaults.standard.set(companyName, forKey: "companyName")
                    UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                    UserDefaults.standard.synchronize()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.53) {
                    self.loginButton.setTitle("Login", for: .normal)
                }
                UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                    for item in [self.ApptechImage, self.forgotPasswordButton, self.explainTextView, self.userNameTextField, self.passwordTextField, self.keepMeLoginButton, self.iArriveImage] {
                        item!.layer.opacity = 0.0
                    }
                    for item in [self.appearingGreetingLabel, self.appearingLogoutButton, self.appearingAddMemberButton] {
                        item.layer.opacity = 1.0
                    }
                    self.loginButton.center.y = 464.0
                    self.loginButton.setTitle("Check in /Out", for: .normal)
                }, completion: { finished in
                    self.performSegue(withIdentifier: "LogintoSignInSegue", sender: self)
                })
            } else {
                let alert = UIAlertController(title: "Wrong username / password", message: """
                    Please input valid
                    username and password.
                    """, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    
    
    
    
    // MARK: Configurate Elements
    
    private func configurateElements() {
        // Set up Background and Bottom Bar Color
        addBackgroundGradientColors()
        bottomBar.backgroundColor = UIColor(white: 1, alpha: 0.1)
        
        // Set up UserNameTextField and PasswordTextField
        passwordTextField.setRightPaddingPoints(45)
        userNameTextField.attributedPlaceholder = NSAttributedString(string: "User Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        for i in [userNameTextField, passwordTextField] {
            i?.layer.borderColor = UIColor.white.cgColor
            i?.layer.borderWidth = 2.0
            i?.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20).fixedToScreenRatio())
            i?.leftViewMode = .always
        }
        
        // Set up Show Password Button
        showPasswordButton.imageEdgeInsets = UIEdgeInsets(top: 35, left: 35, bottom: 35, right: 35);
        showPasswordButton.isHidden = true
        
        // Set up Text View with Required Fonts and URLs
        let labelText = """
        By Logging in, you agree to the iArrive
        Terms of Service and Privacy Policy
        """
        let stringAttribute = [NSAttributedString.Key.font : UIFont(name: "NotoSans-Regular", size: 16)!, .foregroundColor : UIColor.white]
        let string = NSMutableAttributedString(string: labelText, attributes: stringAttribute)
        var textRange = string.mutableString.range(of: "Terms of Service")
        string.addAttribute(.link, value: termOfServiceLink, range: textRange)
        textRange = string.mutableString.range(of: "Privacy Policy")
        string.addAttribute(.link, value: privacyPolicyLink, range: textRange)
        let linkAttribute = [NSAttributedString.Key.font: UIFont(name: "NotoSans-Medium", size: 16)!, .foregroundColor: publicFunctions().hexStringToUIColor(hex: "#C9F4FF"), .underlineStyle: 1] as [NSAttributedString.Key : Any]
        explainTextView.isEditable = false
        explainTextView.dataDetectorTypes = .link
        explainTextView.attributedText = string
        explainTextView.linkTextAttributes = linkAttribute
        explainTextView.textAlignment = .center
        
        // Set up Login Button
        loginButton.layer.cornerRadius = 4.0
        loginButton.layer.applySketchShadow(
            color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.16),
            x: 0,
            y: 3,
            blur: 6,
            spread: 0)
        
        // Set up English/Chinese Segmented Control
        if !isengChinSegmentedControl {
            engChinSegmentedControl = publicFunctions().addEngChinSegmentedControl()
            view.addSubview(engChinSegmentedControl)
            isengChinSegmentedControl = true
        }
        
        loginButton.frame = CGRect(x: 224.0, y: 600.0, width: 320.0, height: 56.0).fixedToScreenRatio()
        
        for item in [ApptechImage, forgotPasswordButton, explainTextView, engChinSegmentedControl, bottomBar, poweredByLabel, bottomBarLogoImage, userNameTextField, passwordTextField, keepMeLoginButton, loginButton, iArriveImage] {
            item!.layer.opacity = 1.0
        }
    }
    
    private func configurateDisappearingElements() {
        disappearingApptechImage.frame = CGRect(x: 248.0, y: 266.0, width: 272.0, height: 58.0).fixedToScreenRatio()
        disappearingAppIconImage.frame = CGRect(x: 319.0, y: 399.0, width: 130.0, height: 128.0).fixedToScreenRatio()
        disappearingApptechImage.image = UIImage(named: "Large_Logo")
        disappearingAppIconImage.image = UIImage(named: "Logo")
        disappearingAppIconImage.contentMode = .scaleAspectFit
        for item in [disappearingAppIconImage, disappearingAppIconImage] {
            self.view.addSubview(item)
            self.view.bringSubviewToFront(item)
            item.layer.opacity = 1.0
        }
    }
    
    private func configurateAppearingElements() {
        appearingGreetingLabel.frame = CGRect(x: 80.0, y: 274.0, width: 608.0, height: 28.0).fixedToScreenRatio()
        appearingLogoutButton.frame = CGRect(x: 323.0, y: 318.0, width: 122.0, height: 28.0).fixedToScreenRatio()
        appearingAddMemberButton.frame = CGRect(x: 224.0, y: 516.0, width: 320.0, height: 56.0).fixedToScreenRatio()
        
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
        appearingGreetingLabel.attributedText = attributedString
        appearingGreetingLabel.textColor = .white
        appearingGreetingLabel.textAlignment = .center
        
        // Set up Logout Button
        appearingLogoutButton.setTitle("   Logout", for: .normal)
        appearingLogoutButton.titleLabel?.font = UIFont(name: "NotoSans-Medium", size: 24)
        appearingLogoutButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#3BACD0").withAlphaComponent(1.0), for: .normal)
        appearingLogoutButton.setTitleColor(UIColor.black.withAlphaComponent(0.5), for: .highlighted)
        appearingLogoutButton.setImage(UIImage(named: "Logout"), for: .normal)
        appearingLogoutButton.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: -10.0)
        appearingLogoutButton.contentHorizontalAlignment = .fill
        appearingLogoutButton.contentVerticalAlignment = .fill
        
        // Set up Add Member Button
        appearingAddMemberButton.setTitle("Add Member", for: .normal)
        appearingAddMemberButton.titleLabel?.font = UIFont(name: "NotoSans-Medium", size: 24.0)
        appearingAddMemberButton.titleLabel?.textColor = .white
        appearingAddMemberButton.titleLabel?.textAlignment = .center
        appearingAddMemberButton.backgroundColor = publicFunctions().hexStringToUIColor(hex: "#0027FF").withAlphaComponent(0.2)
        appearingAddMemberButton.layer.cornerRadius = 4.0
        
        for item in [appearingGreetingLabel, appearingLogoutButton, appearingAddMemberButton] {
            self.view.addSubview(item)
            self.view.bringSubviewToFront(item)
            item.layer.opacity = 0.0
        }
    }
}
