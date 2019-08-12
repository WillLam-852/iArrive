//
//  C1_CameraRegisterViewController.swift
//  iArrive
//
//  Created by Lam Wun Yin on 27/6/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//

import UIKit
import AVFoundation
import Toast_Swift
import Alamofire
import SwiftyJSON

class C1_CameraRegisterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, AVCapturePhotoCaptureDelegate, AVCaptureFileOutputRecordingDelegate{
    
    // MARK: Properties
    @IBOutlet weak var pleaseLabel: UILabel!
    @IBOutlet weak var noOfPhotosLabel: UILabel!
    @IBOutlet weak var atLeastLabel: UILabel!
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
    var movieOutput: AVCaptureMovieFileOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var frontCamera: AVCaptureDevice?
    var imageArray = [UIImage?] ()
    var outputURL: NSURL?
    private let reuseIdentifier = "photoCell"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up Still Image Output and Movie Output
        stillImageOutput = AVCapturePhotoOutput()
        movieOutput = AVCaptureMovieFileOutput()
        
        // Set up Image Array for Photo Collection View
        for _ in 0 ..< 40 {
            imageArray.append(UIImage.init())
        }
        
        setUpElements()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        previewView.backgroundColor = .blue
        // Set up the camera
        setupSession()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Stop running the camera
        stopSession()
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
        noOfPhotosLabel.text = String(noOfPhotos)
        photoCollectionView?.reloadData()
    }
    
    
    // MARK: AVCaptureFileOutputRecordingDelegate
    
    // For uploading video to the server
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
//        API().uploadVideo(videoFileURL: self.outputURL!) { (responseObject, error) in
//            if error == nil {
//                let videoURL = responseObject?["video_filename"].stringValue
//                self.uploadToAddFace(video_url: videoURL!)
//            } else {
//                self.view.hideToastActivity()
//                self.photoButton.isEnabled = true
//                let alert = UIAlertController(title: "registerVC_error", message: "registerVC_error_message1", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
//                self.present(alert, animated: true)
//            }
//        }
    }
    
    
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
    
    // Set up the camera
    private func setupSession() {
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
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
//            if captureSession.canAddOutput(movieOutput) {
//                captureSession.addOutput(movieOutput)
//            }
            if captureSession.canAddOutput(stillImageOutput) {
                captureSession.addOutput(stillImageOutput)
            }
            setupLivePreview()
        }
        catch let error  {
            print("Error Unable to initialize front camera:  \(error.localizedDescription)")
        }
    }
    
    // Set up  Preview View Layer
    private func setupLivePreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        if videoPreviewLayer.connection!.isVideoOrientationSupported {
            videoPreviewLayer.connection?.videoOrientation = .portrait
        }
        if videoPreviewLayer.connection!.isVideoStabilizationSupported {
            videoPreviewLayer.connection?.preferredVideoStabilizationMode = .auto
        }
        self.videoPreviewLayer.frame = self.previewView.bounds
        self.previewView.layer.insertSublayer(self.videoPreviewLayer, at: 0)
        startSession()
    }
    
    // Start Running the Camera
    private func startSession() {
        if !self.captureSession.isRunning {
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.startRunning()
            }
        }
    }
    
    // Stop Running the Camera
    private func stopSession() {
        if self.captureSession.isRunning {
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.stopRunning()
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
        let rect = CGRect(x: rcy - imageWidth * 0.5, y: 0, width: imageWidth, height: imageWidth).fixedToScreenRatio(false)
        let imageRef = image.cgImage?.cropping(to: rect)
        return UIImage(cgImage: imageRef!, scale: 1.0, orientation: image.imageOrientation)
    }
    
    
    private func setUpElements() {
        // Set up labels
        pleaseLabel.frame = CGRect(x: 148, y: 37, width: 472, height: 43).x_centreRatio()
        atLeastLabel.frame = CGRect(x: 406, y: 112, width: 214, height: 33).x_centreRatio()
        noOfPhotosLabel.frame = CGRect(x: 317, y: 88, width: 81, height: 65.5).x_centreRatio()
        noOfPhotosLabel.text = "0"
        
        // Set up Camera Preview View
        previewView.frame = CGRect(x: 244, y: 168.5, width: 280, height: 280.5).fixedToScreenRatio(true)
        previewView.frame = CGRect(x: previewView.frame.minX, y: previewView.frame.minY, width: previewView.frame.height, height: previewView.frame.height)
        previewView.center.x = self.view.center.x
        previewView.layer.borderWidth = 1.0
        previewView.layer.masksToBounds = false
        previewView.layer.borderColor = UIColor.white.cgColor
        previewView.layer.cornerRadius = previewView.frame.height / 2
        previewView.clipsToBounds = true
        
        // Set up Image Inside Preview View
        imageInsidePreviewView.frame = CGRect(x: 0, y: 0, width: previewView.bounds.width, height: previewView.bounds.height)
        previewView.insertSubview(imageInsidePreviewView, at: 1)
        
        // Set up Photo Collection View
        photoCollectionView?.frame = CGRect(x: 32, y: 485, width: 704, height: 400).fixedToScreenRatio(true)
        
        // Set up Back Button
        backButton.frame = CGRect(x: 77, y: 946, width: 117, height: 33).fixedToScreenRatio(false)
        backButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(1), for: .normal)
        backButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(0.5), for: .highlighted)
        backButton.setImage(UIImage(named: "Back_3"), for: .normal)
        backButton.setImage(UIImage(named: "HighlightedBackArrow"), for: .highlighted)
        
        // Set up Photo Button
        photoButton.frame = CGRect(x: 328, y: 908, width: 112, height: 111).x_centreRatio().y_fixedToScreenRatio(false)
        
        // Set up Confirm Button
        confirmButton.frame = CGRect(x: 562, y: 945, width: 186, height: 35).fixedToScreenRatio(false)
        confirmButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(0.5), for: .normal)
        confirmButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(0.5), for: .highlighted)
        confirmButton.setImage(UIImage(named: "Confirm"), for: .normal)
        confirmButton.setImage(UIImage(named: "HighlightedConfirmArrow"), for: .highlighted)
        confirmButton.isEnabled = false
    }
    
    // For generating a temporary URL for saved photos
