//
//  CLPopupMomentumController.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2020/10/10.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLPopupMomentumController: CLPopupManagerController {
    private lazy var momentumView: CLMomentumView = {
        let view = CLMomentumView()
        view.backgroundColor = .randomColor
        return view
    }()
}
extension CLPopupMomentumController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        makeConstraints()
        showAnimation()
    }
}
extension CLPopupMomentumController {
    private func initUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        view.addSubview(momentumView)
    }
    private func makeConstraints() {
        momentumView.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.right.equalTo(-8)
            make.bottom.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(80)
        }
    }
}
extension CLPopupMomentumController {
    private func showAnimation() {
        UIView.animate(withDuration: 0.35, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        }, completion: { (_) in

        })
    }
    private func dismissAnimation(completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.35, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        }, completion: completion)
    }
}
