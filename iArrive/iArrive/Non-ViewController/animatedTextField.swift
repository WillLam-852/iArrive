//
//  animatedTextField.swift
//  iArrive
//
//  Created by Will Lam on 25/7/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//

import UIKit

@IBDesignable
class animatedTextField: UIView {

    // MARK: Local Variables
    let animationDuration = 0.3
    let bordersWidth: CGFloat = 1.0
    var mainTextField = UITextField()
    var placeholderLabel = UILabel()
    let magnifiedPlaceholderLabel = UILabel()
    let minifiedPlaceholderLabel = UILabel()
    let underlineView = UIView()
    let upperlineView = UIView()
    let leftlineView = UIView()
    let rightlineView = UIView()
    let showPasswordButton = UIButton()
    var borderStatus = 0                // 0 for underline, 1 for whole borders
    var placeholderLabelStatus = 0      // 0 for minified, 1 for magnified
    var isPlaceholderSetup = false      // For avoiding setting up placeholderlabel repeatedly
    
    // MARK: Properties
    var placeholderText: String? {
        didSet {
            placeholderLabel.text = placeholderText
            if text == nil {
                mainTextField.text = ""
                text = ""
            }
            setup()
        }
    }
    
    var text: String? {
        didSet {
            if text != "" {
                mainTextField.text = text
                text = ""
            } else {
                mainTextField.text = ""
            }
            setup()
        }
    }
    
    var isSecureTextEntry: Bool? {
        didSet {
            if isSecureTextEntry == true {
                setupShowPasswordButton()
                mainTextField.frame = CGRect(x: 15.0, y: 20.0, width: frame.width-15.0-self.frame.height, height: frame.height-20.0)
                mainTextField.isSecureTextEntry = true
            }
        }
    }
    
    // MARK: Initialization
    required init?(coder aDecoder:NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
    }
    
    
    // MARK: private Methods

