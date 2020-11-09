//
//  CLDrawMarqueeController.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2020/11/9.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit
import SnapKit

//MARK: - JmoVxia---枚举
extension CLDrawMarqueeController {
}
//MARK: - JmoVxia---类-属性
class CLDrawMarqueeController: CLBaseViewController {
    private lazy var marqueeView: CLDrawMarqueeView = {
        let view = CLDrawMarqueeView()
        return view
    }()
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
    }
}
//MARK: - JmoVxia---生命周期
extension CLDrawMarqueeController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        makeConstraints()
        initData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}
//MARK: - JmoVxia---布局
private extension CLDrawMarqueeController {
    func initUI() {
        view.addSubview(marqueeView)
    }
    func makeConstraints() {
        marqueeView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(40)
            make.left.right.equalToSuperview()
        }
    }
}
//MARK: - JmoVxia---数据
private extension CLDrawMarqueeController {
    func initData() {
        marqueeView.setText("台湾释放被遣返诈骗犯 国台办要求立即纠正错误，严惩嫌犯")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.marqueeView.startAnimation()
        }
    }
}
//MARK: - JmoVxia---override
extension CLDrawMarqueeController {
}
//MARK: - JmoVxia---objc
@objc private extension CLDrawMarqueeController {
}
//MARK: - JmoVxia---私有方法
private extension CLDrawMarqueeController {
}
//MARK: - JmoVxia---公共方法
extension CLDrawMarqueeController {
}
