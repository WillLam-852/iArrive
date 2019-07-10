//
//  C1_CameraRegisterViewController.swift
//  iArrive
//
//  Created by Lam Wun Yin on 27/6/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//

import UIKit
import AVFoundation

class C1_CameraRegisterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, AVCapturePhotoCaptureDelegate, AVCaptureFileOutputRecordingDelegate{
    

    // MARK: Properties
    @IBOutlet weak var noOfPhotosLabel: UILabel!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var imageInsidePreviewView: UIImageView!
    @IBOutlet weak var photoCollectionView: UICollectionView?
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!

    
    // MARK: Local variables
    var noOfPhotos = 0
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var movieOutput: AVCaptureFileOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var frontCamera: AVCaptureDevice?
    var imageArray = [UIImage?] ()
    var photoSaved = false
    var outputURL: NSURL?
    private let reuseIdentifier = "photoCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up Image Array for Photo Collection View
        for _ in 0 ..< 40 {
            imageArray.append(UIImage.init())
        }
        
        // Set up Number Of Photos Label
        noOfPhotosLabel.text = "0"
        
        // Set up Camera Preview View
        previewView.layer.borderWidth = 1.0
        previewView.layer.masksToBounds = false
        previewView.layer.borderColor = UIColor.white.cgColor
        previewView.layer.cornerRadius = previewView.frame.height / 2
        previewView.clipsToBounds = true
        
        // Set up Image Inside Preview View
        previewView.insertSubview(imageInsidePreviewView, at: 1)
        
