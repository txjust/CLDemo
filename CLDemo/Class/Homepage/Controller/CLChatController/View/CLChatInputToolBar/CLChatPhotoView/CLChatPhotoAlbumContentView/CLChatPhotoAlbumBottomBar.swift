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
    ///是否隐藏发送按钮
    private var isHiddenSend: Bool = true {
        didSet {
            if isHiddenSend != oldValue {
                sendButton.isHidden = isHiddenSend
                if !isHidden {
                    sendButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
                        self.sendButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    }, completion: nil)
                }
            }
        }
    }
    ///发送按钮
    private lazy var sendButton: UIButton = {
        let sendButton = UIButton()
        sendButton.isHidden = true
        sendButton.adjustsImageWhenHighlighted = false
        sendButton.setImage(UIImage.init(named: "btn_knocktalk_send"), for: .normal)
        sendButton.setImage(UIImage.init(named: "btn_knocktalk_send"), for: .selected)
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
        sendCallback?()
    }
}
