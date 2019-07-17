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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a transparent circle view with shadow outside the circle
        createOverlay(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        // Set up Time and Date Label
        timeAndDateLabelConfiguration()
        
        // Set up Home Button
        homeButton.setTitleColor(UIColor.white.withAlphaComponent(1.0), for: .normal)
        homeButton.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
        homeButton.setImage(UIImage(named: "HomeArrow"), for: .normal)
        homeButton.setImage(UIImage(named: "HighlightedHomeArrow"), for: .highlighted)
        view.bringSubviewToFront(homeButton)
        
        // Associate Double-tap gesture with action methods (For capturing image and Go to Photo Detected Page)
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
//        self.view.window?.hideToastActivity()
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
//        self.view.window?.makeToastActivity(.center)
        AutoQuitCheckInOutCameraView?.cancel()
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
        currentCheckingInOutDate = dateLabel.text ?? ""
        currentCheckingInOutTime = timeLabel.text ?? ""
        // Wait for 0.2 second for the image being captured
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200), execute: {
            self.performSegue(withIdentifier: "SignInOutCameratoPhotoDetectedSegue", sender: self)
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
        self.view.insertSubview(overlayView, at: 1)
        let maskLayer = CAShapeLayer()
        // Create a path with the rectangle in it.
        let path = CGMutablePath()
        path.addArc(center: CGPoint(x: overlayView.frame.width/2, y: overlayView.frame.height/2), radius: overlayView.frame.width*9/20, startAngle: 0, endAngle: .pi * 2, clockwise: false)
        path.addRect(CGRect(x: 0, y: 0, width: overlayView.frame.width, height: overlayView.frame.height))
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
    

    
    // MARK: Navigation
    
    // Back to Sign In Page when user presses Home Button
    @IBAction func pressedHomeButton(_ sender: Any) {
        AutoQuitCheckInOutCameraView?.cancel()
        dismiss(animated: true, completion: nil)
    }
    
}
