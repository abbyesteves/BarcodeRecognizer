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
    
    lazy var infoDetail: InfoDetail = {
        let launcher = InfoDetail()
        return launcher
    }()
    
    // @objc funcs
    @objc func restart() {
        self.captureSession.startRunning()
        self.infoDetail.close()
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
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        //
        view.gestureRecognizers?.removeAll()
        // start
        self.captureSession.startRunning()
    }
    
    func failed(){
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    func found(code : String){
        print(" found code : ", code)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(restart)))
        // GET barcode data frfom api
        Service().LookupBarcode(barcode : code, completion: {
            (data) in
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
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            self.found(code: stringValue)
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

