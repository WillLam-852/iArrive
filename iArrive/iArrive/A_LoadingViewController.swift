//
//  A_LoadingViewController.swift
//  iArrive
//
//  Created by Lam Wun Yin on 25/6/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//

import UIKit

class A_LoadingViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addBackgroundGradientColors()
        
        _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(timeToMoveOn), userInfo: nil, repeats: false)
    }
    
    @objc func timeToMoveOn() {
        self.performSegue(withIdentifier: "toLoginViewControllerSegue", sender: self)
    }
    
    
    // MARK: Private Methods
    
    private func addBackgroundGradientColors() {
        view.backgroundColor = UIColor.clear
        let backgroundLayer = backgroundGradientColors().gl
        backgroundLayer.frame = view.frame
        view.layer.insertSublayer(backgroundLayer, at: 0)
    }


}

