//
//  A_LoadingViewController.swift
//  iArrive
//
//  Created by Lam Wun Yin on 25/6/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//

import UIKit

class A_LoadingViewController: UIViewController {

    // MARK: Properties
    var apptechLogo = UIImageView()
    var appIconImage = UIImageView()
    var iArriveImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apptechLogo.frame = CGRect(x: 248, y: 266, width: 272, height: 58).y_fixedToScreenRatio(false)
        appIconImage.frame = CGRect(x: 319, y: 399, width: 130, height: 128).centreRatio()
        iArriveImage.frame = CGRect(x: 322, y: 546, width: 124, height: 44).centreRatio()
        
        apptechLogo.image = UIImage(named: "Large_Logo")
        appIconImage.image = UIImage(named: "Logo")
        appIconImage.contentMode = .scaleAspectFit
        for item in [apptechLogo, appIconImage] {
            self.view.addSubview(item)
            self.view.bringSubviewToFront(item)
        }
        
        addBackgroundGradientColors()
    }
    
    
    // MARK: Private Methods
    
    // Add Background Gradient Colors
    private func addBackgroundGradientColors() {
        view.backgroundColor = UIColor.clear
        let backgroundLayer = backgroundGradientColors().gl
        backgroundLayer.frame = view.frame
        view.layer.insertSublayer(backgroundLayer, at: 0)
    }


}

