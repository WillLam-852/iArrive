//
//  C1_VideoRegisterViewController.swift
//  iArrive
//
//  Created by Will Lam on 14/8/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//

import UIKit
import AVFoundation

class C1_VideoRegisterViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {

    // MARK: Properties
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var imageInsidePreviewView: UIImageView!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    
    // MARK: Local Variables
    var captureSession: AVCaptureSession!
    var frontCamera: AVCaptureDevice?
    var movieOutput: AVCaptureMovieFileOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var outputURL: URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
        
        // Associate Button objects with action methods (For updating button background colors and shadows)
        startButton.addTarget(self, action: #selector(buttonPressing), for: .touchDown)
        startButton.addTarget(self, action: #selector(buttonPressedInside), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(buttonDraggedInside), for: .touchDragInside)
        startButton.addTarget(self, action: #selector(buttonDraggedOutside), for: .touchDragOutside)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Set up the camera
        setupSession()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Stop running the camera
        stopSession()
    }
    
    
    
    // MARK: Action Methods for Buttons
    // For updating button background colors and shadows
    
    @objc func buttonPressing(_ sender: AnyObject?) {
        startButtonPressing()
    }
    
    @objc func buttonPressedInside(_ sender: AnyObject?) {
        startButtonPressing()
        backButtonPressing()
    }
    
    @objc func buttonDraggedInside(_ sender: AnyObject?) {
        startButtonPressing()
    }
    
    @objc func buttonDraggedOutside(_ sender: AnyObject?) {
        startButtonUnpressing()
    }
    
    
    // MARK: AVCaptureFileOutputRecordingDelegate
    
    // For uploading video to the server
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        self.view.makeToastActivity(.center)
        API().uploadVideoAPI(videoFileURL: self.outputURL!) { (responseObject, error) in
            if error == nil {
                let videoURL = responseObject?["video_filename"].stringValue
                self.uploadToAddFace(video_url: videoURL!)
            } else {
                self.view.hideToastActivity()
                self.uploadFinished()
                let alert = UIAlertController(title: "Error", message: "Fail to upload your video, please try again later.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    
    // For uploading to add face
    private func uploadToAddFace (video_url: String) {
        let faceName = publicFunctions().ret32bitString()
        print("faceName: \(faceName ?? "No FaceName")")
        let contactInfo: Dictionary = [
            "face_name" : faceName!,
            "video_url" : video_url,
            "train" : "true"
        ]
        API().createFaceAPI(parameters: contactInfo) { (responseObject, error) in
            if error == nil {
                self.view.hideToastActivity()
                self.uploadFinished()
                let alert = UIAlertController(title: "Add Success", message: "New staff has been added successfully! Take effect after 5 minutes.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    self.pictureClick()
                }))
                self.present(alert, animated: true)
            } else {
                self.view.hideToastActivity()
                self.uploadFinished()
                let alert = UIAlertController(title: "Error", message: "Fail to create employee information", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    
    
    // MARK: Private Methods
    
    // Start Button Pressing Status
    private func startButtonPressing() {
        startButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#38C9FF").withAlphaComponent(0.5), for: .normal)
        startButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        startButton.layer.hideShadow()
    }
    
    // Start Button Unpressing Status
    private func startButtonUnpressing() {
        startButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(1), for: .normal)
        startButton.backgroundColor = UIColor.white.withAlphaComponent(1)
        startButton.layer.showShadow()
    }
    
    // Back Button Pressing Status
    private func backButtonPressing() {
        backButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(0.5), for: .normal)
        backButton.setImage(UIImage(named: "HighlightedBackArrow"), for: .normal)
    }
    
    // Back Button Unressing Status
    private func backButtonUnpressing() {
        backButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(1), for: .normal)
        backButton.setImage(UIImage(named: "Back_3"), for: .normal)
    }
    
    
    // MARK: Set up Camera
    
    // Set up the camera
    private func setupSession() {
        captureSession = AVCaptureSession()
        if captureSession.canSetSessionPreset(.hd1280x720) {
            captureSession.sessionPreset = .hd1280x720
        }
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
        let devices = deviceDiscoverySession.devices
        for device in devices {
            if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
        do {
            // Set up the input and output source for camera
            let deviceInput = try AVCaptureDeviceInput(device: frontCamera!)
            if captureSession.canAddInput(deviceInput) {
                captureSession.addInput(deviceInput)
            }
            if captureSession.canAddOutput(movieOutput) {
                captureSession.addOutput(movieOutput)
            }
            setupLivePreview()
        }
        catch let error  {
            print("Error Unable to initialize front camera:  \(error.localizedDescription)")
        }
    }
    
    // Set up Preview View Layer
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
    
    // For generating a temporary URL for saved photos
    private func tempURL() -> URL? {
        let temp = NSTemporaryDirectory()
        if temp != "" {
            let filename = String(format: "%@.mp4", UUID().uuidString)
            let path = URL(fileURLWithPath: temp).appendingPathComponent(filename)
            return path
        }
        return nil
    }
    
    // For clicking the picture
    private func pictureClick() {
        if let viewControllers = navigationController?.viewControllers[1] {
            navigationController?.popToViewController(viewControllers, animated: true)
        }
    }
    
    // For loading the view after finish uploading (successfully / unsuccessfully)
    private func uploadFinished() {
        timeLabel.isHidden = true
        timeLabel.text = "00:03"
        recordLabel.text = "Record a video"
        positionLabel.isHidden = false
        startButton.isEnabled = true
        startButtonUnpressing()
        backButtonUnpressing()
    }

    // Set up Elements
    private func setUpElements() {
        // Set up Background Color
        self.view.backgroundColor = publicFunctions().hexStringToUIColor(hex: "#F7F7F7")
        
        // Set up Time Label
        timeLabel.frame = CGRect(x: 272, y: 111, width: 225, height: 62).x_centreRatio().y_fixedToScreenRatio(false)
        timeLabel.text = "00:03"
        timeLabel.isHidden = true
        
        // Set up Camera Preview View
        previewView.frame = CGRect(x: 244, y: 201, width: 280, height: 280).fixedToScreenRatio(true)
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
        
        // Set up labels
        recordLabel.frame = CGRect(x: 300, y: 657, width: 169, height: 33).x_centreRatio().y_fixedToScreenRatio(false)
        positionLabel.frame = CGRect(x: 197, y: 698, width: 374, height: 45).x_centreRatio().y_fixedToScreenRatio(false)
        recordLabel.text = "Record a video"
        positionLabel.isHidden = false
        
        // Set up Back Button
        backButton.frame = CGRect(x: 77, y: 782, width: 117, height: 33).fixedToScreenRatio(false)
        backButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(1), for: .normal)
        backButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(0.5), for: .highlighted)
        backButton.setImage(UIImage(named: "Back_3"), for: .normal)
        backButton.setImage(UIImage(named: "HighlightedBackArrow"), for: .highlighted)
        backButton.isEnabled = true
        
        // Set up Start Button
        startButton.frame = CGRect(x: 224, y: 770, width: 320, height: 56).x_centreRatio().y_fixedToScreenRatio(false)
        startButton.layer.cornerRadius = 4.0
        startButton.layer.applySketchShadow(
            color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.16),
            x: 0,
            y: 3,
            blur: 6,
            spread: 0)
        startButton.isEnabled = true
    }
    
    
    // MARK: Navigation

    @IBAction func pressedBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressedStartButton(_ sender: UIButton) {
        if !movieOutput.isRecording {
            let connection = movieOutput.connection(with: .video)
            if connection!.isVideoOrientationSupported {
                connection?.videoOrientation = .portrait
            }
            if connection!.isVideoStabilizationSupported {
                connection?.preferredVideoStabilizationMode = .auto
            }
            outputURL = self.tempURL()
            movieOutput.startRecording(to: outputURL! as URL, recordingDelegate: self)
            timeLabel.text = "00:03"
            timeLabel.isHidden = false
            recordLabel.text = "Recording..."
            positionLabel.isHidden = true
            startButton.isEnabled = false
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { timer in
                self.timeLabel.text = "00:02"
            })
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { timer in
                self.timeLabel.text = "00:01"
            })
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { timer in
                self.timeLabel.text = "00:00"
                self.movieOutput.stopRecording()
            })
        }
    }
    
    
}
