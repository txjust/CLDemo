//
//  CLCarouselCell.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2020/10/12.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLCarouselCell: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .randomColor
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
