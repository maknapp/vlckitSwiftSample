//
//  ViewController.swift
//  vlckitSwiftSample
//
//  Created by Mark Knapp on 11/18/15.
//  Copyright © 2015 Mark Knapp. All rights reserved.
//

import UIKit

class ViewController: UIViewController, VLCMediaPlayerDelegate {

    var movieView: UIView!

    // Enable debugging
    //var mediaPlayer: VLCMediaPlayer = VLCMediaPlayer(options: ["-vvvv"])

    var mediaPlayer: VLCMediaPlayer = VLCMediaPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        //Add rotation observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ViewController.rotated),
            name: NSNotification.Name.UIDeviceOrientationDidChange,
            object: nil)

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

        if url == nil {
            print("Invalid URL")
            return
        }

        let media = VLCMedia(url: url!)

        // Set media options
        // https://wiki.videolan.org/VLC_command-line_help
        //media.addOptions([
        //    "network-caching": 300
        //])

        mediaPlayer.media = media

        mediaPlayer.delegate = self
        mediaPlayer.drawable = self.movieView

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc func rotated() {

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

    @objc func movieViewTapped(_ sender: UITapGestureRecognizer) {

        if mediaPlayer.isPlaying {
            mediaPlayer.pause()

            let remaining = mediaPlayer.remainingTime
            let time = mediaPlayer.time

            print("Paused at \(time?.stringValue ?? "nil") with \(remaining?.stringValue ?? "nil") time remaining")
        }
        else {
            mediaPlayer.play()
            print("Playing")
        }
        
    }


}

