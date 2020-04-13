//
//  CLPopupFoodPickerContentView.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/4/13.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLPopupFoodPickerContentView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        makeConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLPopupFoodPickerContentView {
    private func initUI() {
        backgroundColor = .white
    }
    private func makeConstraints () {
        
    }
}
