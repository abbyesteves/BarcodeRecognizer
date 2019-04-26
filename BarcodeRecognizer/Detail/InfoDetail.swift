//
//  InfoDetail.swift
//  BarcodeRecognizer
//
//  Created by Abby Esteves on 18/04/2019.
//  Copyright © 2019 Abby Esteves. All rights reserved.
//

import UIKit
import AVFoundation

class InfoDetail: UIViewController {
    
    let paddingValue = CGFloat(10)
    var speechSynthesizer = AVSpeechSynthesizer()
    
    //
    let infoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 0, alpha: 0.8)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("more information".capitalized, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return button
    }()
    
    let infoView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.8)
        return view
    }()
    
    let infoText : UITextView = {
        let text = UITextView()
        text.textAlignment = .center
        text.textColor = .white
        text.font = UIFont.boldSystemFont(ofSize: 18)
        text.backgroundColor = .clear
        text.isSelectable = false
        text.isEditable = false
        text.isScrollEnabled = false
        return text
    }()
    
    @objc func openSafari(){
        let search = self.infoText.text!.replacingOccurrences(of: " ", with: "+")
        UIApplication.shared.open(URL(string : "http://www.google.com/search?q=\(search)")! as URL, options: [:], completionHandler: nil)
    }
    
    func initLayout(){
        infoView.layer.cornerRadius = 15
        infoView.alpha = 0
        infoButton.alpha = 0
        
        let size = CGSize(width: view.frame.width, height: view.frame.height-(Layout().navbarStatusHeight+Layout().navBarHeight+Layout().bottomSpacing!+(view.frame.width/4)))
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let captionSize = NSString(string: infoText.text!).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 21)], context: nil)
        let height = captionSize.height < 40 ? 40 : captionSize.height+10
        // gestures
        infoButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openSafari)))
        
        // init constraints
        infoView.frame = CGRect(x: 20, y: -view.frame.height/5, width: view.frame.width-40, height: height+20)
        infoText.frame = CGRect(x: 0, y: 10, width: infoView.frame.width, height: height)
        infoButton.frame = CGRect(x: 20, y: infoView.frame.maxY+2, width:  view.frame.width-40, height: 40)
    }
    
    func open(string : String, found : Bool){
        infoText.text = string
        self.initLayout()
        if let window = UIApplication.shared.keyWindow {
            
            Layout().addToView(whereTo: window, addViews: [
                infoView,
                infoButton
            ])
            infoView.addSubview(infoText)
            
            // animate layout
             UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.infoView.alpha = 1
                if found {
                    self.infoButton.alpha = 1
                    self.infoView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                } else {
                    self.infoView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner]
                }
                self.infoView.frame = CGRect(x: self.infoView.frame.minX, y: Layout().navbarStatusHeight+self.paddingValue, width: self.infoView.frame.width, height: self.infoView.frame.height)
                self.infoButton.frame = CGRect(x: self.infoButton.frame.minX, y: self.infoView.frame.maxY+2, width:  self.infoButton.frame.width, height: self.infoButton.frame.height)
             }, completion: { (Bool) in
                self.dictate(message : string)
             })
        }
    }
    
    func dictate(message : String) {
        if self.speechSynthesizer.isSpeaking {
            self.speechSynthesizer.stopSpeaking(at: .immediate)
        }
        let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: message)
        speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.0
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        self.speechSynthesizer.speak(speechUtterance)
    }
    
    func close() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.infoView.alpha = 0
            self.infoButton.alpha = 0
            self.infoView.frame = CGRect(x: self.infoView.frame.minX, y: -self.infoView.frame.height, width: self.infoView.frame.width, height: self.infoView.frame.height)
            self.infoButton.frame = CGRect(x: self.infoButton.frame.minX, y: self.infoView.frame.maxY+2, width:  self.infoButton.frame.width, height: self.infoButton.frame.height)
        }, completion: { (Bool) in })
    }
}
