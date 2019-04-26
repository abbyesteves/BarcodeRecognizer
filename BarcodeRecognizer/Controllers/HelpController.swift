//
//  HelpController.swift
//  BarcodeRecognizer
//
//  Created by Abby Esteves on 25/04/2019.
//  Copyright © 2019 Abby Esteves. All rights reserved.
//

import UIKit

class HelpController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, UICollectionViewDataSource {
    let minimumHeight = CGFloat(50)
    let helpId = "helpId"
    let helpHeader = "helpHeader"
    let helpView = Layout().collectionView(spacing: 0.5, scrollDirection : .vertical)
    
    let options : [Helps] = {
        var under1_1 = Labels()
        under1_1.title = "Read Tutorials"
//        under1_1.icons = ""
        var under1_2 = Labels()
        under1_2.title = "Give Feedback"
        var under1_3 = Labels()
        under1_3.title = "Request a Call"
        var option1 = Helps(header : "help", under : [under1_1, under1_2, under1_3])
        
        var under2_1 = Labels()
        under2_1.title = "Offline Text Recognition"
        under2_1.subTitle = "Faster recognition option for languages based on Latin scripts."
        var under2_2 = Labels()
        under2_2.title = "Automatic Language Detection"
        under2_2.subTitle = "When turned off, Envision will read all text in the phone's system language only."
        var under2_3 = Labels()
        under2_3.title = "Speech"
        var under2_4 = Labels()
        under2_4.title = "Color Detection"
        var option2 = Helps(header : "settings", under : [under2_1, under2_2, under2_3, under2_4])
        
        var under3_1 = Labels()
        under3_1.title = "Account Details"
        under3_1.subTitle = "email address here"
        var under3_2 = Labels()
        under3_2.title = "Check Subscriptions"
        under3_2.subTitle = "status of subsription"
        var option3 = Helps(header : "account", under : [under3_1, under3_2])
        
        var under4_1 = Labels()
        under4_1.title = "Share with Friends"
        var under4_2 = Labels()
        under4_2.title = "Write a review on AppStore"
        var option4 = Helps(header : "Spread the word", under : [under4_1, under4_2])
        
        var under5_1 = Labels()
        under5_1.title = "About Envision"
        var option5 = Helps(header : "", under : [under5_1])
        
        return [option1, option2, option3, option4, option5]
    }()
    
    func setupView() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
        //
        helpView.delegate = self
        helpView.dataSource = self
        helpView.showsVerticalScrollIndicator = true
        helpView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        helpView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: helpId)
        helpView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: helpHeader)
        
        view.addSubview(helpView)
        //
        helpView.frame = CGRect(x: 0, y: Layout().navBarHeight+Layout().navbarStatusHeight, width: view.frame.width, height: view.frame.height-(Layout().bottomSpacing!+Layout().navBarHeight+Layout().navbarStatusHeight))
    }
    
    func setupCells(cell : UICollectionViewCell, indexPath : IndexPath){
        cell.backgroundColor = .white
        //
        let title = self.options[indexPath.section].under[indexPath.item].title
        let subTitle = self.options[indexPath.section].under[indexPath.item].subTitle
        let header = self.options[indexPath.section].header
        //
        let titleLabel : UILabel = {
            let label = UILabel()
            label.text = title
            label.font = .systemFont(ofSize: 15, weight: UIFont.Weight(rawValue: 0))
            label.numberOfLines = 2
            return label
        }()
        
        let subTitleLabel : UILabel = {
            let label = UILabel()
            label.text = subTitle
            label.font = .systemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 0))
            label.numberOfLines = 2
            label.textColor = UIColor.lightGray
            return label
        }()
        
        let iconImageView : UIImageView = {
            let imageView = UIImageView()
            imageView.backgroundColor = UIColor(white: 0, alpha: 0.8)
            imageView.layer.cornerRadius = 8
            return imageView
        }()
        
        let arrowImageView : UIImageView = {
            let imageView = UIImageView()
            imageView.backgroundColor = .clear
            imageView.image = UIImage(named: "ic_arrow_right")?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = UIColor.lightGray
            return imageView
        }()
        
        let switchButton : UISwitch = {
            let button = UISwitch()
            return button
        }()
        // add to cell
        Layout().addToView(whereTo: cell, addViews: [
            iconImageView,
            titleLabel,
            arrowImageView
        ])
        
        // constraints
        iconImageView.frame = CGRect(x: 10, y: (cell.frame.height/2)-((minimumHeight-20)/2), width: minimumHeight-20, height: minimumHeight-20)
        titleLabel.frame = CGRect(x: iconImageView.frame.maxX+10, y: 10, width: cell.frame.width-(10+iconImageView.frame.width+40+(cell.frame.height/3)), height: cell.frame.height-20)
        arrowImageView.frame = CGRect(x: cell.frame.width-((cell.frame.height/3)+10), y: (cell.frame.height/2)-((cell.frame.height/3)/2), width: cell.frame.height/3, height: cell.frame.height/3)
        
        // for other layouts with switches and subtitles
        if subTitle != nil && header ==  self.options[1].header {
            arrowImageView.removeFromSuperview()
            cell.addSubview(switchButton)
            titleLabel.frame = CGRect(x: titleLabel.frame.minX, y: titleLabel.frame.minY, width: titleLabel.frame.width-20, height: titleLabel.frame.height)
            switchButton.frame = CGRect(x: titleLabel.frame.maxX+10, y: (cell.frame.height/2)-(switchButton.frame.height/2), width: 0, height: switchButton.frame.height)
        }
        if subTitle != nil {
            cell.addSubview(subTitleLabel)
            
            titleLabel.frame = CGRect(x: titleLabel.frame.minX, y: titleLabel.frame.minY, width: titleLabel.frame.width, height: 20)
            subTitleLabel.frame = CGRect(x: titleLabel.frame.minX, y: titleLabel.frame.maxY, width: titleLabel.frame.width, height: cell.frame.height-(titleLabel.frame.height+20))
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.options[section].under.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: helpId, for: indexPath)
        self.setupCells(cell : cell, indexPath : indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let subTitle = self.options[indexPath.section].under[indexPath.item].subTitle
        let header = self.options[indexPath.section].header
        if subTitle != nil && header ==  self.options[1].header {
            return CGSize(width: view.frame.width, height: self.minimumHeight+25)
        }
        if subTitle != nil {
            return CGSize(width: view.frame.width, height: self.minimumHeight+5)
        }
        
        return CGSize(width: view.frame.width, height: self.minimumHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.helpView.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: helpHeader, for: indexPath)
        //
        for view in headerView.subviews {
            view.removeFromSuperview()
        }
        let headerLabel : UILabel = {
            let label = UILabel()
            label.text = self.options[indexPath.section].header?.capitalized
            label.font = .systemFont(ofSize: 14, weight: UIFont.Weight(rawValue: 1))
            label.numberOfLines = 2
            label.textColor = .white
            return label
        }()
        headerView.addSubview(headerLabel)
        headerLabel.frame = CGRect(x: 10, y: 10, width: headerView.frame.width-20, height: headerView.frame.height-10)
        return headerView
    }
    
    override func viewDidLoad() {
        setupView()
    }
}
