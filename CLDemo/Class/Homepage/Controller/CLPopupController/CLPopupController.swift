//
//  CLPopupController.swift
//  CLDemo
//
//  Created by JmoVxia on 2019/12/28.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

import UIKit

class CLPopupModel: NSObject {
    var title: String?
    var callback: (() -> ())?
}


class CLPopupController: CLBaseViewController {
    lazy var arrayDS: [CLPopupModel] = {
        let arrayDS = [CLPopupModel]()
        return arrayDS
    }()
    lazy var tableview: UITableView = {
        let tableview = UITableView()
        tableview.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
        tableview.dataSource = self
        tableview.delegate = self
        return tableview
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        view.addSubview(tableview)
        tableview.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalToSuperview()
            }
        }
    }
}
extension CLPopupController {
    func initData() {
        let model1 = CLPopupModel()
        model1.title = "翻牌弹窗"
        model1.callback = {[weak self] in
            self?.showFlop()
        }
        arrayDS.append(model1)
        
        let model2 = CLPopupModel()
        model2.title = "系统弹窗，一个按钮"
        model2.callback = {[weak self] in
            self?.showOne()
        }
        arrayDS.append(model2)
        
        let model3 = CLPopupModel()
        model3.title = "系统弹窗，两个按钮"
        model3.callback = {[weak self] in
            self?.showTwo()
        }
        arrayDS.append(model3)
        
        let model4 = CLPopupModel()
        model4.title = "成功弹窗"
        model4.callback = {[weak self] in
            self?.showSuccess()
        }
        arrayDS.append(model4)
        
        let model5 = CLPopupModel()
        model5.title = "错误弹窗"
        model5.callback = {[weak self] in
            self?.showError()
        }
        arrayDS.append(model5)
        
        let model6 = CLPopupModel()
        model6.title = "加载弹窗"
        model6.callback = {[weak self] in
            self?.showLoading()
        }
        arrayDS.append(model6)
    }
}
extension CLPopupController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayDS.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = arrayDS[indexPath.row].title
        return cell
    }
}
extension CLPopupController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = arrayDS[indexPath.row]
        model.callback?()
    }
}
extension CLPopupController {
    func showFlop() {
        CLPopupManager.showFlop()
        //        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
        //            CLPopupManager.showFlop(statusBarHidden: true)
        //        }
        //        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4) {
        //            CLPopupManager.showFlop(statusBarStyle: .default, statusBarHidden: false)
        //        }
        //        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 6) {
        //            CLPopupManager.showFlop(statusBarStyle: .default)
        //        }
    }
    func showOne() {
        CLPopupManager.showOneAlert(autorotate: true, title: "我是一个按钮", message: "我有一个按钮")
    }
    func showTwo() {
        CLPopupManager.showTwoAlert(autorotate: true, title: "我是两个按钮", message: "我有两个按钮")
    }
    func showSuccess() {
        CLPopupManager.showSuccess(autorotate: true, interfaceOrientationMask: .all, only: true, text: "显示成功", dismissCallback: {
            print("success animation dismiss")
        })
    }
    func showError() {
        CLPopupManager.showError(autorotate: true, interfaceOrientationMask: .all, only: true, text: "显示错误", dismissCallback: {
            print("error animation dismiss")
        })
    }
    func showLoading() {
        CLPopupManager.showLoading(autorotate: true, interfaceOrientationMask: .all, only: true, text: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 6) {
            CLPopupManager.dismissAll()
        }
    }
}