//    private func tempURL() -> NSURL? {
//        let temp = NSTemporaryDirectory()
//        if temp != "" {
//            let uuid = UUID().uuidString
//            let filename = String(format: "%@.mp4", uuid)
//            let path = URL(fileURLWithPath: temp).appendingPathComponent(filename)
//            return path as NSURL?
//        }
//        return nil
//    }
    
    // For uploading to add face
//    func uploadToAddFace (video_url: String) {
//        let faceName = publicFunctions().ret32bitString()
//        print("faceName: ", faceName!)
//        let contactInfo: Parameters = [
//            "face_name" : faceName!,
//            "video_url" : video_url,
//            "train" : "true"
//        ]
//        API().createFace(parameters: contactInfo) { (responseObject, error) in
//            if error == nil {
//                self.view.hideToastActivity()
//                self.photoButton.isEnabled = true
//                let alert = UIAlertController(title: "registerVC_add_success_title", message: "registerVC_add_success_content", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//                    self.pictureClick()
//                }))
//                self.present(alert, animated: true)
//            } else {
//                self.view.hideToastActivity()
//                self.photoButton.isEnabled = true
//                let alert = UIAlertController(title: "registerVC_error", message: "registerVC_error_message2", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
//                self.present(alert, animated: true)
//            }
//        }
//    }

    
//    private func pictureClick() {
//        if let viewControllers = navigationController?.viewControllers[1] {
//            navigationController?.popToViewController(viewControllers, animated: true)
//        }
//    }
    

    
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
            let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
            stillImageOutput.capturePhoto(with: settings, delegate: self)
//            let connection = movieOutput.connection(with: .video)
//            if connection!.isVideoOrientationSupported {
//                connection?.videoOrientation = .portrait
//            }
//            outputURL = self.tempURL()
//            movieOutput.startRecording(to: outputURL! as URL, recordingDelegate: self)
//            self.view.makeToastActivity(.center)
//            self.photoButton.isEnabled = false
////            self.photoButton.setTitle(NSLocalizedString("photoVC_recording_3", comment: ""), for: .normal)
//            print("3")
//            Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { timer in
////                self.photoButton.setTitle(NSLocalizedString("photoVC_recording_2", comment: ""), for: .normal)
//                print("2")
//            })
//            Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { timer in
////                self.photoButton.setTitle(NSLocalizedString("photoVC_recording_1", comment: ""), for: .normal)
//                print("1")
//            })
//            Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { timer in
////                self.photoButton.setTitle(NSLocalizedString("photoVC_recording_0", comment: ""), for: .normal)
//                print("0")
//                self.movieOutput.stopRecording()
////                self.photoButton.isEnabled = true
//            })
            noOfPhotosLabel.text = String(noOfPhotos)
            if noOfPhotos >= 19 && !confirmButton.isEnabled {
                confirmButton.isEnabled = true
                confirmButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(1), for: .normal)
            }
        }
    }
    
    
    
    // MARK: - Navigation
    
    // Back to Register Page when user presses Back Button
    @IBAction func pressedBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // Back to Sign In Page when user presses Confirm Button (with staff member information stored)
    @IBAction func pressedConfirmButton(_ sender: UIButton) {
        staffNameList.append(staffMember(firstName: currentRegisteringFirstName!, lastName: currentRegisteringLastName!, jobTitle: currentRegisteringJobTitle!, isCheckedIn: false))
        currentRegisteringFirstName = nil
        currentRegisteringLastName = nil
        currentRegisteringJobTitle = nil
        self.view.window?.hideAllToasts()
        self.view.window?.makeToast("Register Successfully", duration: 5.0, point: toast_postion, title: nil, image: nil, style: publicFunctions().toastStyleSetUp(), completion: nil)
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: {})
    }
    
}
