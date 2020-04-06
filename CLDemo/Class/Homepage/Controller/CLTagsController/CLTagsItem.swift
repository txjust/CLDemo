//
//  CLTagsItem.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/4/6.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLTagsItem: NSObject {
    private (set) var font: UIFont!
    private (set) var tags: [String]!
    private (set) var tagsFrames: [CGRect]!
    private (set) var tagsHeight: CGFloat = 0.0
    init(with tags: [String], font: UIFont = UIFont.systemFont(ofSize: 15)) {
        super.init()
        self.tags = tags
        self.font = font
        let tagsInfo = CLTagsFrameHelper.calculateTagsFrame(configure: { (configure) in
            configure.tagsMinPadding = 10
            configure.tagHeight = font.lineHeight + 10
            configure.tagsTitleFont = font
            configure.isAlignment = false
        }, tagsArray: tags)
        tagsFrames = tagsInfo.tagsFrames
        tagsHeight = tagsInfo.tagsHeight
    }
}
