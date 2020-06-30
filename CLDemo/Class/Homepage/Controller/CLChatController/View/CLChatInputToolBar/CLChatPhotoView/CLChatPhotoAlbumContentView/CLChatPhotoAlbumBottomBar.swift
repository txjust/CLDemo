//
//  CLChatPhotoAlbumBottomBar.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/6/30.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLChatPhotoAlbumBottomBar: UIView {
    var sendCallback: (() -> ())?
    ///是否可以发送
    var seletedNumber: Int = 0 {
        didSet {
            if oldValue != seletedNumber {
                seletedNumberLabel.text = "\(seletedNumber)"
                if seletedNumber > 0 {
                    seletedNumberLabel.isHidden = false
                    sendButton.isHidden = false
                }else {
                    seletedNumberLabel.isHidden = true
                    sendButton.isHidden = true
                }
            }
        }
    }
    ///选中张数
    private lazy var seletedNumberLabel: UILabel = {
        let view = UILabel()
        view.isHidden = true
        view.backgroundColor = .clear
        view.textColor = .white
        return view
    }()
    ///发送按钮
    private lazy var sendButton: UIButton = {
        let view = UIButton()
        view.isHidden = true
        view.setImage(UIImage.init(named: "btn_knocktalk_send"), for: .normal)
        view.setImage(UIImage.init(named: "btn_knocktalk_send"), for: .selected)
        view.setImage(UIImage.init(named: "btn_knocktalk_send"), for: .highlighted)
        view.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.red.withAlphaComponent(0.2)
        initUI()
        makeConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLChatPhotoAlbumBottomBar {
    private func initUI() {
        addSubview(sendButton)
        addSubview(seletedNumberLabel)
    }
    private func makeConstraints() {
        sendButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-12)
            make.size.equalTo(26)
        }
        seletedNumberLabel.snp.makeConstraints { (make) in
            make.right.equalTo(sendButton.snp.left).offset(-12)
            make.centerY.equalToSuperview()
        }
    }
}
extension CLChatPhotoAlbumBottomBar {
    @objc private func sendButtonAction() {
       sendCallback?()
    }
}
