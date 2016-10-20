//
//  SignupViewController.swift
//  Pomodoroban
//
//  Created by Daren David Taylor on 18/10/2016.
//  Copyright © 2016 LondonSwift. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    func createFirebaseAccount(email:String, password:String) {
        
        FIRAuth.auth()!.createUserWithEmail(email,password:password) { user, error in
            if error == nil {
                
             //   UIAlertController.quickMessage("Firebase account created", vc: self.window!.rootViewController!)
                
                FIRAuth.auth()!.signInWithEmail(email, password: password, completion: { (user, error) in
                    
               //     UIAlertController.quickMessage("Firebase signed in", vc: self.window!.rootViewController!)
                })
            }
            else {
             //   UIAlertController.quickMessage("Error creating account", vc: self.window!.rootViewController!)
                
            }
        }
    }


}
