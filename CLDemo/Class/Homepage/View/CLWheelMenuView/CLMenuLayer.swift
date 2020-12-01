//
//  CLMenuLayer.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2020/12/1.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLMenuLayer: CAShapeLayer {
    var selectedImage: UIImage!
    var image: UIImage!
    var selected = false {
        didSet {
            if oldValue != selected {
                updateContents()
            }
        }
    }
    fileprivate let contentsLayer: CALayer
    fileprivate let arcLayer: CAShapeLayer
    
    init(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, item: CLMenuItem, bounds: CGRect,
        contentsTransform: CATransform3D, selectedImage: UIImage, image: UIImage) {
        self.selectedImage = selectedImage
        self.image = image
        let scale    = UIScreen.main.scale
        let arcWidth = CGFloat(5)
        
        let bezierPath = UIBezierPath()
        bezierPath.addArc(withCenter: center,
            radius: bounds.width/2 - arcWidth/2,
            startAngle: startAngle-0.01,
            endAngle: endAngle+0.01,
            clockwise: true)
        
        arcLayer             = CAShapeLayer()
        arcLayer.path        = bezierPath.cgPath
        arcLayer.lineWidth   = arcWidth
        arcLayer.fillColor   = UIColor.clear.cgColor
        
        contentsLayer                    = CALayer()
        contentsLayer.frame              = bounds
        contentsLayer.contentsGravity    = CALayerContentsGravity.center
        contentsLayer.contentsScale      = scale
        contentsLayer.transform          = contentsTransform
        contentsLayer.rasterizationScale = scale
        contentsLayer.shouldRasterize    = true
        
        super.init()
        
        let path = UIBezierPath()
        path.addArc(withCenter: center,
            radius: bounds.width/2,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true)
        path.addLine(to: center)
        
        self.path          = path.cgPath
        lineWidth          = 0
        rasterizationScale = scale
        shouldRasterize    = true
        
        updateContents()
        
        addSublayer(contentsLayer)
        addSublayer(arcLayer)
    }

    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func updateContents() {
        if selected {
            contentsLayer.contents = selectedImage?.cgImage
        } else {
            contentsLayer.contents = image?.cgImage
        }
    }
}
