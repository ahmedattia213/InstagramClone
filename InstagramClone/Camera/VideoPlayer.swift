//
//  VideoPlayer.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 5/16/20.
//  Copyright © 2020 Ahmed Amr. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayer: UIView {
    
    let avPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!
    var videoURL: URL! {
        didSet {
            avPlayerLayer = AVPlayerLayer(player: avPlayer)
            avPlayerLayer.frame = frame
            avPlayerLayer.videoGravity = .resizeAspectFill
            self.layer.insertSublayer(avPlayerLayer, at: 0)
            self.layoutIfNeeded()
            let playerItem = AVPlayerItem(url: videoURL as URL)
            avPlayer.replaceCurrentItem(with: playerItem)
            setupAVPlayerObservers()
        }
    }

    private func setupAVPlayerObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handlePlayAgain), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func handlePlayAgain() {
        self.avPlayer.seek(to: CMTime.zero)
        play()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    func play() {
        avPlayer.play()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
