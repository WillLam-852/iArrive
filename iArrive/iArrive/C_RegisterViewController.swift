//
//  C_RegisterViewController.swift
//  iArrive
//
//  Created by Lam Wun Yin on 27/6/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//

import UIKit

class C_RegisterViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var bottomBar: UILabel!
    @IBOutlet weak var firstNameTextField: FloatLabelTextField!
    @IBOutlet weak var lastNameTextField: FloatLabelTextField!
    @IBOutlet weak var jobTitleTextField: FloatLabelTextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addBackgroundGradientColors()
        bottomBar.backgroundColor = UIColor(white: 1, alpha: 0.1)
        
        firstNameTextField.text = currentRegisteringFirstName
        lastNameTextField.text = currentRegisteringLastName
        jobTitleTextField.text = currentRegisteringJobTitle
        firstNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        jobTitleTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        updatedNextButtonState()
        
        firstNameTextField.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        lastNameTextField.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        jobTitleTextField.attributedPlaceholder = NSAttributedString(string: "Job Title", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        for i in [firstNameTextField, lastNameTextField, jobTitleTextField] {
            i?.layer.borderColor = UIColor.white.cgColor
            i?.layer.borderWidth = 2.0
            i?.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
            i?.leftViewMode = .always
        }
        
        nextButton.layer.cornerRadius = 4.0
<<<<<<< HEAD
        nextButton.layer.applySketchShadow(
            color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.25),
            alpha: 1.0,
            x: 0,
            y: 0,
            blur: 4,
            spread: 0)
=======
        nextButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        nextButton.layer.shadowOffset = .zero
        nextButton.layer.shadowOpacity = 1.0
        nextButton.layer.shadowRadius = 0.0
>>>>>>> 2a7e7bf93e17e803e1c7345aaf49754c91d6a584
        nextButton.layer.masksToBounds = false
        
        cancelButton.addTarget(self, action: #selector(buttonPressing), for: .touchDown)
        cancelButton.addTarget(self, action: #selector(buttonPressedInside), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(buttonDraggedInside), for: .touchDragInside)
        cancelButton.addTarget(self, action: #selector(buttonDraggedOutside), for: .touchDragOutside)
        nextButton.addTarget(self, action: #selector(buttonPressing), for: .touchDown)
        nextButton.addTarget(self, action: #selector(buttonPressedInside), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(buttonDraggedInside), for: .touchDragInside)
        nextButton.addTarget(self, action: #selector(buttonDraggedOutside), for: .touchDragOutside)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    // MARK: Text Field Functions
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        currentRegisteringFirstName = firstNameTextField.text ?? ""
        currentRegisteringLastName = lastNameTextField.text ?? ""
        currentRegisteringJobTitle = jobTitleTextField.text ?? ""
        updatedNextButtonState()
    }
    
    
    // MARK: Button Pressing Animation
    
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
    
    
    // MARK: Private Methods
    
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
    
    
    private func addBackgroundGradientColors() {
        view.backgroundColor = UIColor.clear
        let backgroundLayer = backgroundGradientColors().gl
        backgroundLayer.frame = view.frame
        view.layer.insertSublayer(backgroundLayer, at: 0)
    }
    
    
    // MARK: Navigation
    
    @IBAction func pressedCancelButton(_ sender: Any) {
        currentRegisteringFirstName = ""
        currentRegisteringLastName = ""
        currentRegisteringJobTitle = ""
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressedNextButton(_ sender: UIButton) {
        if staffNameList.contains(where: {(staff : staffMember) -> Bool in
            return (staff.firstName.lowercased() == currentRegisteringFirstName.lowercased()) && (staff.lastName.lowercased() == currentRegisteringLastName.lowercased())
        }){
            let alert = UIAlertController(title: "Existing Staff Name", message: "Please input a new staff", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
            performSegue(withIdentifier: "RegistertoCameraSegue", sender: self)
        }
    }
    
  
}
