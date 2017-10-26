//
//  RootViewController.swift
//  Calchua
//
//  Created by mcBontempi on 26/10/2017.
//  Copyright © 2017 LondonSwift. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    @IBOutlet weak var loginView: UIView!
    
    @IBOutlet weak var feedView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loginView.alpha = 1.0
        self.feedView.alpha = 0.0
    }

    func gotoLogin() {
        UIView.animate(withDuration: 2.0) {
            self.feedView.alpha = 0.0
            self.loginView.alpha = 1.0
        }
    }
    
    func gotoFeed() {
        UIView.animate(withDuration: 2.0) {
            self.feedView.alpha = 1.0
            self.loginView.alpha = 0.0
        }
    }
}
