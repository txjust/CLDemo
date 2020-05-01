//
//  CLVernierCaliperMiddleCell.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/5/1.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLVernierCaliperMiddleCell: UICollectionViewCell {
    var minValue: CGFloat = 0.0
    var maxValue: CGFloat = 0.0
    var unit:String = ""
    var step: CGFloat = 0.0
    var betweenNumber = 0
    var gap: CGFloat = 12
    var long: CGFloat = 30.0
    var short: CGFloat = 15.0
    var textFont: UIFont = UIFont.systemFont(ofSize: 14)
}
extension CLVernierCaliperMiddleCell {
        override func draw(_ rect: CGRect) {
            let startX:CGFloat  = 0
            let lineCenterX: CGFloat = gap
            let topY:CGFloat = 0
            let context = UIGraphicsGetCurrentContext()
            context?.setLineWidth(1)
            context?.setLineCap(CGLineCap.butt)
            context?.setStrokeColor(UIColor.hexColor(with: "#E2E2E2").cgColor)
            for i in 0...betweenNumber {
                context?.move(to: CGPoint.init(x: startX+lineCenterX*CGFloat(i), y: topY))
                if i % betweenNumber == 0 {
                    let num = CGFloat(i) * step + minValue
                    let numStr = String(format: "%.2f%@", num,unit)
                    let attribute:Dictionary = [NSAttributedString.Key.font:textFont,NSAttributedString.Key.foregroundColor:UIColor.hexColor(with: "#999999")]
                    let width = numStr.boundingRect(
                        with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
                        options: NSStringDrawingOptions.usesLineFragmentOrigin,
                        attributes: attribute,context: nil).size.width
                    numStr.draw(in: CGRect.init(x: startX+lineCenterX*CGFloat(i) - width * 0.5, y: rect.size.height - CGFloat(long) + 10, width: width, height: textFont.lineHeight), withAttributes: attribute)
                    context!.addLine(to: CGPoint.init(x: startX+lineCenterX*CGFloat(i), y: CGFloat(long)))
                }else{
                    context!.addLine(to: CGPoint.init(x: startX+lineCenterX*CGFloat(i), y: CGFloat(short)))
                }
                context!.strokePath()
            }
    }
}
