//
//  CLTagsController.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/4/2.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLTagsController: CLBaseViewController {
    private lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("跳转", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentView)
        view.addSubview(button)
        
        button.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(contentView.snp.bottom).offset(40)
        }
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
        contentView.frame = CGRect(x: 0, y: cl_safeAreaInsets().top + 44 + 100, width: view.frame.size.width, height: tagsFrame.tagsHeight)
        contentView.backgroundColor = UIColor.orange
        
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
            contentView.addSubview(tagsLable)
        }
    }
}
extension CLTagsController {
    @objc func nextAction() {
        let controller = CLTagsTableviewController()
        navigationController?.pushViewController(controller, animated: true)
    }
}
