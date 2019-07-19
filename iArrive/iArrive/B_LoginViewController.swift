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
    @IBOutlet weak var userNameTextField: FloatLabelTextField!
    @IBOutlet weak var passwordTextField: FloatLabelTextField!
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var keepMeLoginButton: CheckBox!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var explainTextView: UITextView!
    @IBOutlet weak var bottomBar: UILabel!
    
    
    // MARK: Local Variable
    var isShownPassword = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TO BE DELETED
        userNameTextField.text = "richard.zhang@apptech.com.hk"
        passwordTextField.text = "123456"
        
        // Update delegate
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        explainTextView.delegate = self
        
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
            i?.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
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
            y: 6,
            blur: 6,
            spread: 0)
        
        // Set up English/Chinese Segmented Control
        let engChinSegmentedControl = publicFunctions().addEngChinSegmentedControl()
        view.addSubview(engChinSegmentedControl)
        
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
        // Initialize Login button state
        updatedLoginButtonState()
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
                if self.keepMeLoginButton.isChecked {
                    UserDefaults.standard.set(companyName, forKey: "companyName")
                    UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                    UserDefaults.standard.synchronize()
                }
                self.userNameTextField.text = ""
                self.passwordTextField.text = ""
                self.performSegue(withIdentifier: "LogintoSignInSegue", sender: self)
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
}

