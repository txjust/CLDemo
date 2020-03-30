//
//  CLDataPickerView.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/3/30.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit
import DateToolsSwift

class CLDataPickerView: UIView {
    lazy var yearArray: [Int] = {
        var yearArray = [Int]()
        for item in (nowDate.year - 10)...(nowDate.year) {
            yearArray.append(item)
        }
        return yearArray
    }()
    lazy var monthArray: [Int] = {
        var monthArray = [Int]()
//        for item in 1...12 {
//            monthArray.append(item)
//        }
        return monthArray
    }()
    lazy var dayArray: [Int] = {
        let dayArray = [Int]()
        return dayArray
    }()
    var nowDate: Date = Date(timeIntervalSinceNow: 0)
    var yearIndex: Int = 0
    var monthIndex: Int = 0
    var dayIndex: Int = 0
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
        
        select(year: nowDate.year, month: nowDate.month, day: nowDate.day)
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
        let years = yearArray.count
        let months = monthFrom(year: yearArray[yearIndex])
        let days = daysFrom(year: yearArray[yearIndex], month: monthArray[monthIndex])
        let array = [years, months, days]
        return array[component]
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
        if component == 0 {
            label.text =  String(yearArray[row])
        }else if component == 1 {
            label.text =  String(monthArray[row])
        }else if component == 2 {
            label.text =  String(dayArray[row])
        }
        return label
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            yearIndex = row
        }else if component == 1 {
            monthIndex = row
        }else if component == 2 {
            dayIndex = row
        }
        if component < 2 {
            let month = monthFrom(year: yearArray[yearIndex])
            monthIndex = min(monthIndex, month - 1)
            let days = daysFrom(year: yearArray[yearIndex], month: monthArray[monthIndex])
            dayIndex = min(dayIndex, days - 1)
        }
        pickerView.reloadAllComponents()
    }
}
extension CLDataPickerView {
    @discardableResult func monthFrom(year: Int) -> Int {
        let month = year == nowDate.year ? nowDate.month : 12
        monthArray = Array(1...month)
        return month
    }
    @discardableResult func daysFrom(year: Int, month: Int) -> Int {
        let isRunNian = year % 4 == 0 ? (year % 100 == 0 ? (year % 400 == 0 ? true : false) : true) : false
        switch month {
        case 1, 3, 5, 7, 8, 10, 12:
            dayArray = Array(1...31)
            return 31
        case 4, 6, 9, 11:
            dayArray = Array(1...30)
            return 30
        case 2:
            if isRunNian {
                dayArray = Array(1...29)
                return 29
            } else {
                dayArray = Array(1...28)
                return 28
            }
        default:
            break
        }
        return 0
    }
}
extension CLDataPickerView {
    func select(year: Int, month: Int, day: Int) {
        yearIndex = yearArray.firstIndex(of: year) ?? 0
        monthFrom(year: year)
        monthIndex = monthArray.firstIndex(of: month) ?? 0
        daysFrom(year: year, month: month)
        dayIndex = dayArray.firstIndex(of: day) ?? 0
        pickerView.selectRow(yearIndex, inComponent: 0, animated: true)
        pickerView.selectRow(monthIndex, inComponent: 1, animated: true)
        pickerView.selectRow(dayIndex, inComponent: 2, animated: true)
    }
}
extension CLDataPickerView {
    @objc func cancelAction() {
        
    }
    @objc func sureAction() {
        
    }
}
