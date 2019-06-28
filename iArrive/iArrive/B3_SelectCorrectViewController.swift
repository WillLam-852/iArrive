//
//  B3_SelectCorrectViewController.swift
//  iArrive
//
//  Created by Lam Wun Yin on 28/6/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//

import UIKit

class B3_SelectCorrectViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var confirmButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        confirmButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        confirmButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        confirmButton.layer.shadowOpacity = 1.0
        confirmButton.layer.shadowRadius = 0.0
        confirmButton.layer.masksToBounds = false
        confirmButton.layer.cornerRadius = 4.0
        
    }
    

    
    // MARK: - Navigation

    @IBAction func pressedConfirmButton(_ sender: UIButton) {
        print("Pressed Confitm")
    }
    
    @IBAction func pressedCancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
