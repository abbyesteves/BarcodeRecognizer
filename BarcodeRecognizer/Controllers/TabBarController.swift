//
//  TabBarController.swift
//  BarcodeRecognizer
//
//  Created by Abby Esteves on 26/04/2019.
//  Copyright © 2019 Abby Esteves. All rights reserved.
//

import UIKit
class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    func setupView() {
        
        let text = ScannerLauncher()
        text.tabBarItem = UITabBarItem(title: "text".capitalized, image: UIImage(named: "ic_text"), selectedImage: UIImage(named: "ic_text_filled"))
        
        let general = ScannerLauncher()
        general.tabBarItem = UITabBarItem(title: "general".capitalized, image: UIImage(named: "ic_general"), selectedImage: UIImage(named: "ic_general_filled"))
        
        let find = ScannerLauncher()
        find.tabBarItem = UITabBarItem(title: "find".capitalized, image: UIImage(named: "ic_find"), selectedImage: UIImage(named: "ic_find_filled"))
        
        let help = HelpController()
        help.navigationItem.title = "Help"
        help.tabBarItem = UITabBarItem(title: "help".capitalized, image: UIImage(named: "ic_setting"), selectedImage: UIImage(named: "ic_setting_filled"))
        
        self.viewControllers = [text, general, find, help]
        tabBar.tintColor = UIColor.white
        tabBar.unselectedItemTintColor = UIColor.white
        tabBar.barTintColor = UIColor.Theme(alpha: 1.0)
        self.selectedIndex = 1
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == "Help" {
            self.navigationItem.title = "Help"
        } else {
            self.navigationItem.title = ""
        }
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        self.navigationController?.isToolbarHidden = true
        
        setupView()
    }
}
