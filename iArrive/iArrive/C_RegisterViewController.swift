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
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var firstNameTextField: animatedTextField!
    @IBOutlet weak var lastNameTextField: animatedTextField!
    @IBOutlet weak var jobTitleTextField: animatedTextField!
    @IBOutlet weak var explainTextView: UITextView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var poweredByLabel: UILabel!
    @IBOutlet weak var bottomBarLogoImage: UIImageView!
    @IBOutlet weak var bottomBar: UILabel!
    
    var backgroundColorView: UIView!
    
    // MARK: Properties (for animation)
    let appearingGreetingLabel = UILabel()
    let appearingLogoutButton = UIButton()
    let appearingCheckInOutButton = UIButton()
    let appearingAddMemberLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Update delegate
        firstNameTextField.mainTextField.delegate = self
        lastNameTextField.mainTextField.delegate = self
        jobTitleTextField.mainTextField.delegate = self
        explainTextView.delegate = self
        
        configurateElements()
        configurateAppearingElements()
        
        // Set up English/Chinese Segmented Control
        let engChinSegmentedControl = publicFunctions().addEngChinSegmentedControl()
        view.addSubview(engChinSegmentedControl)
        
        // Associate Text Field objects with action methods (For updating Next button state)
        firstNameTextField.mainTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        lastNameTextField.mainTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        jobTitleTextField.mainTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
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
        let firstNameText = firstNameTextField.mainTextField.text ?? ""
        let lastNameText = lastNameTextField.mainTextField.text ?? ""
        let jobTitleText = jobTitleTextField.mainTextField.text ?? ""
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
            for item in [self.appearingGreetingLabel, self.appearingLogoutButton, self.appearingCheckInOutButton, self.appearingAddMemberLabel] {
                item.layer.opacity = 1.0
            }
            self.backgroundColorView.frame = CGRect(x: 224.0, y: 516.0, width: 320.0, height: 56.0).centreRatio()
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
    
    private func configurateElements() {
        // Set up postions
        registerLabel.frame = CGRect(x: 297.0, y: 154.0, width: 174.0, height: 43.0).centreRatio()
        firstNameTextField.frame = CGRect(x: 224.0, y: 260.0, width: 320.0, height: 64.0).centreRatio()
        lastNameTextField.frame = CGRect(x: 224.0, y: 340.0, width: 320.0, height: 64.0).centreRatio()
        jobTitleTextField.frame = CGRect(x: 224.0, y: 420.0, width: 320.0, height: 64.0).centreRatio()
        nextButton.frame = CGRect(x: 224.0, y: 554.0, width: 320.0, height: 56.0).centreRatio()
        explainTextView.frame = CGRect(x: 224.0, y: 618.0, width: 320.0, height: 61.0).centreRatio()
        cancelButton.frame = CGRect(x: 175.0, y: 736.0, width: 158.0, height: 33.0).centreRatio()
        poweredByLabel.frame = CGRect(x: 273, y: screenHeight-42.5, width: 113, height: 27.5).x_centreRatio()
        bottomBarLogoImage.frame = CGRect(x: 394, y: screenHeight-44, width: 112, height: 29).x_centreRatio()
        bottomBar.frame = CGRect(x: 0, y: screenHeight-59, width: screenWidth, height: 59)
        
        // Set up Background and Bottom Bar Color
        addBackgroundGradientColors()
        backgroundColorView = UIView()
        backgroundColorView.frame = self.view.frame
        backgroundColorView.backgroundColor = publicFunctions().hexStringToUIColor(hex: "#0027FF").withAlphaComponent(0.1)
        backgroundColorView.isUserInteractionEnabled = false
        self.view.insertSubview(backgroundColorView, at: 1)
        bottomBar.backgroundColor = UIColor(white: 1, alpha: 0.1)
        
        // Set up Text Fields with stored data, placeholders and required format
        firstNameTextField.placeholderText = "First Name"
        lastNameTextField.placeholderText = "Last Name"
        jobTitleTextField.placeholderText = "Job Title"
        firstNameTextField.text = currentRegisteringFirstName
        lastNameTextField.text = currentRegisteringLastName
        jobTitleTextField.text = currentRegisteringJobTitle
        firstNameTextField.mainTextField.textContentType = .name
        lastNameTextField.mainTextField.textContentType = .name
        jobTitleTextField.mainTextField.textContentType = .jobTitle
        for textfield in [firstNameTextField, lastNameTextField, jobTitleTextField] {
            textfield?.mainTextField.autocapitalizationType = .words
            textfield?.mainTextField.autocorrectionType = .no
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
    
    private func configurateAppearingElements() {
        appearingGreetingLabel.frame = CGRect(x: 80.0, y: 274.0, width: 608.0, height: 28.0).centreRatio()
        appearingLogoutButton.frame = CGRect(x: 323.0, y: 318.0, width: 122.0, height: 28.0).centreRatio()
        appearingCheckInOutButton.frame = CGRect(x: 224.0, y: 436.0, width: 320.0, height: 56.0).centreRatio()
        appearingAddMemberLabel.frame = CGRect(x: 224.0, y: 516.0, width: 320.0, height: 56.0).centreRatio()
        
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
        
        // Set up Check In/Out Button
        appearingCheckInOutButton.setTitle("Check in /Out", for: .normal)
        appearingCheckInOutButton.titleLabel?.font = UIFont(name: "NotoSans-Medium", size: 24.0)
        appearingCheckInOutButton.layer.cornerRadius = 4.0
        appearingCheckInOutButton.layer.applySketchShadow(
            color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.16),
            x: 0,
            y: 3,
            blur: 6,
            spread: 0)
        appearingCheckInOutButton.layer.showShadow()
        appearingCheckInOutButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(1.0), for: .normal)
        appearingCheckInOutButton.backgroundColor = UIColor.white
        
        // Set up Add Member Button
        appearingAddMemberLabel.textAlignment = .center
        appearingAddMemberLabel.font = UIFont(name: "NotoSans-Medium", size: 24.0)
        appearingAddMemberLabel.textColor = .white
        appearingAddMemberLabel.text = "Add Member"
        
        for item in [appearingGreetingLabel, appearingLogoutButton, appearingCheckInOutButton, appearingAddMemberLabel] {
            self.view.addSubview(item)
            self.view.bringSubviewToFront(item)
            item.layer.opacity = 0.0
        }
    }
}
