//
//  CLDataPickerController.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/3/30.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLDataPickerController: CLPopupManagerBaseController {
    lazy var dataPick: CLDataPickerView = {
        let dataPick = CLDataPickerView()
        return dataPick
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        showAnimation()
    }
}
extension CLDataPickerController {
    func initUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        view.addSubview(dataPick)
    }
}
extension CLDataPickerController {
    func showAnimation() {
        dataPick.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.snp.bottom)
            make.height.equalTo(302.5)
        }
        view.setNeedsLayout()
        view.layoutIfNeeded()
        dataPick.snp.remakeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(302.5)
        }
        UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveEaseInOut, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }) { (_) in
            
        }
    }
    func dismissAnimation() {
        dataPick.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.snp.bottom)
            make.height.equalTo(302.5)
        }
        UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveEaseInOut, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }) { (_) in
            CLPopupManager.dismissAll(false)
        }
    }
}
extension CLDataPickerController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        dismissAnimation()
    }
}
