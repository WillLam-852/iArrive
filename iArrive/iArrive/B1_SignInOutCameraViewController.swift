//
//  B1_SignInOutCameraViewController.swift
//  iArrive
//
//  Created by Will Lam on 4/7/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//

import UIKit
import AVFoundation

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        // Set up Time and Date Label
        timeAndDateLabelConfiguration()
        
        // Associate Home Button object with action methods (For updating Login button and Show Password button states)
        homeButton.addTarget(self, action: #selector(buttonPressing), for: .touchDown)
        homeButton.addTarget(self, action: #selector(buttonPressedInside), for: .touchUpInside)
        homeButton.addTarget(self, action: #selector(buttonDraggedInside), for: .touchDragInside)
        homeButton.addTarget(self, action: #selector(buttonDraggedOutside), for: .touchDragOutside)
        
        // Associate Double-tap gesture with action methods (For capturing image and Go to Photo Detected Page)
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    }
    
    
    // Stop running the camera
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    
    
    // MARK: Action Methods for Buttons
    
    // For updating button background colors and shadows
    @objc func buttonPressing(_ sender: AnyObject?) {
        homeButton.setTitleColor(UIColor.white.withAlphaComponent(0.1), for: .normal)
    }
    
    @objc func buttonPressedInside(_ sender: AnyObject?) {
        homeButton.setTitleColor(UIColor.white.withAlphaComponent(1.0), for: .normal)
    }
    
    @objc func buttonDraggedInside(_ sender: AnyObject?) {
        homeButton.setTitleColor(UIColor.white.withAlphaComponent(0.1), for: .normal)
    }
    
    @objc func buttonDraggedOutside(_ sender: AnyObject?) {
        homeButton.setTitleColor(UIColor.white.withAlphaComponent(1.0), for: .normal)
    }
    
    
    // For capturing image and Go to Photo Detected Page when user double-tap the screen
    // Auto-detection when deployment
    @objc func doubleTapped() {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
        currentCheckingInOutDate = dateLabel.text ?? ""
        currentCheckingInOutTime = timeLabel.text ?? ""
        // Wait for 0.5 second for the image being captured
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200), execute: {
            self.performSegue(withIdentifier: "SignInOutCameratoPhotoDetectedSegue", sender: self)
        })
    }
    
    
    
    // MARK: AVCapturePhotoCaptureDelegate
    
    // Set up the Preview View Layer
    func setupLivePreview() {
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
    
    // Store the captured photo
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation()
            else { return }
        currentCheckingInOutPhoto = UIImage(data: imageData)
    }
    
    
    
    // MARK: Private Methods
    
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
    

    
    // MARK: Navigation
    
    // Back to Sign In Page when user presses Home Button
    @IBAction func pressedHomeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
