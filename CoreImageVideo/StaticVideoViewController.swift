//
//  StaticVideoViewController.swift
//  CoreImageVideo
//
//  Created by Chris Eidhof on 03/04/15.
//  Copyright (c) 2015 objc.io. All rights reserved.
//

import UIKit
import AVFoundation

class StaticVideoViewController: UIViewController {
    var coreImageView: CoreImageView?
    var videoSource: VideoSampleBufferSource?
    
    var angleForCurrentTime: Float {
        return Float(Date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: Double.pi * 2))
    }
    
    override func loadView() {
        coreImageView = CoreImageView(frame: CGRect.zero)
        self.view = coreImageView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let url = Bundle.main.url(forResource: "Cat", withExtension: "mp4")!
        videoSource = VideoSampleBufferSource(url: url) { [weak self] buffer in
            guard let strongSelf = self else {
                return
            }
            let image = CIImage(cvPixelBuffer: buffer)
            let background = kaleidoscope()(image)
            let mask = radialGradient(center: image.extent.center, radius: CGFloat(strongSelf.angleForCurrentTime) * 100)
            let output = blendWithMask(background: image, mask: mask)(background)
            strongSelf.coreImageView?.image = output
        }
    }    
}