    private func setup() {
        backgroundColor = .clear
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = 4.0
        for borderSubview in [underlineView, upperlineView, leftlineView, rightlineView] {
            borderSubview.backgroundColor = .white
        }
        
        if isSecureTextEntry == true {
            mainTextField.frame = CGRect(x: 15.0, y: 20.0, width: frame.width-15.0-self.frame.height, height: frame.height-20.0)
        } else {
            mainTextField.frame = CGRect(x: 15.0, y: 20.0, width: frame.width-30.0, height: frame.height-20.0)
        }
        mainTextField.textColor = .white
        mainTextField.font = UIFont(name: "NotoSans-SemiBold", size: 20.0)
        
        setupPlaceholder()
        
        if mainTextField.text == "" {
            setupFullBorders()
        } else {
            setupUnderlineBorder()
        }
    
        for subview in [mainTextField, placeholderLabel, underlineView, upperlineView, leftlineView, rightlineView] {
            self.addSubview(subview)
            self.bringSubviewToFront(subview)
        }
        
        // Associate textfield objects with action methods
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
        mainTextField.addTarget(self, action: #selector(textFieldTap), for: .touchDown)
        mainTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        mainTextField.addTarget(self, action: #selector(textFieldCancel), for: .editingDidEnd)
    }
    
    private func setupShowPasswordButton() {
        showPasswordButton.frame = CGRect(x: self.frame.width - self.frame.height, y: 0, width: self.frame.height, height: self.frame.height)
        showPasswordButton.imageEdgeInsets = UIEdgeInsets(top: 19, left: 19, bottom: 19, right: 19)
        showPasswordButton.setImage(UIImage(named: "Unshow"), for: .normal)
        showPasswordButton.contentHorizontalAlignment = .fill
        showPasswordButton.contentVerticalAlignment = .fill
        showPasswordButton.isHidden = true
        showPasswordButton.addTarget(self, action: #selector(showPasswordButtonAction), for: .touchUpInside)
        self.addSubview(showPasswordButton)
        self.bringSubviewToFront(showPasswordButton)
    }

    
    private func updateTextFieldStatus() {
        if mainTextField.isFirstResponder && borderStatus == 0 {
            UIView.animate(withDuration: animationDuration, delay: 0, options: [.curveEaseInOut, .beginFromCurrentState], animations: {
                self.backgroundColor = UIColor.black.withAlphaComponent(0.05)
                self.setupHalfBorders()
            }, completion: { finished in
                self.borderStatus = 1
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: {
                self.setupFullBorders()
            })
        } else if mainTextField.text != "" && !mainTextField.isFirstResponder && borderStatus == 1 {
            setupHalfBorders()
            UIView.animate(withDuration: animationDuration, delay: 0, options: [.curveEaseInOut, .beginFromCurrentState], animations: {
                self.backgroundColor = .clear
                self.setupUnderlineBorder()
            }, completion: { finish in
                self.borderStatus = 0
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: {
                self.setupUnderlineBorder()
            })
        }
        
        if mainTextField.text == "" && !mainTextField.isFirstResponder {
            if placeholderLabelStatus == 0 {
                magnifyingPlaceholder()
            }
        } else {
            if placeholderLabelStatus == 1 {
                minifyingPlaceholder()
            }
        }
    }
    
    
    private func magnifyingPlaceholder() {
        UIView.animate(withDuration: animationDuration, delay: 0, options: [.curveEaseInOut, .beginFromCurrentState], animations: {
            self.placeholderLabel.transform = .identity
            self.backgroundColor = .clear
            self.layer.opacity = 0.5
        }, completion: { finished in
            self.placeholderLabelStatus = 1
        })
    }
    
    private func minifyingPlaceholder() {
        UIView.animate(withDuration: animationDuration, delay: 0, options: [.curveEaseInOut, .beginFromCurrentState], animations: {
            self.placeholderLabel.transform = self.scaleTransform(from: self.magnifiedPlaceholderLabel.frame.size, to: self.minifiedPlaceholderLabel.frame.size).concatenating(self.translateTransform(from: self.magnifiedPlaceholderLabel.center, to: self.minifiedPlaceholderLabel.center))
            self.backgroundColor = UIColor.black.withAlphaComponent(0.05)
            self.layer.opacity = 1.0
        }, completion: { finished in
            self.placeholderLabelStatus = 0
        })
    }
    
    private func setupPlaceholder() {
        layer.opacity = 0.5
        magnifiedPlaceholderLabel.text = placeholderText
        magnifiedPlaceholderLabel.font = UIFont(name: "NotoSans-SemiBold", size: 24.0)
        magnifiedPlaceholderLabel.frame = CGRect(x: 15.0, y: 15.0, width: magnifiedPlaceholderLabel.intrinsicContentSize.width, height: magnifiedPlaceholderLabel.intrinsicContentSize.height)
        magnifiedPlaceholderLabel.textColor = .white
        
        minifiedPlaceholderLabel.text = placeholderText
        minifiedPlaceholderLabel.font = UIFont(name: "NotoSans-SemiBold", size: 12.0)
        minifiedPlaceholderLabel.frame = CGRect(x: 15.0, y: 10.0, width: minifiedPlaceholderLabel.intrinsicContentSize.width, height: minifiedPlaceholderLabel.intrinsicContentSize.height)
        
        if !isPlaceholderSetup {
            placeholderLabel = magnifiedPlaceholderLabel.copyLabel()
            isPlaceholderSetup = true
        }
        
        if mainTextField.text == "" {   // Large Label
            placeholderLabelStatus = 1
            placeholderLabel.transform = .identity
        } else {                        // Small Label
            layer.opacity = 1.0
            placeholderLabelStatus = 0
            placeholderLabel.transform = scaleTransform(from: magnifiedPlaceholderLabel.frame.size, to: minifiedPlaceholderLabel.frame.size).concatenating(self.translateTransform(from: magnifiedPlaceholderLabel.center, to: minifiedPlaceholderLabel.center))
        }
    }
    
    private func setupFullBorders() {
        layer.borderWidth = bordersWidth
        underlineView.frame = CGRect(x: bordersWidth*2, y: self.frame.height-bordersWidth, width: self.frame.width-bordersWidth*4, height: bordersWidth)
        upperlineView.frame = CGRect(x: bordersWidth*2, y: 0, width: self.frame.width-bordersWidth*4, height: bordersWidth)
        leftlineView.frame = CGRect(x: 0, y: bordersWidth*2, width: bordersWidth, height: self.frame.height-bordersWidth*4)
        rightlineView.frame = CGRect(x: self.frame.width-bordersWidth, y: bordersWidth*2, width: bordersWidth, height: self.frame.height-bordersWidth*4)
        borderStatus = 1
    }
    
    private func setupHalfBorders() {
        underlineView.frame = CGRect(x: 0.0, y: self.frame.height-bordersWidth, width: self.frame.width, height: bordersWidth)
        upperlineView.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: bordersWidth)
        leftlineView.frame = CGRect(x: 0.0, y: 0.0, width: bordersWidth, height: self.frame.height)
        rightlineView.frame = CGRect(x: self.frame.width-bordersWidth, y: 0.0, width: bordersWidth, height: self.frame.height)
    }
    
    private func setupUnderlineBorder() {
        layer.borderWidth = 0.0
        underlineView.frame = CGRect(x: 0.0, y: self.frame.height-bordersWidth*1.5, width: self.frame.width, height: bordersWidth*1.5)
        upperlineView.frame = underlineView.frame
        leftlineView.frame = CGRect(x: 0.0, y: self.frame.height-self.bordersWidth, width: self.bordersWidth, height: self.bordersWidth)
        rightlineView.frame = CGRect(x: self.frame.width-self.bordersWidth, y: self.frame.height-self.bordersWidth, width: self.bordersWidth, height: self.bordersWidth)
        borderStatus = 0
    }
    
    private func scaleTransform(from: CGSize, to: CGSize) -> CGAffineTransform {
        let scaleX = to.width / from.width
        let scaleY = to.height / from.height
        return CGAffineTransform(scaleX: scaleX, y: scaleY)
    }
    
    private func translateTransform(from: CGPoint, to: CGPoint) -> CGAffineTransform {
        let translateX = to.x - from.x
        let translateY = to.y - from.y
        return CGAffineTransform(translationX: translateX, y: translateY)
    }
    
    
    
    // MARK: Action Methods for Text Field
    
    @objc func tapped() {
        mainTextField.becomeFirstResponder()
        updateTextFieldStatus()
        if mainTextField.text == "" {
            showPasswordButton.isHidden = true
        } else {
            showPasswordButton.isHidden = false
        }
    }
    
    @objc func textFieldTap(_ textField: UITextField) {
        mainTextField.becomeFirstResponder()
        if mainTextField.text == "" {
            showPasswordButton.isHidden = true
        } else {
            showPasswordButton.isHidden = false
        }
        updateTextFieldStatus()
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        updateTextFieldStatus()
        if mainTextField.text == "" {
            showPasswordButton.isHidden = true
        } else {
            showPasswordButton.isHidden = false
        }
    }
    
    @objc func textFieldCancel(_ textField: UITextField) {
        updateTextFieldStatus()
        showPasswordButton.isHidden = true
    }
    
    
    // MARK: Action Method for showPasswordButton
    
    @objc func showPasswordButtonAction(sender: UIButton!) {
        if !mainTextField.isSecureTextEntry {
            mainTextField.isSecureTextEntry = true
            showPasswordButton.setImage(UIImage(named: "Unshow"), for: .normal)
        } else {
            mainTextField.isSecureTextEntry = false
            showPasswordButton.setImage(UIImage(named: "Show"), for: .normal)
        }
    }
}
