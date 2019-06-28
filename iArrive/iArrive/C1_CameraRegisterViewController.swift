//
//  C1_CameraRegisterViewController.swift
//  iArrive
//
//  Created by Lam Wun Yin on 27/6/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//

import UIKit

class C1_CameraRegisterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: Properties
    @IBOutlet weak var photoCollectionView: UICollectionView?
    @IBOutlet weak var noOfPhotosLabel: UILabel!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    
    // MARK: Local variables
    var noOfPhotos = 0
    private let reuseIdentifier = "photoCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bottomImage = UIImage(named: "Ellipse")
        let topImage = UIImage(named: "CameraIcon")
        
        let size = CGSize(width: 70, height: 70)
        UIGraphicsBeginImageContext(size)
        
        let bottomAreaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        bottomImage!.draw(in: bottomAreaSize)
        
        let topAreaSize = CGRect(x: 20, y: 17, width: size.width - 40, height: size.height - 40)
        topImage!.draw(in: topAreaSize, blendMode: .normal, alpha: 1.0)
        
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        photoButton.setImage(newImage, for: .init())
        
        
        noOfPhotosLabel.text = String(noOfPhotos)
        
        
        
        confirmButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(0.5), for: .normal)
        confirmButton.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        confirmButton.isEnabled = false
    }
    
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item <= noOfPhotos {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! photoCollectionViewCell
            cell.backgroundColor = .blue
            cell.layer.borderWidth = 0
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! photoCollectionViewCell
            cell.backgroundColor = publicFunctions().hexStringToUIColor(hex: "#E9F0F5")
            cell.layer.borderColor = publicFunctions().hexStringToUIColor(hex: "#91D6F0").cgColor
            cell.layer.borderWidth = 2
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row+1)
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
            photoCollectionView?.reloadData()
        }
    }
    
    
    // MARK: - Navigation
    @IBAction func pressedBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressedConfirmButton(_ sender: UIButton) {
//        self.view.showToast(toastMessage: "Register success", duration: 2.0)
        staffNameList.append(staffMember(firstName: currentRegisteringFirstName, lastName: currentRegisteringLastName, jobTitle: currentRegisteringJobTitle))
        currentRegisteringFirstName = ""
        currentRegisteringLastName = ""
        currentRegisteringJobTitle = ""
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: {})
    }
    
}
