//
//  InfoDetail.swift
//  BarcodeRecognizer
//
//  Created by Abby Esteves on 18/04/2019.
//  Copyright © 2019 Abby Esteves. All rights reserved.
//

import UIKit

class InfoDetail: UIViewController {
    let paddingValue = CGFloat(10)
    
    //
    let infoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 0, alpha: 0.8)
        button.titleLabel?.font = .systemFont(ofSize: 18)
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
    
    let infoLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 5
        return label
    }()
    
    @objc func openSafari(){
        let search = self.infoLabel.text!.replacingOccurrences(of: " ", with: "+")
        UIApplication.shared.open(URL(string : "http://www.google.com/search?q=\(search)")! as URL, options: [:], completionHandler: nil)
    }
    
    func initLayout(){
        infoView.layer.cornerRadius = 15
        infoView.alpha = 0
        infoButton.alpha = 0
        
        // gestures
        infoButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openSafari)))
        
        
        // init constraints
        infoView.frame = CGRect(x: 20, y: -view.frame.height/5, width: view.frame.width-40, height: view.frame.height/5)
        infoLabel.frame = CGRect(x: 0, y: 0, width: infoView.frame.width, height: infoView.frame.height)
        infoButton.frame = CGRect(x: 20, y: infoView.frame.maxY+2, width:  view.frame.width-40, height: 50)
    }
    
    func open(string : String, found : Bool){
        self.initLayout()
        infoLabel.text = string
        if let window = UIApplication.shared.keyWindow {
            
            Layouts().addToView(whereTo: window, addViews: [
                infoView,
                infoButton
            ])
            infoView.addSubview(infoLabel)
            
            // animate layout
             UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.infoView.alpha = 1
                if found {
                    self.infoButton.alpha = 1
                    self.infoView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                } else {
                    self.infoView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner]
                }
                self.infoView.frame = CGRect(x: self.infoView.frame.minX, y: Layouts().navbarStatusHeight+self.paddingValue, width: self.infoView.frame.width, height: self.infoView.frame.height)
                self.infoLabel.frame = CGRect(x: 0, y: 0, width: self.infoView.frame.width, height: self.infoView.frame.height)
                self.infoButton.frame = CGRect(x: self.infoButton.frame.minX, y: self.infoView.frame.maxY+2, width:  self.infoButton.frame.width, height: self.infoButton.frame.height)
             }, completion: { (Bool) in })
        }
    }
    
    func close() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.infoView.alpha = 0
            self.infoButton.alpha = 0
            self.infoView.frame = CGRect(x: self.infoView.frame.minX, y: -self.infoView.frame.height, width: self.infoView.frame.width, height: self.infoView.frame.height)
            self.infoLabel.frame = CGRect(x: 0, y: 0, width: self.infoView.frame.width, height: self.infoView.frame.height)
            self.infoButton.frame = CGRect(x: self.infoButton.frame.minX, y: self.infoView.frame.maxY+2, width:  self.infoButton.frame.width, height: self.infoButton.frame.height)
        }, completion: { (Bool) in })
    }
}
