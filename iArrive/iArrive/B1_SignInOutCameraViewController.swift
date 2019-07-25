//
//  B1_SignInOutCameraViewController.swift
//  iArrive
//
//  Created by Will Lam on 4/7/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//

import UIKit
import AVFoundation
import Toast_Swift
import CoreImage

class B1_SignInOutCameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    // MARK: Properties
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    // MARK: Local Variables
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var frontCamera: AVCaptureDevice?
    var AutoQuitCheckInOutCameraView: DispatchWorkItem?
    var imageView: UIImageView!
    var blurEffectView: UIVisualEffectView!
    var loadingView: UIView!
    var tap: UITapGestureRecognizer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up imageView and blurEffectView
        imageView = UIImageView(frame: self.view.bounds)
        let blurEffect = UIBlurEffect(style: .regular)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.transform = CGAffineTransform(scaleX: -1, y: 1)
        imageView.center = self.view.center
        blurEffectView.alpha = 0.9
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.insertSubview(imageView, at: 3)
        self.view.insertSubview(blurEffectView, at: 4)
        
        // Set up loading view
        loadingView = UIView()
        
        // Create a transparent circle view with shadow outside the circle
        createOverlay(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height).fixedToScreenRatio())
        
        // Set up Time and Date Label
        timeAndDateLabelConfiguration()
        
        // Set up Home Button
        homeButton.setTitleColor(UIColor.white.withAlphaComponent(1.0), for: .normal)
        homeButton.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
        homeButton.setImage(UIImage(named: "HomeArrow"), for: .normal)
        homeButton.setImage(UIImage(named: "HighlightedHomeArrow"), for: .highlighted)
        view.bringSubviewToFront(homeButton)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        returnFromLoadingViewToCameraView()
        
        // Set up the camera
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
        let devices = deviceDiscoverySession.devices
        for device in devices {
            // Choose front camera
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
        } catch let error  {
            print("Error Unable to initialize front camera:  \(error.localizedDescription)")
        }
        AutoQuitCheckInOutCameraView = DispatchWorkItem(block: {
            self.dismiss(animated: true, completion: nil)
        })
        // Back to Sign In / Out Camera Page when user has no actions for 20 seconds with Check In / Out status updated
        DispatchQueue.main.asyncAfter(deadline: .now() + 30, execute: AutoQuitCheckInOutCameraView!)
    }
    
    
    // Stop running the camera
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let inputs = captureSession!.inputs
        for oldInput:AVCaptureInput in inputs {
            captureSession?.removeInput(oldInput)
        }
        self.captureSession.stopRunning()
    }
    
    
    
    // For capturing image and Go to Photo Detected Page when user double-tap the screen
    // Auto-detection when deployment
    @objc func doubleTapped() {
        AutoQuitCheckInOutCameraView?.cancel()
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
        currentCheckingInOutDate = dateLabel.text ?? ""
        currentCheckingInOutTime = timeLabel.text ?? ""
        // Wait for 0.2 second for the image being captured
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200), execute: {
            self.view.removeGestureRecognizer(self.tap)
            self.loadingView = usefulTools().animatedLoadingView()
            self.view.addSubview(self.loadingView)
            self.homeButton.isHidden = true
            self.timeLabel.isHidden = true
            self.dateLabel.isHidden = true
            self.showBlurredImageBackground()
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2000), execute: {
            let isFaceDetected = self.detect(detectImage: currentCheckingInOutPhoto!)
            self.loadingView.removeFromSuperview()
            self.returnFromLoadingViewToCameraView()
            if isFaceDetected {
                self.performSegue(withIdentifier: "SignInOutCameratoPhotoDetectedSegue", sender: self)
            }
        })
    }
    
    
    
    // MARK: AVCapturePhotoCaptureDelegate
    
    // Store the captured photo
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation()
            else { return }
        currentCheckingInOutPhoto = UIImage(data: imageData)
    }
    
    
    
    // MARK: Private Methods
    
    // Create a transparent circle view with shadow outside the circle
    private func createOverlay(frame : CGRect) {
        let overlayView = UIView(frame: frame)
        overlayView.alpha = 0.45
        overlayView.backgroundColor = UIColor.black
        self.view.insertSubview(overlayView, at: 2)
        let maskLayer = CAShapeLayer()
        // Create a path with the rectangle in it.
        let path = CGMutablePath()
        path.addArc(center: CGPoint(x: overlayView.frame.width/2, y: overlayView.frame.height/2), radius: overlayView.frame.width*9/20, startAngle: 0, endAngle: .pi * 2, clockwise: false)
        path.addRect(CGRect(x: 0, y: 0, width: overlayView.frame.width, height: overlayView.frame.height).fixedToScreenRatio())
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.path = path;
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        // Release the path since it's not covered by ARC.
        overlayView.layer.mask = maskLayer
        overlayView.clipsToBounds = true
    }
    
    // Set up the current time and date label with correct format
    private func timeAndDateLabelConfiguration() {
        let hour = Calendar.current.component(.hour, from: Date())
        let minute = Calendar.current.component(.minute, from: Date())
        let year = Calendar.current.component(.year, from: Date())
        let month = Calendar.current.component(.month, from: Date())
        let day = Calendar.current.component(.day, from: Date())
        timeLabel.text = ""
        if hour / 10 == 0 {
            timeLabel.text = timeLabel.text! + "0"
        }
        timeLabel.text = timeLabel.text! + String(hour) + ":"
        if minute / 10 == 0 {
            timeLabel.text = timeLabel.text! + "0"
        }
        timeLabel.text = timeLabel.text! + String(minute)
        
        dateLabel.text = String(year) + "-"
        if month / 10 == 0 {
            dateLabel.text = dateLabel.text! + "0"
        }
        dateLabel.text = dateLabel.text! + String(month) + "-"
        if day / 10 == 0 {
            dateLabel.text = dateLabel.text! + "0"
        }
        dateLabel.text = dateLabel.text! + String(day)
        
        self.view.bringSubviewToFront(timeLabel)
        self.view.bringSubviewToFront(dateLabel)
    }
    
    // Set up the Preview View Layer
    private func setupLivePreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        videoPreviewLayer.frame = self.view.frame
        self.view.layer.insertSublayer(videoPreviewLayer, at: 0)
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.previewView.bounds
            }
        }
    }
    
    // Set up Blurred Image Background
    private func showBlurredImageBackground() {
        imageView.image = currentCheckingInOutPhoto
        imageView.isHidden = false
        blurEffectView.isHidden = false
    }
    
    private func returnFromLoadingViewToCameraView() {
        // Hide imageView and blurEffectView
        imageView.isHidden = true
        blurEffectView.isHidden = true
        
        // Show Home Button, Time and Date
        homeButton.isHidden = false
        timeLabel.isHidden = false
        dateLabel.isHidden = false
        
        // Associate Double-tap gesture with action methods (For capturing image and Go to Photo Detected Page)
        tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
    }
    

    
    // MARK: Navigation
    
    // Back to Sign In Page when user presses Home Button
    @IBAction func pressedHomeButton(_ sender: Any) {
        AutoQuitCheckInOutCameraView?.cancel()
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    // To Be Deleted
    
    func detect(detectImage: UIImage) -> Bool {
        
        guard let personciImage = CIImage(image: detectImage) else {
            return false
        }
        
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector?.features(in: personciImage)
        
        if let face = faces?.first as? CIFaceFeature {
            
            print("Found bounds are \(face.bounds)")
            
            
            let length: CGFloat
            if face.bounds.height > face.bounds.width {
                length = face.bounds.height
            } else {
                length = face.bounds.width
            }
            
            let ciImageSize = personciImage.extent.size
            var transform = CGAffineTransform(scaleX: 1, y: -1)
            transform = transform.translatedBy(x: 0, y: -ciImageSize.height)
            
            var faceViewBounds = face.bounds.applying(transform)
            let viewSize = self.view.bounds
            let scale = min(viewSize.width / ciImageSize.width,
                            viewSize.height / ciImageSize.height)
            let offsetX = (viewSize.width - ciImageSize.width * scale) / 2
            let offsetY = (viewSize.height - ciImageSize.height * scale) / 2
            
            faceViewBounds = faceViewBounds.applying(CGAffineTransform(scaleX: scale, y: scale))
            faceViewBounds.origin.x += 260
            faceViewBounds.origin.y += 180
            faceViewBounds = CGRect(x: faceViewBounds.origin.x, y: faceViewBounds.origin.y, width: length*1.2, height: length*1.2).fixedToScreenRatio()
            
            print("faceViewBounds: ", faceViewBounds)
            
            let faceBox_faceViewBounds = UIView(frame: faceViewBounds)
            faceBox_faceViewBounds.layer.borderWidth = 3
            faceBox_faceViewBounds.layer.borderColor = UIColor.red.cgColor
            faceBox_faceViewBounds.backgroundColor = UIColor.clear
//            self.view.window?.addSubview(faceBox_faceViewBounds)
            
            if face.hasSmile {
                print("face is smiling")
            }
            
            if face.hasLeftEyePosition {
                print("Left eye bounds are \(face.leftEyePosition)")
            }
            
            if face.hasRightEyePosition {
                print("Right eye bounds are \(face.rightEyePosition)")
            }
            return true
        } else {
            let alert = UIAlertController(title: "No Face!", message: "No face was detected", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
    }
}
