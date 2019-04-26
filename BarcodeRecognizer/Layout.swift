//
//  Layout.swift
//  BarcodeRecognizer
//
//  Created by Abby Esteves on 18/04/2019.
//  Copyright © 2019 Abby Esteves. All rights reserved.
//

import UIKit

class Layout {
    let navbarStatusHeight = UIApplication.shared.statusBarFrame.height
    let bottomSpacing = UIApplication.shared.keyWindow?.safeAreaInsets.bottom
    let navBarHeight = UINavigationController.init().navigationBar.frame.height
    let tabBarHeight = UITabBarController.init().tabBar.frame.height
    
    func addToView(whereTo: Optional<UIView>, addViews : [Optional<UIView>]) {
        for addView in addViews {
            whereTo!.addSubview(addView!)
        }
    }
    
    func collectionView(spacing: CGFloat, scrollDirection : UICollectionView.ScrollDirection) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = scrollDirection
        layout.minimumLineSpacing = spacing
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        return cv
    }
}
