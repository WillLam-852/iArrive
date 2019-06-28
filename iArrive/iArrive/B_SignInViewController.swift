//
//  B_SignInViewController.swift
//  iArrive
//
//  Created by Lam Wun Yin on 27/6/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//

import UIKit

class B_SignInViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var bottomBar: UILabel!
    @IBOutlet weak var organizationLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addBackgroundGradientColors()
        bottomBar.backgroundColor = UIColor(white: 1, alpha: 0.1)
        organizationLabel.text = organization + " !"
        logoutButton.imageView?.contentMode = .scaleAspectFill
        registerButton.backgroundColor = publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(0.1)
    }
    

    // MARK: Private Methods
    
    private func addBackgroundGradientColors() {
        view.backgroundColor = UIColor.clear
        let backgroundLayer = backgroundGradientColors().gl
        backgroundLayer.frame = view.frame
        view.layer.insertSublayer(backgroundLayer, at: 0)
    }

    
    // MARK: Navigations
    
    @IBAction func pressedCheckInOutButton(_ sender: UIButton) {
//        print(staffNameList.count)
    }
    
    @IBAction func pressedLogoutButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
