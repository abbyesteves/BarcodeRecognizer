//
//  tabBarController.swift
//  BarcodeRecognizer
//
//  Created by Abby Esteves on 26/04/2019.
//  Copyright © 2019 Abby Esteves. All rights reserved.
//

import Foundation
class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    func setupView() {
        let personal = ProfilePersonal()
        personal.tabBarItem = UITabBarItem(title: "personal".capitalized, image: UIImage(named: ""), selectedImage: UIImage(named: ""))
        
        let company = ProfileCompany()
        company.tabBarItem = UITabBarItem(title: "company".capitalized, image: UIImage(named: ""), selectedImage: UIImage(named: ""))
        
        let others = ProfileOthers()
        others.tabBarItem = UITabBarItem(title: "others".capitalized, image: UIImage(named: ""), selectedImage: UIImage(named: ""))
        
        let accounts = ProfileAccounts()
        accounts.tabBarItem = UITabBarItem(title: "accounts".capitalized, image: UIImage(named: ""), selectedImage: UIImage(named: ""))
        
        self.viewControllers = [personal, company, others, accounts]
        tabBar.tintColor = UIColor.Theme(alpha: 1.0)
        //        self.selectedIndex = 2
    }
    func setupNavigationBar(){
        let menu = UIBarButtonItem(title: "menu", style: .plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItems = [menu]
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.Background(alpha: 1.0)
        self.navigationController?.isToolbarHidden = true
        
        setupView()
        //        setupNavigationBar()
    }
}
