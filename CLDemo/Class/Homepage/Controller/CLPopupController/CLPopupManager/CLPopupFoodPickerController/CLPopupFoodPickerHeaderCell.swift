//
//  CLPopupFoodPickerHeaderCell.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/4/13.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLPopupFoodPickerHeaderCell: UICollectionViewCell {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = PingFangSCBold(16)
        label.textColor = hexColor("#333333")
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        makeConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLPopupFoodPickerHeaderCell {
    private func initUI() {
        contentView.addSubview(titleLabel)
    }
    private func makeConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(20)
        }
    }
}
