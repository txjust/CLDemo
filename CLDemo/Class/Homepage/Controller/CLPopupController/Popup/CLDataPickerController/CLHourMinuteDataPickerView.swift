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
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLHourMinuteDataPickerView {
    func initUI() {
        backgroundColor = UIColor.white
        addSubview(pickerView)
        pickerView.addSubview(lineView)
    }
    func makeConstraints() {
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
            make.top.equalToSuperview()
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

