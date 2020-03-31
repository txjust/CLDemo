//
//  CLHourMinuteDataPickerView.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/3/31.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit
import DateToolsSwift

class CLHourMinuteDataPickerView: UIView {
    var cancelCallback: (() -> ())?
    var sureCallback: ((Int, Int) -> ())?
    var hourIndex: Int = 0
    var minuteIndex: Int = 0
    lazy var hourArray: [Int] = {
        var hourArray = Array(0...23)
        return hourArray
    }()
    lazy var minuteArray: [Int] = {
        let minuteArray = Array(0...59)
        return minuteArray
    }()
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
    lazy var lineView: UILabel = {
        let lineView = UILabel()
        lineView.backgroundColor = hexColor("#40B5AA")
        return lineView
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
        
//        select(year: nowDate.year, month: nowDate.month, day: nowDate.day)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLHourMinuteDataPickerView {
    func initUI() {
        backgroundColor = UIColor.white
        addSubview(topToolBar)
        topToolBar.addSubview(cancelButton)
        topToolBar.addSubview(sureButton)
        addSubview(pickerView)
        pickerView.addSubview(lineView)
    }
    func makeConstraints() {
        topToolBar.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(50)
        }
        cancelButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.left.equalTo(self.safeAreaLayoutGuide).offset(15)
            } else {
                make.left.equalTo(15)
            }
        }
        sureButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.right.equalTo(self.safeAreaLayoutGuide).offset(-15)
            } else {
                make.right.equalTo(-15)
            }
        }
        lineView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(0.5)
            make.height.equalTo(16)
        }
        pickerView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.left.equalTo(self.safeAreaLayoutGuide).offset(15)
                make.right.equalTo(self.safeAreaLayoutGuide).offset(-15)
                make.bottom.equalTo(self.safeAreaLayoutGuide)
            } else {
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.bottom.equalToSuperview()
            }
            make.top.equalTo(topToolBar.snp.bottom)
        }
    }
}
extension CLHourMinuteDataPickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let array = [hourArray.count, minuteArray.count]
        return array[component]
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
}
extension CLHourMinuteDataPickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label: UILabel = (view as? UILabel) ?? UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        var textColor = hexColor("#333333")
        let currentColor = hexColor("#40B5AA")
        if component == 0 {
            textColor  = hourIndex == row ? currentColor : textColor
            label.text =  String(hourArray[row])
        }else if component == 1 {
            textColor  = minuteIndex == row ? currentColor : textColor
            label.text =  String(minuteArray[row])
        }
        label.textColor = textColor
        return label
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            hourIndex = row
        }else if component == 1 {
            minuteIndex = row
        }
        pickerView.reloadAllComponents()
    }
}
extension CLHourMinuteDataPickerView {
    @objc func cancelAction() {
        cancelCallback?()
    }
    @objc func sureAction() {
        sureCallback?(hourArray[hourIndex], minuteArray[minuteIndex])
    }
}
