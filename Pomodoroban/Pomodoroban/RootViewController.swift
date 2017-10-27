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
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var feedView: UIView!

    var timerVC: TimerViewController!
    
    /*
    - (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
    {
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"alertview_embed"]) {
    AlertViewController * childViewController = (AlertViewController *) [segue destinationViewController];
    AlertView * alertView = childViewController.view;
    // do something with the AlertView's subviews here...
    }
    }
    */
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "timer" {
            self.timerVC = segue.destination as! TimerViewController
            
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loginView.alpha = 1.0
        self.feedView.alpha = 0.0
        self.timerView.alpha = 0.0
        
        
        self.feedView.isUserInteractionEnabled = false
        self.timerView.isUserInteractionEnabled = false
        self.loginView.isUserInteractionEnabled = true
    }

    func gotoLogin() {
        UIView.animate(withDuration: 0.3) {
            self.feedView.alpha = 0.0
            self.loginView.alpha = 1.0
        }
        
        self.feedView.isUserInteractionEnabled = false
        self.loginView.isUserInteractionEnabled = true
    }
    
    func gotoTimer() -> TimerViewController{
        UIView.animate(withDuration: 0.3) {
             self.timerView.alpha = 1.0
        }
        self.timerView.isUserInteractionEnabled = false
        
        return self.timerVC
    }
    
    
    
    func gotoFeed() {
        UIView.animate(withDuration: 0.3) {
            self.feedView.alpha = 1.0
            self.loginView.alpha = 0.0
        }
        
        self.feedView.isUserInteractionEnabled = true
        self.loginView.isUserInteractionEnabled = false
    }
}
