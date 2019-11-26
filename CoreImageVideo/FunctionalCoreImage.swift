//
//  FunctionalCoreImage.swift
//  CoreImageVideo
//
//  Created by Chris Eidhof on 03/04/15.
//  Copyright (c) 2015 objc.io. All rights reserved.
//

import Foundation
import UIKit

typealias Filter = (CIImage) -> CIImage

func blur(radius: Double) -> Filter {
    return { image in
        let parameters = [
            kCIInputRadiusKey: radius,
            kCIInputImageKey: image
            ] as [String : Any]
        let filter = CIFilter(name: "CIGaussianBlur",
                              parameters: parameters)
        return filter!.outputImage!
    }
}

func colorGenerator(color: UIColor) -> Filter {
    return { _ in
        let parameters = [kCIInputColorKey: color]
        let filter = CIFilter(name: "CIConstantColorGenerator",
                              parameters: parameters)
        return filter!.outputImage!
    }
}

func hueAdjust(angleInRadians: Float) -> Filter {
    return { image in
        let parameters = [
            kCIInputAngleKey: angleInRadians,
            kCIInputImageKey: image
        ] as [String : Any]
        let filter = CIFilter(name: "CIHueAdjust",
                              parameters: parameters)
        return filter!.outputImage!
    }
}

func pixellate(scale: Float) -> Filter {
    return { image in
        let parameters = [
            kCIInputImageKey:image,
            kCIInputScaleKey:scale
        ] as [String : Any]
        return CIFilter(name: "CIPixellate", parameters: parameters)!.outputImage!
    }
}

func kaleidoscope() -> Filter {
    return { image in
        let parameters = [
            kCIInputImageKey:image,
        ] as [String : Any]
        return CIFilter(name: "CITriangleKaleidoscope", parameters: parameters)!.outputImage!.cropped(to: image.extent)
    }
}

func vibrance(amount: Float) -> Filter {
    return { image in
        let parameters = [
            kCIInputImageKey: image,
            "inputAmount": amount
        ] as [String : Any]
        return CIFilter(name: "CIVibrance", parameters: parameters)!.outputImage!
    }
}

func compositeSourceOver(overlay: CIImage) -> Filter {
    return { image in
        let parameters = [
            kCIInputBackgroundImageKey: image,
            kCIInputImageKey: overlay
        ] as [String : Any]
        let filter = CIFilter(name: "CISourceOverCompositing",
            parameters: parameters)
        let cropRect = image.extent
        return filter!.outputImage!.cropped(to: cropRect)
    }
}


func radialGradient(center: CGPoint, radius: CGFloat) -> CIImage {
    let params: [String: Any] = [
        "inputColor0": CIColor(red: 1, green: 1, blue: 1),
        "inputColor1": CIColor(red: 0, green: 0, blue: 0),
        "inputCenter": CIVector(cgPoint: center),
        "inputRadius0": radius,
        "inputRadius1": radius + 1
    ]
    return CIFilter(name: "CIRadialGradient", parameters: params)!.outputImage!
}

func blendWithMask(background: CIImage, mask: CIImage) -> Filter {
    return { image in
        let parameters: [String: Any] = [
            kCIInputBackgroundImageKey: background,
            kCIInputMaskImageKey: mask,
            kCIInputImageKey: image
        ]
        let filter = CIFilter(name: "CIBlendWithMask",
            parameters: parameters)
        let cropRect = image.extent
        return filter!.outputImage!.cropped(to: cropRect)
    }
}

func colorOverlay(color: UIColor) -> Filter {
    return { image in
        let overlay = colorGenerator(color: color)(image)
        return compositeSourceOver(overlay: overlay)(image)
    }
}
