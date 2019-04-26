//
//  ScannerLauncher.swift
//  BarcodeRecognizer
//
//  Created by Abby Esteves on 18/04/2019.
//  Copyright © 2019 Abby Esteves. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerLauncher: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var isOn = false
    var isDetectObjectOn = false
    var holdCode = String()
    var audioPlayer = AVAudioPlayer()
    
    lazy var infoDetail: InfoDetail = {
        let launcher = InfoDetail()
        return launcher
    }()
    
    let barScanButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 0, alpha: 0.8)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("".capitalized, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        return button
    }()
    
    let barScanImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_barcode")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.white
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let barScanLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textAlignment = .center
        label.text = "scan barcode"
        return label
    }()
    
    // @objc funcs
    @objc func barScanTapped(sender : UITapGestureRecognizer) {
        let button = sender.view as! UIButton
        self.isOn = setButtons(isOn: self.isOn, button: button)
    }
    
    @objc func objectDetectTapped(sender : UITapGestureRecognizer) {
        let button = sender.view as! UIButton
        self.isDetectObjectOn = setButtons(isOn: self.isDetectObjectOn, button: button)
    }
    
    // private funcs / funcs
    func setButtons(isOn : Bool, button : UIButton) -> Bool {
        var returnIsOn = isOn
        if isOn {
            returnIsOn = false
            self.infoDetail.close()
            self.holdCode = String()
            self.soundEffects(fileName : "se_ButtonOff", loop : false)
            button.backgroundColor = UIColor(white: 0, alpha: 0.8)
        } else {
            returnIsOn = true
            self.soundEffects(fileName : "se_ButtonOn", loop : false)
            button.backgroundColor = UIColor.rgba(red: 206, green: 73, blue: 73, alpha: 0.8)
        }
        return returnIsOn
    }
    
    func soundEffects(fileName : String, loop : Bool) {
        guard let sound = Bundle.main.path(forResource: fileName, ofType: "mp3") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
            if loop {
                audioPlayer.numberOfLoops = -1
            } else {
                audioPlayer.numberOfLoops = 0
            }
            if audioPlayer.isPlaying {
                audioPlayer.stop()
            } else {
                audioPlayer.play()
            }
        } catch {
            print(" error get bundle ", error)
        }
    }
    
    func setup(){
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            self.failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            // types of codes to look for
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
        } else {
            self.failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
//        view.addSubview(barScanButton)
//        barScanButton.addSubview(barScanImageView)
//        barScanButton.addSubview(barScanLabel)
        //
        
        self.setupConstraints()
        self.setupButtons()
//        self.setupGestures()
        // start
        self.captureSession.startRunning()
    }
    
    func setupButtons() {
        let buttons = ["detect", "scan barcode"]
        let icons = ["ic_object","ic_barcode"]
        let selectors = [#selector(objectDetectTapped), #selector(barScanTapped)]
        let buttonSize = view.frame.width/4
        let total = (buttonSize+5)*CGFloat(buttons.count)
        var x = CGFloat(view.frame.width/2)-CGFloat(total/2)

        for (index, button) in buttons.enumerated() {
            let barButton: UIButton = {
                let button = UIButton()
                button.backgroundColor = UIColor(white: 0, alpha: 0.8)
                button.titleLabel?.font = .systemFont(ofSize: 18)
                button.setTitleColor(UIColor.white, for: .normal)
                button.setTitle("".capitalized, for: .normal)
                button.layer.cornerRadius = 15
                button.layer.borderColor = UIColor.white.cgColor
                button.layer.borderWidth = 2
                return button
            }()

            let iconImageView : UIImageView = {
                let imageView = UIImageView()
                imageView.image = UIImage(named: icons[index])?.withRenderingMode(.alwaysTemplate)
                imageView.tintColor = UIColor.white
                imageView.contentMode = .scaleAspectFill
                return imageView
            }()

            let titleLabel : UILabel = {
                let label = UILabel()
                label.textColor = .white
                label.font = UIFont.boldSystemFont(ofSize: 10)
                label.textAlignment = .center
                label.text = button
                return label
            }()

            view.addSubview(barButton)
            barButton.addSubview(iconImageView)
            barButton.addSubview(titleLabel)

            barButton.frame = CGRect(x: x, y: view.frame.height-(buttonSize+20+Layout().bottomSpacing!+Layout().tabBarHeight), width: buttonSize, height: buttonSize)
            iconImageView.frame = CGRect(x: barButton.frame.width/4, y: (barButton.frame.height/4)-10, width: barButton.frame.width/2, height: barButton.frame.height/2)
            titleLabel.frame = CGRect(x: 0, y: iconImageView.frame.maxY, width: barButton.frame.width, height: 20)

            x = barButton.frame.maxX+5
            barButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: selectors[index]))
        }
    }
    
    func setupConstraints() {
        let buttonSize = view.frame.width/4
        previewLayer.frame = view.layer.bounds
        barScanButton.frame = CGRect(x: (view.frame.width/2)-(buttonSize/2), y: view.frame.height-(buttonSize+20+Layout().bottomSpacing!), width: buttonSize, height: buttonSize)
        barScanImageView.frame = CGRect(x: barScanButton.frame.width/4, y: (barScanButton.frame.height/4)-10, width: barScanButton.frame.width/2, height: barScanButton.frame.height/2)
        barScanLabel.frame = CGRect(x: 0, y: barScanImageView.frame.maxY, width: barScanButton.frame.width, height: 20)
    }
    
    func setupGestures() {
        barScanButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(barScanTapped)))
    }
    
    func failed(){
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    func found(code : String){
        if holdCode != code {
            print(" found code : ", code)
            self.soundEffects(fileName : "se_Beep", loop : true)
            holdCode = code
            // GET barcode data frfom api
            Service().LookupBarcode(barcode : code, completion: {
                (data) in
                if data != nil {
                    do {
                        let jsonRes = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject?
                        if jsonRes!["success"] != nil {
                            let bool = (jsonRes!["success"])! as! Bool
                            self.soundEffects(fileName : "se_Bell", loop : false)
                            if bool {
                                if jsonRes!["products"] is [[String:Any]] {
                                    let products = jsonRes!["products"] as? [[String:Any]]
                                    if let product = products?.first {
                                        self.getName(product : product)
                                    }
                                } else {
                                    let product = jsonRes!["products"] as? [String:Any]
                                    self.getName(product : product)
                                }
                            } else {
                                let message = (jsonRes!["message"])! as! String
                                DispatchQueue.main.async(execute: {
                                    self.infoDetail.open(string: message, found : false)
                                })
                            }
                        }
                    } catch {
                        self.failedToGet()
                    }
                } else {
                    self.failedToGet()
                }
// *transfer all json to MODEL object instead
//            do {
//                let model = try JSONDecoder().decode(Product.self, from: data!)
//                print(" into model form ", model.products)
//            } catch let err{
//                print(" into model form err : ",err.localizedDescription)
//            }
            })
        }
    }
    
    func getName(product : [String:Any]?){
        let name = product?["product_name"] as? String
        let string = name != nil ? name : "No name"
        DispatchQueue.main.async(execute: {
            self.infoDetail.open(string: string!, found : true)
        })
    }
    
    func failedToGet(){
        let massages = ["Cannot Retrieve Data", "Check you connectivity", "Something went wrong", "Are you offline?", "Make sure you are connected"]
        let index = Int(arc4random_uniform(UInt32(massages.count)))
        DispatchQueue.main.async(execute: {
            self.infoDetail.open(string: massages[index], found : false)
        })
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if isOn {
//            captureSession.stopRunning()
            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue = readableObject.stringValue else { return }
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                self.found(code: stringValue)
            }
        }
    }
    
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        // object Detection
//        if isDetectObjectOn {
//            guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
//            guard let model = try? VNCoreMLModel(for: Resnet50().model) else { print(" sampleBufferERROR model "); return }
//            //        print(" camera was able to capture a frame : ", pixelBuffer, model)
//            let request = VNCoreMLRequest(model: model)
//            { (finishRequest, error) in
//                //            print(" finishRequest ",finishRequest.results)
//                guard let results = finishRequest.results as? [VNClassificationObservation] else { return }
//                guard let firstObservation = results.first else { return }
////                DispatchQueue.main.async(execute: {
////                    print(" firstObservation : \(firstObservation.identifier)")
////                })
//                print(" finishRequest : ",firstObservation.identifier, firstObservation.confidence)
//            }
//            try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
            self.infoDetail.close()
            self.holdCode = String()
        }
        else {
            self.captureSession.startRunning()
            self.infoDetail.close()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
}

