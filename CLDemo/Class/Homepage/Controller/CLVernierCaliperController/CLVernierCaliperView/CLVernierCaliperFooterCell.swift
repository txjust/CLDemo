//
//  CLVernierCaliperFooterCell.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/5/1.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLVernierCaliperFooterCell: UICollectionViewCell {
    var footerMaxValue: CGFloat = 0.0
    var footerUnit: String = ""
    var long : CGFloat = 0.0
    var textFont : UIFont = UIFont.systemFont(ofSize: 14)
}
extension CLVernierCaliperFooterCell {
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.hexColor(with: "#E2E2E2").cgColor)
        context?.setLineWidth(1.0)
        context?.setLineCap(CGLineCap.butt)
        context?.move(to: CGPoint.init(x: 0, y: 0))
        let numStr:NSString = NSString(format: "%.2f%@", footerMaxValue,footerUnit)
        let attribute:Dictionary = [NSAttributedString.Key.font:textFont,NSAttributedString.Key.foregroundColor:UIColor.hexColor(with: "#999999")]
        let width = numStr.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions(rawValue: 0), attributes: attribute, context: nil).size.width
        numStr.draw(in: CGRect.init(x: 0-width/2, y: CGFloat(rect.size.height - CGFloat(long) + 10), width: width, height:textFont.lineHeight), withAttributes: attribute)
        context?.addLine(to: CGPoint.init(x: 0, y: CGFloat(long)))
        context?.strokePath()
    }
}

