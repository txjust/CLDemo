//
//  CLTagsController.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/4/2.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLTagsController: CLBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        createTags()
    }
    func createTags() {
        let font = UIFont.systemFont(ofSize: 20)
        let tagsArray: [String] = ["口服","冲服","煎服","含漱","注射","贴患处","吸入","喷患处","穴位","腹腔给药"]
        let tagsFrame = CLTagsFrameHelper.calculateTagsFrame(configure: { (configure) in
            configure.tagsMinPadding = 5
            configure.tagHeight = font.lineHeight + 10
            configure.tagsTitleFont = font
//            configure.isAlignment = false
        }, tagsArray: tagsArray)
        
        let backView = UIView()
        backView.frame = CGRect(x: 0, y: cl_safeAreaInsets().top + 44 + 100, width: view.frame.size.width, height: tagsFrame.tagsHeight)
        backView.backgroundColor = UIColor.orange
        view.addSubview(backView)
        
        for i in 0..<tagsArray.count {
            let tagsLable = UILabel()
            tagsLable.textAlignment = .center
            tagsLable.text = tagsArray[i]
            tagsLable.textColor = UIColor.black
            tagsLable.font = font
            tagsLable.backgroundColor = UIColor.white
            tagsLable.layer.borderWidth = 1
            tagsLable.layer.borderColor = UIColor.lightGray.cgColor
            tagsLable.layer.cornerRadius = 4
            tagsLable.layer.masksToBounds = true
            tagsLable.frame = tagsFrame.tagsFrames[i]
            backView.addSubview(tagsLable)
        }
    }
}
