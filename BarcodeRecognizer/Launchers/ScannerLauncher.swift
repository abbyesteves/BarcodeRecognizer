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
    var holdCode = String()
    
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
    @objc func restart() {
        self.captureSession.startRunning()
    }
    
    @objc func barScanTapped(sender : UITapGestureRecognizer) {
        let button = sender.view as! UIButton
        if self.isOn {
            self.isOn = false
            self.infoDetail.close()
            self.holdCode = String()
            button.backgroundColor = UIColor(white: 0, alpha: 0.8)
            
        } else {
            self.isOn = true
            button.backgroundColor = UIColor.rgba(red: 206, green: 73, blue: 73, alpha: 0.8)
        }
    }
    
    // private funcs / funcs
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
        view.addSubview(barScanButton)
        barScanButton.addSubview(barScanImageView)
        barScanButton.addSubview(barScanLabel)
        //
        view.gestureRecognizers?.removeAll()
        //
        self.setupConstraints()
        self.setupGestures()
        // start
        self.captureSession.startRunning()
    }
    
    func setupConstraints() {
        let buttonSize = view.frame.width/4
        previewLayer.frame = view.layer.bounds
        barScanButton.frame = CGRect(x: (view.frame.width/2)-(buttonSize/2), y: view.frame.height-(buttonSize+20), width: buttonSize, height: buttonSize)
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
            holdCode = code
            // GET barcode data frfom api
            Service().LookupBarcode(barcode : code, completion: {
                (data) in
                if data != nil {
                    do {
                        let jsonRes = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject?
                        if jsonRes!["success"] != nil {
                            let bool = (jsonRes!["success"])! as! Bool
                            if bool {
                                let products = jsonRes!["products"] as! [[String:Any]]
                                if let product = products.first {
                                    let name = product["product_name"] as! String
                                    DispatchQueue.main.async(execute: {
                                        self.infoDetail.open(string: name, found : true)
                                    })
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
        
//        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(restart)))
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
        } else {
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

