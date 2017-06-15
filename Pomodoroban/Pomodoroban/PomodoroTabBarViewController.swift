//
//  PomodoroTabBarViewController.swift
//  Pomodoroban
//
//  Created by mcBontempi on 15/05/2017.
//  Copyright © 2017 LondonSwift. All rights reserved.
//

import UIKit
import HELargeCenterTabBarController

class PomodoroTabBarViewController: HELargeCenterTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async(execute: { () -> Void in
            if let unselectedImage = UIImage(named: "CenterTabBar"), let selectedImage = UIImage(named: "CenterTabBar") {
                self.addCenterButton(unselectedImage: unselectedImage, selectedImage: selectedImage)
            }
            
            self.tabBar.isTranslucent = false
            
            self.tabBar.tintColor = UIColor.white
            
            self.tabBar.barTintColor = UIColor.init(hex: 0xf9fae7)
        })
    }
}
