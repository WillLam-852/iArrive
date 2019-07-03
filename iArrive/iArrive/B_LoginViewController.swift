//
//  B_LoginViewController.swift
//  iArrive
//
//  Created by Lam Wun Yin on 26/6/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//

import UIKit

class B_LoginViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var userNameTextField: FloatLabelTextField!
    @IBOutlet weak var passwordTextField: FloatLabelTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var bottomBar: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isLoadSampleStaff {
            publicFunctions().loadSampleStaff()
        }
        
        addBackgroundGradientColors()
        bottomBar.backgroundColor = UIColor(white: 1, alpha: 0.1)
        userNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        loginButton.layer.cornerRadius = 4.0
        loginButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        loginButton.layer.shadowOffset = .zero
        loginButton.layer.shadowOpacity = 1.0
        loginButton.layer.shadowRadius = 0.0
        loginButton.layer.masksToBounds = false
        loginButton.addTarget(self, action: #selector(buttonPressing), for: .touchDown)
        loginButton.addTarget(self, action: #selector(buttonPressedInside), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(buttonDraggedInside), for: .touchDragInside)
        loginButton.addTarget(self, action: #selector(buttonDraggedOutside), for: .touchDragOutside)
        updatedLoginButtonState()
        
        userNameTextField.attributedPlaceholder = NSAttributedString(string: "User Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        for i in [userNameTextField, passwordTextField] {
            i?.layer.borderColor = UIColor.white.cgColor
            i?.layer.borderWidth = 2.0
            i?.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
            i?.leftViewMode = .always
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    // MARK: Button Pressing Animation
    
    @objc func buttonPressing(_ sender: AnyObject?) {
        loginButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        loginButton.layer.shadowOffset = .zero
    }
    
    @objc func buttonPressedInside(_ sender: AnyObject?) {
        loginButton.backgroundColor = UIColor.white.withAlphaComponent(1.0)
        loginButton.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
    }
    
    @objc func buttonDraggedInside(_ sender: AnyObject?) {
        loginButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        loginButton.layer.shadowOffset = .zero
    }
    
    @objc func buttonDraggedOutside(_ sender: AnyObject?) {
        loginButton.backgroundColor = UIColor.white.withAlphaComponent(1.0)
        loginButton.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
    }
    
    
    // MARK: Text Field Functions
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        updatedLoginButtonState()
    }
    
    
    // MARK: Private Methods
    
    private func updatedLoginButtonState() {
        let userNameText = userNameTextField.text ?? ""
        let passwordText = passwordTextField.text ?? ""
        loginButton.isEnabled = !userNameText.isEmpty && !passwordText.isEmpty
        
        if loginButton.isEnabled {
            loginButton.backgroundColor = UIColor.white.withAlphaComponent(1)
            loginButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(1), for: .normal)
            loginButton.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        } else {
            loginButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            loginButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#38C9FF").withAlphaComponent(0.5), for: .normal)
            loginButton.layer.shadowOffset = .zero
        }
    }
    
    private func addBackgroundGradientColors() {
        view.backgroundColor = UIColor.clear
        let backgroundLayer = backgroundGradientColors().gl
        backgroundLayer.frame = view.frame
        view.layer.insertSublayer(backgroundLayer, at: 0)
    }
    
    
    // MARK: Navigation
    
    @IBAction func pressedLoginButton(_ sender: Any) {
        if (userNameTextField.text == "user" && passwordTextField.text == "pw") {
            userNameTextField.text = ""
            passwordTextField.text = ""
            performSegue(withIdentifier: "LogintoSignInSegue", sender: self)
        } else {
            let alert = UIAlertController(title: "Wrong username / password", message: """
                Please input valid
                username and password.
                """, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
  
}

