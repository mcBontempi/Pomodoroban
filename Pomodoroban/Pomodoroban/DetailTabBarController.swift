//
//  DetailTabBarController.swift
//  Pomodoroban
//
//  Created by Daren taylor on 04/02/2016.
//  Copyright © 2016 LondonSwift. All rights reserved.
//

import UIKit

class DetailTabBarController: UITabBarController {

  var ticket:Ticket! {
    didSet {
      
      let navigationController = self.viewControllers![0] as! UINavigationController
      
      let  pomodoroViewController = navigationController.viewControllers[0] as! PomodoroViewController
      pomodoroViewController.ticket = ticket
      
    }
  }
}
