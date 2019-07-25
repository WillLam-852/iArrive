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
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var firstNameTextField: FloatLabelTextField!
    @IBOutlet weak var lastNameTextField: FloatLabelTextField!
    @IBOutlet weak var jobTitleTextField: FloatLabelTextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var explainTextView: UITextView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var bottomBar: UILabel!
    
    var backgroundColorView: UIView!
    
    // MARK: Properties (for animation)
    let greetingLabel = UILabel()
    let logoutButton = UIButton()
    let checkInOutButton = UIButton()
    let addMemberLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Update delegate
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        jobTitleTextField.delegate = self
        explainTextView.delegate = self
        
        // Set up Background and Bottom Bar Color
        addBackgroundGradientColors()
        backgroundColorView = UIView()
        backgroundColorView.frame = self.view.frame
        backgroundColorView.backgroundColor = publicFunctions().hexStringToUIColor(hex: "#0027FF").withAlphaComponent(0.1)
        backgroundColorView.isUserInteractionEnabled = false
        self.view.insertSubview(backgroundColorView, at: 1)
        bottomBar.backgroundColor = UIColor(white: 1, alpha: 0.1)
        
        configurateElements()
        configurateAppearingElements()
        
        // Set up English/Chinese Segmented Control
        let engChinSegmentedControl = publicFunctions().addEngChinSegmentedControl()
        view.addSubview(engChinSegmentedControl)
        
        // Associate Text Field objects with action methods (For updating Next button state)
        firstNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        jobTitleTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        // Associate Button objects with action methods (For updating button background colors and shadows)
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
        if sender === nextButton {
            disableNextButton()
        }
    }
    
    @objc func buttonPressedInside(_ sender: AnyObject?) {
        if sender === nextButton {
            enableNextButton()
        }
    }
    
    @objc func buttonDraggedInside(_ sender: AnyObject?) {
        if sender === nextButton {
            disableNextButton()
        }
    }
    
    @objc func buttonDraggedOutside(_ sender: AnyObject?) {
        if sender === nextButton {
            enableNextButton()
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
            enableNextButton()
        } else {
            disableNextButton()
        }
    }
    
    private func enableNextButton() {
        nextButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(1), for: .normal)
        nextButton.backgroundColor = UIColor.white.withAlphaComponent(1)
        nextButton.layer.showShadow()
    }
    
    private func disableNextButton() {
        nextButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#38C9FF").withAlphaComponent(0.5), for: .normal)
        nextButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        nextButton.layer.hideShadow()
    }
    
    private func configurateElements() {
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
            i?.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20).fixedToScreenRatio())
            i?.leftViewMode = .always
        }
        
        // Set up Next Button
        nextButton.layer.cornerRadius = 4.0
        nextButton.layer.applySketchShadow(
            color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.16),
            x: 0,
            y: 3,
            blur: 6,
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
        
        // Set up Cancel Button
        cancelButton.setTitleColor(UIColor.darkGray.withAlphaComponent(0.5), for: .highlighted)
    }
    
    
    
    // MARK: Navigation
    
    // Back to Sign In Page when user presses Cancel button
    @IBAction func pressedCancelButton(_ sender: Any) {
        currentRegisteringFirstName = nil
        currentRegisteringLastName = nil
        currentRegisteringJobTitle = nil
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [], animations: {
            for item in [self.registerLabel, self.firstNameTextField, self.lastNameTextField, self.jobTitleTextField, self.nextButton, self.explainTextView, self.cancelButton] {
                item!.layer.opacity = 0.0
            }
            for item in [self.greetingLabel, self.logoutButton, self.checkInOutButton, self.addMemberLabel] {
                item.layer.opacity = 1.0
            }
            self.backgroundColorView.frame = CGRect(x: 224.0, y: 516.0, width: 320.0, height: 56.0).fixedToScreenRatio()
            self.backgroundColorView.backgroundColor = publicFunctions().hexStringToUIColor(hex: "#0027FF").withAlphaComponent(0.2)
        }, completion: { finished in
            self.dismiss(animated: false, completion: nil)
        })
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
    
    private func configurateAppearingElements() {
        greetingLabel.frame = CGRect(x: 80.0, y: 274.0, width: 608.0, height: 28.0).fixedToScreenRatio()
        logoutButton.frame = CGRect(x: 323.0, y: 318.0, width: 122.0, height: 28.0).fixedToScreenRatio()
        checkInOutButton.frame = CGRect(x: 224.0, y: 436.0, width: 320.0, height: 56.0).fixedToScreenRatio()
        addMemberLabel.frame = CGRect(x: 224.0, y: 516.0, width: 320.0, height: 56.0).fixedToScreenRatio()
        
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
        greetingLabel.textColor = .white
        greetingLabel.textAlignment = .center
        
        // Set up Logout Button
        logoutButton.setTitle("   Logout", for: .normal)
        logoutButton.titleLabel?.font = UIFont(name: "NotoSans-Medium", size: 24)
        logoutButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#3BACD0").withAlphaComponent(1.0), for: .normal)
        logoutButton.setTitleColor(UIColor.black.withAlphaComponent(0.5), for: .highlighted)
        logoutButton.setImage(UIImage(named: "Logout"), for: .normal)
        logoutButton.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: -10.0)
        logoutButton.contentHorizontalAlignment = .fill
        logoutButton.contentVerticalAlignment = .fill
        
        // Set up Check In/Out Button
        checkInOutButton.setTitle("Check in /Out", for: .normal)
        checkInOutButton.titleLabel?.font = UIFont(name: "NotoSans-Medium", size: 24.0)
        checkInOutButton.layer.cornerRadius = 4.0
        checkInOutButton.layer.applySketchShadow(
            color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.16),
            x: 0,
            y: 3,
            blur: 6,
            spread: 0)
        checkInOutButton.layer.showShadow()
        checkInOutButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(1.0), for: .normal)
        checkInOutButton.backgroundColor = UIColor.white
        
        // Set up Add Member Button
        addMemberLabel.textAlignment = .center
        addMemberLabel.font = UIFont(name: "NotoSans-Medium", size: 24.0)
        addMemberLabel.textColor = .white
        addMemberLabel.text = "Add Member"
        
        for item in [greetingLabel, logoutButton, checkInOutButton, addMemberLabel] {
            self.view.addSubview(item)
            self.view.bringSubviewToFront(item)
            item.layer.opacity = 0.0
        }
    }
}
