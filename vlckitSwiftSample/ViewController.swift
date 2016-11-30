//
//  ViewController.swift
//  vlckitSwiftSample
//
//  Created by Mark Knapp on 11/18/15.
//  Copyright © 2015 Mark Knapp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var movieView: UIView!
    var mediaPlayer = VLCMediaPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        //Add rotation observer
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)

        //Setup movieView
        self.movieView = UIView()
        self.movieView.backgroundColor = UIColor.gray
        self.movieView.frame = UIScreen.screens[0].bounds

        //Add tap gesture to movieView for play/pause
        let gesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.movieViewTapped(_:)))
        self.movieView.addGestureRecognizer(gesture)

        //Add movieView to view controller
        self.view.addSubview(self.movieView)
    }

    override func viewDidAppear(_ animated: Bool) {

        //Playing multicast UDP (you can multicast a video from VLC)
        //let url = NSURL(string: "udp://@225.0.0.1:51018")

        //Playing HTTP from internet
        //let url = NSURL(string: "http://streams.videolan.org/streams/mp4/Mr_MrsSmith-h264_aac.mp4")

        //Playing RTSP from internet
        let url = URL(string: "rtsp://184.72.239.149/vod/mp4:BigBuckBunny_115k.mov")


        let media = VLCMedia(URL: url)
        mediaPlayer.setMedia(media)


        mediaPlayer.setDelegate(self)
        mediaPlayer.drawable = self.movieView

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func rotated() {

        let orientation = UIDevice.current.orientation

        if (UIDeviceOrientationIsLandscape(orientation)) {
            print("Switched to landscape")
        }
        else if(UIDeviceOrientationIsPortrait(orientation)) {
            print("Switched to portrait")
        }

        //Always fill entire screen
        self.movieView.frame = self.view.frame

    }

    func movieViewTapped(_ sender: UITapGestureRecognizer) {

        if mediaPlayer.isPlaying() {
            mediaPlayer.pause()

            let remaining = mediaPlayer.remainingTime
            let time = mediaPlayer.time()

            print("Paused at \(time) with \(remaining) time remaining")
        }
        else {
            mediaPlayer.play()
            print("Playing")
        }
        
    }


}

