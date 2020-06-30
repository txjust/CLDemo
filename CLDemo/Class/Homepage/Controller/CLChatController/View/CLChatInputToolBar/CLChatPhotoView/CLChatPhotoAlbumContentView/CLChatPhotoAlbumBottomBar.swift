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
    var isCanSend: Bool = false {
        didSet {
            if isCanSend != oldValue {
                sendButton.isSelected = isCanSend
            }
        }
    }
    ///发送按钮
    private lazy var sendButton: UIButton = {
        let sendButton = UIButton()
        sendButton.adjustsImageWhenHighlighted = false
        sendButton.setImage(UIImage.init(named: "btn_knocktalk_send"), for: .selected)
        sendButton.setImage(UIImage.init(named: "btn_knocktalk_send")?.tintedImage(.gray), for: .normal)
        sendButton.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
        return sendButton
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
    }
    private func makeConstraints() {
        sendButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-12)
            make.size.equalTo(26)
        }
    }
}
extension CLChatPhotoAlbumBottomBar {
    @objc private func sendButtonAction() {
        if isCanSend {
            sendCallback?()
        }
    }
}
