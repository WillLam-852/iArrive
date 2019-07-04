//
//  C1_CameraRegisterViewController.swift
//  iArrive
//
//  Created by Lam Wun Yin on 27/6/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//

import UIKit
import AVFoundation

class C1_CameraRegisterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, AVCapturePhotoCaptureDelegate{

    // MARK: Properties
    @IBOutlet weak var photoCollectionView: UICollectionView?
    @IBOutlet weak var noOfPhotosLabel: UILabel!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var previewView: UIView!

    
    // MARK: Local variables
    var noOfPhotos = 0
    var frontCamera: AVCaptureDevice?
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var imageArray = [UIImage?] ()
    var photoSaved = false
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
        noOfPhotosLabel.text = "0"
        
        confirmButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(0.5), for: .normal)
        confirmButton.isEnabled = false
        
        confirmButton.addTarget(self, action: #selector(buttonPressing), for: .touchDown)
        confirmButton.addTarget(self, action: #selector(buttonPressedInside), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(buttonDraggedInside), for: .touchDragInside)
        confirmButton.addTarget(self, action: #selector(buttonDraggedOutside), for: .touchDragOutside)
        backButton.addTarget(self, action: #selector(buttonPressing), for: .touchDown)
        backButton.addTarget(self, action: #selector(buttonPressedInside), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(buttonDraggedInside), for: .touchDragInside)
        backButton.addTarget(self, action: #selector(buttonDraggedOutside), for: .touchDragOutside)
        
        for _ in 0 ..< 40 {
            imageArray.append(UIImage.init())
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Setup your camera
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
        let devices = deviceDiscoverySession.devices
        for device in devices {
            if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
        do {
            let input = try AVCaptureDeviceInput(device: frontCamera!)
            stillImageOutput = AVCapturePhotoOutput()
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        }
        catch let error  {
            print("Error Unable to initialize front camera:  \(error.localizedDescription)")
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }

    
    // MARK: AVCapturePhotoCaptureDelegate
    
    func setupLivePreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)

        videoPreviewLayer.videoGravity = .resizeAspect
        videoPreviewLayer.connection?.videoOrientation = .portrait
        previewView.layer.addSublayer(videoPreviewLayer)

        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.previewView.bounds
            }
        }
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {

        guard let imageData = photo.fileDataRepresentation()
            else { return }

        for i in stride(from: 39, through: 1, by: -1) {
            imageArray[i] = imageArray[i-1]
        }
        imageArray[0] = UIImage(data: imageData)
        noOfPhotos += 1
        photoSaved = true
        noOfPhotosLabel.text = String(noOfPhotos)
        photoCollectionView?.reloadData()
    }

    
    // MARK: Button Pressing Animation
    
    @objc func buttonPressing(_ sender: AnyObject?) {
        if sender === confirmButton {
            confirmButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(0.5), for: .normal)
        } else {
            backButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(0.5), for: .normal)
        }
    }
    
    @objc func buttonPressedInside(_ sender: AnyObject?) {
        if sender === confirmButton {
            confirmButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(1), for: .normal)
        } else {
            backButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(1), for: .normal)
        }
    }
    
    @objc func buttonDraggedInside(_ sender: AnyObject?) {
        if sender === confirmButton {
            confirmButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(0.5), for: .normal)
        } else {
            backButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(0.5), for: .normal)
        }
    }
    
    @objc func buttonDraggedOutside(_ sender: AnyObject?) {
        if sender === confirmButton {
            confirmButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(1), for: .normal)
        } else {
            backButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(1), for: .normal)
        }
    }
    
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "photoCell"
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? photoCollectionViewCell else {
            fatalError("The dequeued cell is not an instance of selectStaffTableViewCell.")
        }
        cell.captureImageView.image = imageArray[indexPath.item]
        if cell.captureImageView == nil {
            cell.backgroundColor = publicFunctions().hexStringToUIColor(hex: "#E9F0F5")
            cell.layer.borderColor = publicFunctions().hexStringToUIColor(hex: "#91D6F0").cgColor
            cell.layer.borderWidth = 2
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    

    // MARK: Actions
    
    @IBAction func takePhotoButton(_ sender: UIButton) {
        if noOfPhotos >= 40 {
            let alert = UIAlertController(title: "Exceed Photo Number Limit", message: """
            Please press Confirm button
            to finish registration
            """, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
            let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
            stillImageOutput.capturePhoto(with: settings, delegate: self)
            noOfPhotosLabel.text = String(noOfPhotos)
            if noOfPhotos >= 19 && !confirmButton.isEnabled {
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
//        self.view.showToast(toastMessage: "Register successfully", duration: 2.0)
        print("Register successfully")
        staffNameList.append(staffMember(firstName: currentRegisteringFirstName, lastName: currentRegisteringLastName, jobTitle: currentRegisteringJobTitle, isCheckedIn: false))
        currentRegisteringFirstName = ""
        currentRegisteringLastName = ""
        currentRegisteringJobTitle = ""
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: {})
    }
    
}
