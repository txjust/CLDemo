//
//  CLPopupInputController.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/4/8.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLPopupInputController: CLPopupManagerBaseController {
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
        return contentView
    }()
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = hexColor("#40B5AA")
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    lazy var fristTextField: UITextField = {
        let fristTextField = UITextField()
        fristTextField.textAlignment = .center
        return fristTextField
    }()
    lazy var secondTextField: UITextField = {
        let secondTextField = UITextField()
        secondTextField.textAlignment = .center
        return secondTextField
    }()
    private lazy var fristLineView: UIView = {
        let fristLineView = UIView()
        fristLineView.backgroundColor = hexColor("#F0F0F0")
        return fristLineView
    }()
    private lazy var secondLineView: UIView = {
        let secondLineView = UIView()
        secondLineView.backgroundColor = hexColor("#F0F0F0")
        return secondLineView
    }()
    lazy var subTitleLabel: UILabel = {
        let subTitleLabel = UILabel()
        subTitleLabel.textAlignment = .center
        subTitleLabel.font = UIFont.systemFont(ofSize: 16)
        subTitleLabel.textColor = hexColor("#666666")
        subTitleLabel.numberOfLines = 0
        return subTitleLabel
    }()
    private lazy var sureButton: UIButton = {
        let sureButton = UIButton()
        sureButton.setTitle("确定", for: .normal)
        sureButton.setTitle("确定", for: .selected)
        sureButton.setTitle("确定", for: .highlighted)
        sureButton.setTitleColor(.white, for: .normal)
        sureButton.setTitleColor(.white, for: .selected)
        sureButton.setTitleColor(.white, for: .highlighted)
        sureButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        sureButton.backgroundColor = hexColor("#40B5AA")
        sureButton.layer.cornerRadius = 20
        sureButton.clipsToBounds = true
        return sureButton
    }()
    private lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.setImage(UIImage(named: "clear"), for: .normal)
        closeButton.setImage(UIImage(named: "clear"), for: .selected)
        closeButton.setImage(UIImage(named: "clear"), for: .highlighted)
        closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return closeButton
    }()
}
extension CLPopupInputController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        makeConstraints()
        showAnimation()
    }
}
extension CLPopupInputController {
    private func initUI() {
        view.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.00)
        view.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(fristTextField)
        contentView.addSubview(fristLineView)
        contentView.addSubview(secondTextField)
        contentView.addSubview(secondLineView)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(sureButton)
        view.addSubview(closeButton)
        titleLabel.isHidden = titleLabel.text == nil
        subTitleLabel.isHidden = subTitleLabel.text == nil
    }
    private func makeConstraints() {
        let hasTitle = titleLabel.text != nil
        let hasSubTitle = subTitleLabel.text != nil
        contentView.snp.makeConstraints { (make) in
            make.left.equalTo(36)
            make.right.equalTo(-36)
            make.bottom.equalTo(view.snp.top)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(36)
            make.left.equalTo(21)
            make.right.equalTo(-21)
        }
        fristTextField.snp.makeConstraints { (make) in
            if hasTitle {
                make.top.equalTo(titleLabel.snp.bottom).offset(36)
            }else {
                make.top.equalTo(36)
            }
            make.left.equalTo(21)
            make.right.equalTo(-21)
        }
        fristLineView.snp.makeConstraints { (make) in
            make.top.equalTo(fristTextField.snp.bottom).offset(16)
            make.left.equalTo(21)
            make.right.equalTo(-21)
            make.height.equalTo(0.5)
        }
        secondTextField.snp.makeConstraints { (make) in
            make.top.equalTo(fristLineView.snp.bottom).offset(36)
            make.left.equalTo(21)
            make.right.equalTo(-21)
        }
        secondLineView.snp.makeConstraints { (make) in
            make.top.equalTo(secondTextField.snp.bottom).offset(16)
            make.left.equalTo(21)
            make.right.equalTo(-21)
            make.height.equalTo(0.5)
        }
        subTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(secondLineView.snp.bottom).offset(22)
            make.left.equalTo(21)
            make.right.equalTo(-21)
        }
        sureButton.snp.makeConstraints { (make) in
            make.left.equalTo(70)
            make.right.equalTo(-70)
            make.height.equalTo(40)
            make.bottom.equalTo(-32)
            if hasSubTitle {
                make.top.equalTo(subTitleLabel.snp.bottom).offset(12)
            }else {
                make.top.equalTo(secondLineView.snp.bottom).offset(12)
            }
        }
        closeButton.snp.makeConstraints { (make) in
            make.size.equalTo(30)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(contentView.snp.top).offset(-15)
        }
    }
}
extension CLPopupInputController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        DispatchQueue.main.async {
            self.view.endEditing(true)
        }
    }
}
extension CLPopupInputController {
    private func showAnimation() {
        view.setNeedsLayout()
        view.layoutIfNeeded()
        contentView.snp.remakeConstraints { (make) in
            make.left.equalTo(36)
            make.right.equalTo(-36)
            make.center.equalToSuperview()
        }
        UIView.animate(withDuration: 0.35) {
            self.view.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.40)
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    private func dismissAnimation(completion: ((Bool) -> Void)? = nil) {
        contentView.snp.remakeConstraints { (make) in
            make.left.equalTo(36)
            make.right.equalTo(-36)
            make.top.equalTo(view.snp.bottom).offset(45)
        }
        UIView.animate(withDuration: 0.35, animations: {
            self.view.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.00)
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }, completion: completion)
    }
}
extension CLPopupInputController {
    @objc func closeAction() {
        dismissAnimation { (_) in
            CLPopupManager.dismissAll(false)
        }
    }
}
