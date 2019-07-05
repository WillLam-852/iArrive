//
//  B1-1_PhotoDetectedViewController.swift
//  iArrive
//
//  Created by Will Lam on 4/7/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//

import UIKit

class B1_1_PhotoDetectedViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var notMeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = currentCheckingInOutPhoto
        imageView.transform = CGAffineTransform(scaleX: -1, y: 1)
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.insertSubview(imageView, at: 0)

        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.9
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.insertSubview(blurEffectView, at: 1)
        
        notMeButton.layer.cornerRadius = 28
    }
    
    
    // MARK: Navigation
    
    @IBAction func pressedTryAgainButton(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    

}
