//
//  swift
//  FUSHENG
//
//  Created by JmoVxia on 2019/12/24.
//  Copyright © 2019 FuSheng. All rights reserved.
//

import UIKit
//MARK: - 弹窗父类控制器
class CLPopupManagerBaseController: UIViewController {
    ///状态栏颜色
    var statusBarStyle: UIStatusBarStyle = UIApplication.shared.statusBarStyle
    ///是否自动旋转
    var autorotate: Bool = false
    ///支持方向
    var interfaceOrientationMask: UIInterfaceOrientationMask = .portrait
    ///是否隐藏状态栏
    var statusBarHidden: Bool = false
}
extension CLPopupManagerBaseController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    override var shouldAutorotate: Bool {
        return autorotate
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return interfaceOrientationMask
    }
    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }
}
//MARK: - 弹窗根控制器
class CLPopupManagerRootController: CLPopupManagerBaseController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return children.last?.preferredStatusBarStyle ?? .lightContent
    }
    override var shouldAutorotate: Bool {
        return children.last?.shouldAutorotate ?? true
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return children.last?.supportedInterfaceOrientations ?? .all
    }
    override var prefersStatusBarHidden: Bool {
        return children.last?.prefersStatusBarHidden ?? false
    }
}
//MARK: - 弹窗Window
class CLPopupManagerWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == rootViewController?.view {
            return nil
        }
        return view
    }
}
//MARK: - 弹窗管理者
class CLPopupManager: NSObject {
    private static var manager: CLPopupManager?
    private class var share: CLPopupManager {
        get {
            guard let shareManager = manager else {
                manager = CLPopupManager()
                return manager!
            }
            return shareManager
        }
    }
    private var popupManagerWindow: CLPopupManagerWindow?
    private class var window: CLPopupManagerWindow {
        get {
            guard let window = share.popupManagerWindow else {
                share.popupManagerWindow = CLPopupManagerWindow(frame: UIScreen.main.bounds)
                share.popupManagerWindow!.windowLevel = UIWindow.Level.statusBar
                share.popupManagerWindow!.isUserInteractionEnabled = true
                share.popupManagerWindow?.rootViewController = CLPopupManagerRootController()
                return share.popupManagerWindow!
            }
            return window
        }
    }
    private override init() {
        super.init()
    }
    deinit {
        print("============== PopupViewManager deinit ==================")
    }
}
extension CLPopupManager {
    /// 显示弹窗
    /// - Parameters:
    ///   - controller: 弹窗控制器
    ///   - unique: 是否唯一弹窗,唯一弹窗会自动销毁之前显示的弹窗
    private class func makeKeyAndVisible(with controller: UIViewController, unique: Bool) {
        let rootViewController = window.rootViewController
        if let children = rootViewController?.children, unique {
            for childrenController in children {
                childrenController.willMove(toParent: nil)
                childrenController.view.removeFromSuperview()
                childrenController.removeFromParent()
            }
        }
        controller.modalPresentationStyle = .custom
        rootViewController?.addChild(controller)
        rootViewController?.view.addSubview(controller.view)
        controller.didMove(toParent: rootViewController)
        window.makeKeyAndVisible()
        refresh()
    }
    /// 销毁弹窗
    /// - Parameter all: 是否销毁所有弹窗
    private class func destroyAll(_ all: Bool = true) {
        guard let childrenController = window.rootViewController?.children else {
            return
        }
        let controller = childrenController.last
        controller?.willMove(toParent: nil)
        controller?.view.removeFromSuperview()
        controller?.removeFromParent()
        refresh()
        if childrenController.count == 1 || all {
            window.resignKey()
            window.isHidden = true
            share.popupManagerWindow = nil
            manager = nil
        }
    }
    /// 刷新状态栏
    private class func refresh() {
        window.rootViewController?.setNeedsStatusBarAppearanceUpdate()
    }
}
extension CLPopupManager {
    /// 显示自定义弹窗
    /// - Parameters:
    ///   - controller: 自定义弹窗控制器
    ///   - unique: 唯一弹窗
    class func showCustom(with controller: UIViewController, unique: Bool = false) {
        DispatchQueue.main.async {
            makeKeyAndVisible(with: controller, unique: unique)
        }
    }
    /// 隐藏弹窗
    /// - Parameter all: 全部弹窗
    class func dismissAll(_ all: Bool = true) {
        DispatchQueue.main.async {
            destroyAll(all)
        }
    }
    /// 显示翻牌弹窗
    /// - Parameters:
    ///   - statusBarStyle: 状态栏类型
    ///   - statusBarHidden: 是否隐藏状态栏
    ///   - autorotate: 是否支持页面旋转
    ///   - interfaceOrientationMask: 页面旋转支持方向
    ///   - unique: 是否唯一弹窗(自动顶掉前面所有弹窗)
    class func showFlop(statusBarStyle: UIStatusBarStyle = .default, statusBarHidden: Bool = false, autorotate: Bool = false, interfaceOrientationMask: UIInterfaceOrientationMask = .all, unique: Bool = false) {
        let controller = CLPopupFlopController()
        controller.statusBarStyle = statusBarStyle
        controller.statusBarHidden = statusBarHidden
        controller.autorotate = autorotate
        controller.interfaceOrientationMask = interfaceOrientationMask
        showCustom(with: controller, unique: unique)
    }
    ///显示提示弹窗
    class func showTips(statusBarStyle: UIStatusBarStyle = .default, statusBarHidden: Bool = false, autorotate: Bool = false, interfaceOrientationMask: UIInterfaceOrientationMask = .all, unique: Bool = false, text: String, dismissInterval: TimeInterval = 1.0) {
        let controller = CLPopupTipsController()
        controller.statusBarStyle = statusBarStyle
        controller.statusBarHidden = statusBarHidden
        controller.autorotate = autorotate
        controller.interfaceOrientationMask = interfaceOrientationMask
        controller.text = text
        controller.dismissInterval = dismissInterval
        showCustom(with: controller, unique: unique)
    }
    ///显示一个消息弹窗
    class func showOneAlert(statusBarStyle: UIStatusBarStyle = .default, statusBarHidden: Bool = false, autorotate: Bool = false, interfaceOrientationMask: UIInterfaceOrientationMask = .all, unique: Bool = false, title: String? = nil, message: String? = nil, sure: String = "确定", sureCallBack: (() -> ())? = nil) {
        let controller = CLPopupMessageController()
        controller.statusBarStyle = statusBarStyle
        controller.statusBarHidden = statusBarHidden
        controller.autorotate = autorotate
        controller.interfaceOrientationMask = interfaceOrientationMask
        controller.type = .one
        controller.titleLabel.text = title
        controller.messageLabel.text = message
        controller.sureButton.setTitle(sure, for: .normal)
        controller.sureButton.setTitle(sure, for: .selected)
        controller.sureButton.setTitle(sure, for: .highlighted)
        controller.sureCallBack = sureCallBack
        showCustom(with: controller, unique: unique)
    }
    ///显示两个消息弹窗
    class func showTwoAlert(statusBarStyle: UIStatusBarStyle = .default, statusBarHidden: Bool = false, autorotate: Bool = false, interfaceOrientationMask: UIInterfaceOrientationMask = .all, unique: Bool = false, title: String? = nil, message: String? = nil, left: String = "取消", right: String = "确定", leftCallBack: (() -> ())? = nil, rightCallBack: (() -> ())? = nil) {
        let controller = CLPopupMessageController()
        controller.statusBarStyle = statusBarStyle
        controller.statusBarHidden = statusBarHidden
        controller.autorotate = autorotate
        controller.interfaceOrientationMask = interfaceOrientationMask
        controller.type = .two
        controller.titleLabel.text = title
        controller.messageLabel.text = message
        controller.leftButton.setTitle(left, for: .normal)
        controller.leftButton.setTitle(left, for: .selected)
        controller.leftButton.setTitle(left, for: .highlighted)
        controller.rightButton.setTitle(right, for: .normal)
        controller.rightButton.setTitle(right, for: .selected)
        controller.rightButton.setTitle(right, for: .highlighted)
        controller.leftCallBack = leftCallBack
        controller.rightCallBack = rightCallBack
        showCustom(with: controller, unique: unique)
    }
    ///显示成功
    class func showSuccess(statusBarStyle: UIStatusBarStyle = .default, statusBarHidden: Bool = false, autorotate: Bool = false, interfaceOrientationMask: UIInterfaceOrientationMask = .all, unique: Bool = false, strokeColor: UIColor = UIColor.red, text: String? = nil, dismissDuration: CGFloat = 1.0, dismissCallback: (() -> ())? = nil) {
        let controller = CLPopupHudController()
        controller.animationType = .success
        controller.statusBarStyle = statusBarStyle
        controller.statusBarHidden = statusBarHidden
        controller.autorotate = autorotate
        controller.interfaceOrientationMask = interfaceOrientationMask
        controller.strokeColor = strokeColor
        controller.text = text
        controller.dismissDuration = dismissDuration
        controller.dismissCallback = dismissCallback
        showCustom(with: controller, unique: unique)
    }
    ///显示错误
    class func showError(statusBarStyle: UIStatusBarStyle = .default, statusBarHidden: Bool = false, autorotate: Bool = false, interfaceOrientationMask: UIInterfaceOrientationMask = .all, unique: Bool = false, strokeColor: UIColor = UIColor.red, text: String? = nil, dismissDuration: CGFloat = 1.0, dismissCallback: (() -> ())? = nil) {
        let controller = CLPopupHudController()
        controller.animationType = .error
        controller.statusBarStyle = statusBarStyle
        controller.statusBarHidden = statusBarHidden
        controller.autorotate = autorotate
        controller.interfaceOrientationMask = interfaceOrientationMask
        controller.strokeColor = strokeColor
        controller.text = text
        controller.dismissDuration = dismissDuration
        controller.dismissCallback = dismissCallback
        showCustom(with: controller, unique: unique)
    }
    ///显示加载
    class func showLoading(statusBarStyle: UIStatusBarStyle = .default, statusBarHidden: Bool = false, autorotate: Bool = false, interfaceOrientationMask: UIInterfaceOrientationMask = .all, unique: Bool = false, strokeColor: UIColor = UIColor.red, text: String? = nil) {
        let controller = CLPopupHudController()
        controller.animationType = .loading
        controller.statusBarStyle = statusBarStyle
        controller.statusBarHidden = statusBarHidden
        controller.autorotate = autorotate
        controller.interfaceOrientationMask = interfaceOrientationMask
        controller.strokeColor = strokeColor
        controller.text = text
        controller.animationSize = CGSize(width: 80, height: 80)
        showCustom(with: controller, unique: unique)
    }
    ///显示年月日选择器
    class func showYearMonthDayDataPicker(statusBarStyle: UIStatusBarStyle = .default, statusBarHidden: Bool = false, autorotate: Bool = true, interfaceOrientationMask: UIInterfaceOrientationMask = .all, unique: Bool = false, yearMonthDayCallback: ((Int, Int, Int) -> ())? = nil) {
        let controller = CLPopupDataPickerController()
        controller.statusBarStyle = statusBarStyle
        controller.statusBarHidden = statusBarHidden
        controller.autorotate = autorotate
        controller.interfaceOrientationMask = interfaceOrientationMask
        controller.type = .yearMonthDay
        controller.yearMonthDayCallback = yearMonthDayCallback
        showCustom(with: controller, unique: unique)
    }
    ///显示时分选择器
    class func showHourMinuteDataPicker(statusBarStyle: UIStatusBarStyle = .default, statusBarHidden: Bool = false, autorotate: Bool = true, interfaceOrientationMask: UIInterfaceOrientationMask = .all, unique: Bool = false, hourMinuteCallback: ((Int, Int) -> ())? = nil) {
        let controller = CLPopupDataPickerController()
        controller.statusBarStyle = statusBarStyle
        controller.statusBarHidden = statusBarHidden
        controller.autorotate = autorotate
        controller.interfaceOrientationMask = interfaceOrientationMask
        controller.type = .hourMinute
        controller.hourMinuteCallback = hourMinuteCallback
        showCustom(with: controller, unique: unique)
    }
    ///显示年月日时分选择器
    class func showYearMonthDayHourMinuteDataPicker(statusBarStyle: UIStatusBarStyle = .default, statusBarHidden: Bool = false, autorotate: Bool = true, interfaceOrientationMask: UIInterfaceOrientationMask = .all, unique: Bool = false, yearMonthDayHourMinuteCallback: ((Int, Int, Int, Int, Int) -> ())? = nil) {
        let controller = CLPopupDataPickerController()
        controller.statusBarStyle = statusBarStyle
        controller.statusBarHidden = statusBarHidden
        controller.autorotate = autorotate
        controller.interfaceOrientationMask = interfaceOrientationMask
        controller.type = .yearMonthDayHourMinute
        controller.yearMonthDayHourMinuteCallback = yearMonthDayHourMinuteCallback
        showCustom(with: controller, unique: unique)
    }
    ///显示BMI输入弹窗
    class func showBMIInput(statusBarStyle: UIStatusBarStyle = .default, statusBarHidden: Bool = false, autorotate: Bool = true, interfaceOrientationMask: UIInterfaceOrientationMask = .all, unique: Bool = false, bmiCallback: ((CGFloat) -> ())? = nil) {
        let controller = CLPopupBMIInputController()
        controller.statusBarStyle = statusBarStyle
        controller.statusBarHidden = statusBarHidden
        controller.autorotate = autorotate
        controller.interfaceOrientationMask = interfaceOrientationMask
        controller.bmiCallback = bmiCallback
        showCustom(with: controller, unique: unique)
    }
    ///显示一个输入框弹窗
    class func showOneInput(statusBarStyle: UIStatusBarStyle = .default, statusBarHidden: Bool = false, autorotate: Bool = true, interfaceOrientationMask: UIInterfaceOrientationMask = .all, unique: Bool = false, type: CLPopupOneInputType, sureCallback: ((String?) -> ())? = nil) {
        let controller = CLPopupOneInputController()
        controller.statusBarStyle = statusBarStyle
        controller.statusBarHidden = statusBarHidden
        controller.autorotate = autorotate
        controller.interfaceOrientationMask = interfaceOrientationMask
        controller.type = type
        controller.sureCallback = sureCallback
        showCustom(with: controller, unique: unique)
    }
    ///显示两个输入框弹窗
    class func showTwoInput(statusBarStyle: UIStatusBarStyle = .default, statusBarHidden: Bool = false, autorotate: Bool = true, interfaceOrientationMask: UIInterfaceOrientationMask = .all, unique: Bool = false, type: CLPopupTwoInputType, sureCallback: ((String?, String?) -> ())? = nil) {
        let controller = CLPopupTwoInputController()
        controller.statusBarStyle = statusBarStyle
        controller.statusBarHidden = statusBarHidden
        controller.autorotate = autorotate
        controller.interfaceOrientationMask = interfaceOrientationMask
        controller.type = type
        controller.sureCallback = sureCallback
        showCustom(with: controller, unique: unique)
    }
}
