//
//  VideoPlayerView.swift
//  StartzPlay
//
//  Created by Marim Hassan on 15/07/2021.
//

import UIKit
import AVKit

class VideoPlayerView: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .moviePlayback)
        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        
    }
    

    @IBAction func playVideoTap(_ sender: UIButton) {
       
        guard let url = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4") else {
            return
        }
       
        let player = AVPlayer(url: url)
        let controller = AVPlayerViewController()
        controller.player = player
        present(controller, animated: true) {
            player.play()
        }
        
    }
    
    
    @IBAction func backBtnTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    

}
