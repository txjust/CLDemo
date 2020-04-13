//
//  CLPopupFoodPickerView.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/4/13.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLPopupFoodPickerView: UIView {
    private lazy var headView: CLPopupFoodPickerHeaderView = {
        let view = CLPopupFoodPickerHeaderView()
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        makeConstraints()
        headView.dataArray = ["小麦","大豆","玉米"]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLPopupFoodPickerView {
    private func initUI() {
        addSubview(headView)
    }
    private func makeConstraints() {
        headView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(50)
        }
    }
}
