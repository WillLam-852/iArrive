//
//  C1_CameraRegisterViewController.swift
//  iArrive
//
//  Created by Lam Wun Yin on 27/6/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//

import UIKit

class C1_CameraRegisterViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var noOfPhotosLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    
    // MARK: Local variables
    var noOfPhotos = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        noOfPhotosLabel.text = String(noOfPhotos)
        
        confirmButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(0.5), for: .normal)
        confirmButton.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        confirmButton.isEnabled = false
    }
    

    // MARK: Actions
    
    @IBAction func takePhotoButton(_ sender: UIButton) {
        if noOfPhotos >= 40 {
            let alert = UIAlertController(title: "Exceed Photo Number Limit", message: "Please press Confirm button to finish registration", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
            noOfPhotos += 1
            noOfPhotosLabel.text = String(noOfPhotos)
            if noOfPhotos >= 20 && !confirmButton.isEnabled {
                confirmButton.isEnabled = true
                confirmButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(1), for: .normal)
            }
        }
    }
    
    
    // MARK: - Navigation
    @IBAction func pressedBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressedConfirmButton(_ sender: UIButton) {
        print("Pressed Confirm")
    }
    
}
