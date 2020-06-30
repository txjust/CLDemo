//
//  CLChatPhotoAlbumTopBar.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/6/30.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLChatPhotoAlbumTopBar: UIView {
    var closeCallback: (() -> ())?
    private lazy var closeButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "btn_x"), for: .normal)
        view.setImage(UIImage(named: "btn_x"), for: .selected)
        view.setImage(UIImage(named: "btn_x"), for: .highlighted)
        view.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
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
extension CLChatPhotoAlbumTopBar {
    private func initUI() {
        addSubview(closeButton)
    }
    private func makeConstraints() {
        closeButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(12)
            make.size.equalTo(26)
        }
    }
}
extension CLChatPhotoAlbumTopBar {
    @objc private func closeAction() {
        closeCallback?()
    }
}
