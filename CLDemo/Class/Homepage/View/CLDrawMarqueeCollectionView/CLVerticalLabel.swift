//
//  CLVerticalLabel.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2020/11/10.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit
import SnapKit

//MARK: - JmoVxia---枚举
extension CLVerticalLabel {
    enum VerticalAlignment {
        case alignmentTop
        case alignmentMiddle
        case alignmentBottom
    }
}
//MARK: - JmoVxia---类-属性
class CLVerticalLabel: UILabel {
    var verticalAlignment: VerticalAlignment = .alignmentMiddle {
        didSet {
            setNeedsDisplay()
        }
    }
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var textRect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        switch (verticalAlignment) {
            case .alignmentTop:
                textRect.origin.y = bounds.origin.y;
                break
            case .alignmentMiddle:
                textRect.origin.y = bounds.origin.y + (bounds.height - textRect.height) * 0.5
                break
            case .alignmentBottom:
                textRect.origin.y = bounds.origin.y + bounds.height - textRect.height
                break
        }
        return textRect
    }
    override func drawText(in rect: CGRect) {
        super.drawText(in: textRect(forBounds: rect, limitedToNumberOfLines: numberOfLines))
    }
}
