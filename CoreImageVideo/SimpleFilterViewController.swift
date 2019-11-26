//
//  ViewController.swift
//  CoreImageVideo
//
//  Created by Chris Eidhof on 03/04/15.
//  Copyright (c) 2015 objc.io. All rights reserved.
//

import UIKit
import AVFoundation

class SimpleFilterViewController: UIViewController {
    var source: CaptureBufferSource?
    var coreImageView: CoreImageView?

    var angleForCurrentTime: Float {
        return Float(Date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: Double.pi * 2))
    }

    override func loadView() {
        coreImageView = CoreImageView(frame: CGRect.zero)
        self.view = coreImageView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupCameraSource()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        source?.running = false
    }
    
    func setupCameraSource() {
        source = CaptureBufferSource(position: AVCaptureDevice.Position.front) { [weak self] (buffer, transform) in
            guard let strongSelf = self else {
                return
            }
            let input = CIImage(buffer: buffer).transformed(by: transform)
            let filter = hueAdjust(angleInRadians: strongSelf.angleForCurrentTime)
            strongSelf.coreImageView?.image = filter(input)
        }
        source?.running = true
    }
}

