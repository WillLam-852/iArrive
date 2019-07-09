//
//  C_RegisterViewController.swift
//  iArrive
//
//  Created by Lam Wun Yin on 27/6/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//

import UIKit

class C_RegisterViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    // MARK: Properties
    @IBOutlet weak var firstNameTextField: FloatLabelTextField!
    @IBOutlet weak var lastNameTextField: FloatLabelTextField!
    @IBOutlet weak var jobTitleTextField: FloatLabelTextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var explainTextView: UITextView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var bottomBar: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Update delegate
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        jobTitleTextField.delegate = self
        explainTextView.delegate = self
        
        // Set up Background and Bottom Bar Color
        addBackgroundGradientColors()
        bottomBar.backgroundColor = UIColor(white: 1, alpha: 0.1)
        
        // Set up Text Fields with stored data, placeholders and required format
        firstNameTextField.text = currentRegisteringFirstName
        lastNameTextField.text = currentRegisteringLastName
        jobTitleTextField.text = currentRegisteringJobTitle
        firstNameTextField.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        lastNameTextField.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        jobTitleTextField.attributedPlaceholder = NSAttributedString(string: "Job Title", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        for i in [firstNameTextField, lastNameTextField, jobTitleTextField] {
            i?.layer.borderColor = UIColor.white.cgColor
            i?.layer.borderWidth = 2.0
            i?.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
            i?.leftViewMode = .always
        }
        
        // Set up Next Button
        nextButton.layer.cornerRadius = 4.0
        nextButton.layer.applySketchShadow(
            color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.25),
            alpha: 1.0,
            x: 0,
            y: 0,
            blur: 4,
            spread: 0)
        
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
        
        // Associate Text Field objects with action methods (For updating Next button state)
        firstNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        jobTitleTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        // Associate Button objects with action methods (For updating button background colors and shadows)
        cancelButton.addTarget(self, action: #selector(buttonPressing), for: .touchDown)
        cancelButton.addTarget(self, action: #selector(buttonPressedInside), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(buttonDraggedInside), for: .touchDragInside)
        cancelButton.addTarget(self, action: #selector(buttonDraggedOutside), for: .touchDragOutside)
        nextButton.addTarget(self, action: #selector(buttonPressing), for: .touchDown)
        nextButton.addTarget(self, action: #selector(buttonPressedInside), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(buttonDraggedInside), for: .touchDragInside)
        nextButton.addTarget(self, action: #selector(buttonDraggedOutside), for: .touchDragOutside)
        
        // Initialize Next button state
        updatedNextButtonState()
    }
    
    // Hide keyboard when user tap space outside text field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    // MARK: Action Methods for Text Fields
    // For storing current registering staff member information and updating Next button state
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        currentRegisteringFirstName = firstNameTextField.text ?? ""
        currentRegisteringLastName = lastNameTextField.text ?? ""
        currentRegisteringJobTitle = jobTitleTextField.text ?? ""
        updatedNextButtonState()
    }
    
    
    
    // MARK: Action Methods for Buttons
    // For updating button background colors and shadows
    
    @objc func buttonPressing(_ sender: AnyObject?) {
        if sender === cancelButton {
            cancelButton.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .normal)
        } else {
            nextButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            nextButton.layer.shadowOffset = .zero
        }
    }
    
    @objc func buttonPressedInside(_ sender: AnyObject?) {
        if sender === cancelButton {
            cancelButton.setTitleColor(UIColor.white.withAlphaComponent(1.0), for: .normal)
        } else {
            nextButton.backgroundColor = UIColor.white.withAlphaComponent(1.0)
            nextButton.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        }
    }
    
    @objc func buttonDraggedInside(_ sender: AnyObject?) {
        if sender === cancelButton {
            cancelButton.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .normal)
        } else {
            nextButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            nextButton.layer.shadowOffset = .zero
        }
    }
    
    @objc func buttonDraggedOutside(_ sender: AnyObject?) {
        if sender === cancelButton {
            cancelButton.setTitleColor(UIColor.white.withAlphaComponent(1.0), for: .normal)
        } else {
            nextButton.backgroundColor = UIColor.white.withAlphaComponent(1.0)
            nextButton.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        }
    }
    
    
    
    // MARK: UITextFieldDelegate
    
    // Actions when user hits the "Done" button in the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        } else if textField === lastNameTextField {
            jobTitleTextField.becomeFirstResponder()
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
    
    // Update Next Button State
    private func updatedNextButtonState() {
        let firstNameText = firstNameTextField.text ?? ""
        let lastNameText = lastNameTextField.text ?? ""
        let jobTitleText = jobTitleTextField.text ?? ""
        nextButton.isEnabled = !firstNameText.isEmpty && !lastNameText.isEmpty && !jobTitleText.isEmpty
        if nextButton.isEnabled {
            nextButton.backgroundColor = UIColor.white.withAlphaComponent(1)
            nextButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(1), for: .normal)
            nextButton.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        } else {
            nextButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            nextButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#38C9FF").withAlphaComponent(0.5), for: .normal)
            nextButton.layer.shadowOffset = .zero
        }
    }
    
    
    
    // MARK: Navigation
    
    // Back to Sign In Page when user presses Cancel button
    @IBAction func pressedCancelButton(_ sender: Any) {
        currentRegisteringFirstName = nil
        currentRegisteringLastName = nil
        currentRegisteringJobTitle = nil
        dismiss(animated: true, completion: nil)
    }
    
    // Go to Camera Register Page when user presses Next button if there is no repeating name in the database (otherwise an alert message appears)
    @IBAction func pressedNextButton(_ sender: UIButton) {
        if staffNameList.contains(where: {(staff : staffMember) -> Bool in
            return (staff.firstName.lowercased() == currentRegisteringFirstName!.lowercased()) && (staff.lastName.lowercased() == currentRegisteringLastName!.lowercased())
        }){
            let alert = UIAlertController(title: "Existing Staff Name", message: "Please input a new staff", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
            performSegue(withIdentifier: "RegistertoCameraSegue", sender: self)
        }
    }
    
  
}
