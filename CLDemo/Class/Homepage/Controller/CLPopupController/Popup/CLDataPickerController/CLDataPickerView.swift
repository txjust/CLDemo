//
//  CLDataPickerView.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/3/30.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLDataPickerView: UIView {
    lazy var topToolBar: UIButton = {
        let topToolBar = UIButton()
        topToolBar.backgroundColor = hexColor("#F8F6F9")
        return topToolBar
    }()
    lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitle("取消", for: .selected)
        cancelButton.setTitle("取消", for: .highlighted)
        cancelButton.setTitleColor(hexColor("#666666"), for: .normal)
        cancelButton.setTitleColor(hexColor("#666666"), for: .selected)
        cancelButton.setTitleColor(hexColor("#666666"), for: .highlighted)
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return cancelButton
    }()
    lazy var sureButton: UIButton = {
        let sureButton = UIButton()
        sureButton.setTitle("确定", for: .normal)
        sureButton.setTitle("确定", for: .selected)
        sureButton.setTitle("确定", for: .highlighted)
        sureButton.setTitleColor(hexColor("#40B5AA"), for: .normal)
        sureButton.setTitleColor(hexColor("#40B5AA"), for: .selected)
        sureButton.setTitleColor(hexColor("#40B5AA"), for: .highlighted)
        sureButton.addTarget(self, action: #selector(sureAction), for: .touchUpInside)
        return sureButton
    }()
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
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
extension CLDataPickerView {
    func initUI() {
        backgroundColor = UIColor.white
        addSubview(topToolBar)
        topToolBar.addSubview(cancelButton)
        topToolBar.addSubview(sureButton)
        addSubview(pickerView)
    }
    func makeConstraints() {
        topToolBar.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(50)
        }
        cancelButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.left.equalTo(self.safeAreaLayoutGuide.snp.left).offset(15)
            } else {
                make.left.equalTo(15)
            }
        }
        sureButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.right.equalTo(self.safeAreaLayoutGuide.snp.right).offset(-15)
            } else {
                make.right.equalTo(-15)
            }
        }
        pickerView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.left.right.bottom.equalTo(self.safeAreaLayoutGuide)
            } else {
                make.left.right.bottom.equalToSuperview()
            }
            make.top.equalTo(topToolBar.snp.bottom)
        }
    }
}
extension CLDataPickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 20
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
}
extension CLDataPickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label: UILabel = (view as? UILabel) ?? UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = hexColor("#333333")
        label.text = "121212"
        return label
    }
}
extension CLDataPickerView {
    @objc func cancelAction() {
        
    }
    @objc func sureAction() {
        
    }
}
