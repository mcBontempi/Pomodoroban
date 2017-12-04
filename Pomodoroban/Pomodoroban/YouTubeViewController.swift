//
//  YouTubeViewController.swift
//  Calchua
//
//  Created by mcBontempi on 04/12/2017.
//  Copyright © 2017 LondonSwift. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class YouTubeViewController: UIViewController {

    var videoID:String!
    
    @IBOutlet weak var ytPlayerView: YTPlayerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.myOrientation = .landscape
      self.videoID = "https://www.youtube.com/watch?v="
        self.ytPlayerView.load(withVideoId: "EepyueGHq4I")
        self.ytPlayerView.delegate = self
      
    }
}

extension YouTubeViewController : YTPlayerViewDelegate {
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        print(state)
    }
    
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        self.ytPlayerView.playVideo()
    }
    
}