        // Set up Confirm Button
        confirmButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(0.5), for: .normal)
        confirmButton.isEnabled = false
        
        // Associate Button objects with action methods (For updating button background colors and shadows)
        confirmButton.addTarget(self, action: #selector(buttonPressing), for: .touchDown)
        confirmButton.addTarget(self, action: #selector(buttonPressedInside), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(buttonDraggedInside), for: .touchDragInside)
        confirmButton.addTarget(self, action: #selector(buttonDraggedOutside), for: .touchDragOutside)
        backButton.addTarget(self, action: #selector(buttonPressing), for: .touchDown)
        backButton.addTarget(self, action: #selector(buttonPressedInside), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(buttonDraggedInside), for: .touchDragInside)
        backButton.addTarget(self, action: #selector(buttonDraggedOutside), for: .touchDragOutside)
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Set up the camera
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
            // Set up the input and output source for camera
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

    
    // Stop running the camera
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }

    
    
    // MARK: Action Methods for Buttons
    
    // For updating button background colors and shadows
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
    
    
    
    // MARK: AVCapturePhotoCaptureDelegate

    // Store the captured photo in the Photo Collection View
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation()
            else { return }
        var image = UIImage(cgImage: (UIImage(data: imageData)?.cgImage)!, scale: 1.0, orientation: .leftMirrored)
        image = self.cropImageToSquare(image)
        for i in stride(from: 39, through: 1, by: -1) {
            imageArray[i] = imageArray[i-1]
        }
        imageArray[0] = image
        noOfPhotos += 1
        photoSaved = true
        noOfPhotosLabel.text = String(noOfPhotos)
        photoCollectionView?.reloadData()
//        outputURL = self.tempURL()
//        movieOutput.startRecording(to: outputURL! as URL, recordingDelegate: self)
//        self.photoButton.isEnabled = false
//        self.photoButton.setTitle(NSLocalizedString("photoVC_recording_3", comment: ""), for: .normal)
//        _ = Timer(timeInterval: 1, repeats: false, block: {timer in print("CHECK")})        // To Be Tested
//        self.photoButton.setTitle(NSLocalizedString("photoVC_recording_2", comment: ""), for: .normal)
//        _ = Timer(timeInterval: 1, repeats: false, block: {timer in print("CHECK")})        // To Be Tested
//        self.photoButton.setTitle(NSLocalizedString("photoVC_recording_1", comment: ""), for: .normal)
//        _ = Timer(timeInterval: 1, repeats: false, block: {timer in print("CHECK")})        // To Be Tested
//        self.photoButton.setTitle(NSLocalizedString("photoVC_recording_0", comment: ""), for: .normal)
//        movieOutput.stopRecording()
    }
    
    
    
    // MARK: AVCaptureFileOutputRecordingDelegate

    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {

    }
    
    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [[API sharedAPI] uploadVideo:self.outputURL success:^(NSDictionary *responseObject) {
//    NSString *videoURL = responseObject[@"video_filename"];
//    [self uploadToAddFace:videoURL];
//    } failure:^(NSError *error) {
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    [UsefulTools showAlertwithTitle:CustomLocalisedString(@"registerVC_error", @"") withContent:CustomLocalisedString(@"registerVC_error_message1", @"") viewController:self withComplection:^(UIAlertAction * _Nonnull action) {
//    }];
//    }];
    
    
    
    
    // MARK: UICollectionViewDelegate
    
    // Set up the number of collection view cells in the photoCollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }

    // Set up each collection view cell in the photoCollectionView
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "photoCell"
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? photoCollectionViewCell else {
            fatalError("The dequeued cell is not an instance of selectStaffTableViewCell.")
        }
        cell.captureImageView.image = imageArray[indexPath.item]
        cell.backgroundColor = publicFunctions().hexStringToUIColor(hex: "#E9F0F5")
        cell.layer.borderColor = publicFunctions().hexStringToUIColor(hex: "#91D6F0").cgColor
        if indexPath.item >= noOfPhotos {
            cell.layer.borderWidth = 2
        } else {
            cell.layer.borderWidth = 0
        }
        return cell
    }
    
    // Set up the action when user tap the collection view cell in the photoCollectionView (Can be deleted when deployment)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    
    
    // MARK: Private Methods
    
    // Set up the Preview View Layer
    private func setupLivePreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        if videoPreviewLayer.connection!.isVideoOrientationSupported {
            videoPreviewLayer.connection?.videoOrientation = .portrait
        }
        if videoPreviewLayer.connection!.isVideoStabilizationSupported {
            videoPreviewLayer.connection?.preferredVideoStabilizationMode = .auto
        }
        previewView.layer.addSublayer(videoPreviewLayer)
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.previewView.bounds
                self.previewView.layer.insertSublayer(self.videoPreviewLayer, at: 0)
            }
        }
    }
    
    // For Cropping the output image into square
    private func cropImageToSquare(_ image: UIImage) -> UIImage {
        let orientation: UIDeviceOrientation = UIDevice.current.orientation
        var imageWidth = image.size.width
        var imageHeight = image.size.height
        switch orientation {
        case .landscapeLeft, .landscapeRight:
            // Swap width and height if orientation is landscape
            imageWidth = image.size.height
            imageHeight = image.size.width
        default:
            break
        }
        
        // The center coordinate along Y axis
        let rcy = imageHeight * 0.5
        let rect = CGRect(x: rcy - imageWidth * 0.5, y: 0, width: imageWidth, height: imageWidth)
        let imageRef = image.cgImage?.cropping(to: rect)
        return UIImage(cgImage: imageRef!, scale: 1.0, orientation: image.imageOrientation)
    }
    

    
    // MARK: Actions
    
    // For capturing image when user presses the Photo button (and update Confirm button state)
    @IBAction func takePhotoButton(_ sender: UIButton) {
        if noOfPhotos >= 40 {
            let alert = UIAlertController(title: "Exceed Photo Number Limit", message: """
            Please press Confirm button
            to finish registration
            """, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
//            if !movieOutput.isRecording {
            let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
            stillImageOutput.capturePhoto(with: settings, delegate: self)
            noOfPhotosLabel.text = String(noOfPhotos)
            if noOfPhotos >= 19 && !confirmButton.isEnabled {
                confirmButton.isEnabled = true
                confirmButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(1), for: .normal)
            }
//            }
        }
    }
    
    
    
    // MARK: - Navigation
    
    // Back to Register Page when user presses Back Button
    @IBAction func pressedBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // Back to Sign In Page when user presses Confirm Button (with staff member information stored)
    @IBAction func pressedConfirmButton(_ sender: UIButton) {
//        self.view.showToast(toastMessage: "Register successfully", duration: 2.0)
        print("Register successfully")
        staffNameList.append(staffMember(firstName: currentRegisteringFirstName!, lastName: currentRegisteringLastName!, jobTitle: currentRegisteringJobTitle!, isCheckedIn: false))
        currentRegisteringFirstName = nil
        currentRegisteringLastName = nil
        currentRegisteringJobTitle = nil
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: {})
    }
    

//    func tempURL() -> NSURL? {
//        let temp = NSTemporaryDirectory()
//        if temp != "" {
//            let uuid = UUID().uuidString
//            let filename = String(format: "%@.mp4", uuid)
//            let path = URL(fileURLWithPath: temp).appendingPathComponent(filename)
//            return path as NSURL?
//        }
//        return nil
//    }
    
}
