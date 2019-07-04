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
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var previewView: UIView!
    
    // MARK: Local Variables
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var image: UIImage?
    var frontCamera: AVCaptureDevice?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        timeAndDateLabelConfiguration()
        photoButtonImageConfiguration()
        
        homeButton.addTarget(self, action: #selector(buttonPressing), for: .touchDown)
        homeButton.addTarget(self, action: #selector(buttonPressedInside), for: .touchUpInside)
        homeButton.addTarget(self, action: #selector(buttonDraggedInside), for: .touchDragInside)
        homeButton.addTarget(self, action: #selector(buttonDraggedOutside), for: .touchDragOutside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Setup your camera
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
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
        } catch let error  {
            print("Error Unable to initialize front camera:  \(error.localizedDescription)")
        }
    }
    
    
    // MARK: AVCapturePhotoCaptureDelegate
    
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
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation()
            else { return }
        image = UIImage(data: imageData)
    }
    

    // MARK: Button Pressing Animation
    
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
    
    
    // MARK: Private Methods
    
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
    
    private func photoButtonImageConfiguration() {
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
    }
    
    
    // MARK: Actions
    
    @IBAction func pressedPhotoButton(_ sender: Any) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
        print("Photo Taken")
    }
    
    
    // MARK: Navigation
    
    @IBAction func pressedHomeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
