//
//  Extension.swift
//  BarcodeRecognizer
//
//  Created by Abby Esteves on 21/04/2019.
//  Copyright © 2019 Abby Esteves. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgba(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
    static func Theme(alpha: CGFloat) -> UIColor {
        return UIColor(red: 0/255, green: 103/255, blue: 102/255, alpha: alpha)
    }
}
