//
//  B_LoginViewController.swift
//  iArrive
//
//  Created by Lam Wun Yin on 26/6/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//

import UIKit

class B_LoginViewController: UIViewController {

    @IBOutlet weak var userNameTextField: FloatLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        userNameTextField.attributedPlaceholder = NSAttributedString(string: "User Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
//        userNameTextField.borderStyle = .roundedRect
        userNameTextField.layer.borderColor = UIColor.white.cgColor
        userNameTextField.layer.borderWidth = 2.0
        userNameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        userNameTextField.leftViewMode = .always
        

    }

}
