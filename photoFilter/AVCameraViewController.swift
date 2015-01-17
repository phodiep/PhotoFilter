//
//  AVCameraViewController.swift
//  photoFilter
//
//  Created by Pho Diep on 1/17/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit
import AVFoundation

class AVCameraViewController: UIViewController {
    
    var delegate: ImageSelectedProtocol?

    let captureSession = AVCaptureSession()
    var captureDevice: AVCaptureDevice?
    
    var stillImageOutput: AVCaptureStillImageOutput?
    
    
    
    override func loadView() {
        let rootView = UIView(frame: UIScreen.mainScreen().bounds)
        rootView.backgroundColor = UIColor.blackColor()
        
        let captureButton = UIButton()
        captureButton.setTitle(
            NSLocalizedString("Take Picture", comment: "aciton sheet Photo button"),
            forState: .Normal)
        captureButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        captureButton.addTarget(self, action: "captureCameraAVSession", forControlEvents: .TouchUpInside)

        captureButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        rootView.addSubview(captureButton)
        
        let views = ["captureButton" : captureButton]
        
        rootView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[captureButton]-8-|",
            options: nil, metrics: nil, views: views))
        
        rootView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-[captureButton]-|",
            options: nil, metrics: nil, views: views))


        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("Camera", comment: "Gallery View title")

        captureSession.sessionPreset = AVCaptureSessionPresetLow
        let devices = AVCaptureDevice.devices() // array of all devices available
        
        
        for device in devices {
            if device.hasMediaType(AVMediaTypeVideo) && device.position == AVCaptureDevicePosition.Back {
                // set back camera as captureDevice
                captureDevice = device as? AVCaptureDevice
            }
        }
        
        if captureDevice != nil {
            self.startCamera()
        }

    }
    
    
    func startCamera() {
        self.captureSession.addInput(AVCaptureDeviceInput(device: captureDevice, error: nil))
        var previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.view.layer.addSublayer(previewLayer)
        previewLayer?.frame = self.view.layer.frame
        self.captureSession.startRunning()
        
        
    }



    func captureCameraAVSession() {
        println("This function doesn't work")
        
//        self.stillImageOutput = AVCaptureStillImageOutput()
//        var videoConnection: AVCaptureConnection?
//        
//        for connection in self.stillImageOutput!.connections {
//            for port in connection.inputPorts! {
//                if port.mediaType == AVMediaTypeVideo {
//                    videoConnection = connection as? AVCaptureConnection
//                    break
//                }
//            }
//            if videoConnection != nil {
//                break
//            }
//        }
//     
//        self.stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: { (imageSampleBuffer, error) -> Void in
//            
//            if error == nil {
//                println("error with camera")
//            } else if imageSampleBuffer != nil {
//                var imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageSampleBuffer!) as NSData
//                var image = UIImage(data: imageData) as UIImage!
//                self.delegate?.controllerDidSelectImage(image)
//                self.navigationController?.popViewControllerAnimated(true)
//            }
//        })
    }

    
    
}
