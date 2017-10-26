//
//  PostsViewController.swift
//  Pomodoroban
//
//  Created by mcBontempi on 09/05/2017.
//  Copyright © 2017 LondonSwift. All rights reserved.
//

import UIKit

class PostsViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIWebView.loadRequest(self.webView)(URLRequest(url: URL(string: "http://www.pomodoroban.com")!))
        
        
        self.navigationController?.redWithLogo()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
