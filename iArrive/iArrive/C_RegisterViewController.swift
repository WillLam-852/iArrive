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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addBackgroundGradientColors()
        bottomBar.backgroundColor = UIColor(white: 1, alpha: 0.1)
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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    // MARK: Text Field Functions
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        updatedNextButtonState()
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
        } else {
            nextButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            nextButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#38C9FF").withAlphaComponent(0.5), for: .normal)
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
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressedNextButton(_ sender: UIButton) {
        performSegue(withIdentifier: "RegistertoCameraSegue", sender: self)
    }
    
  
}
