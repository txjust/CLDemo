//
//  CLPopupFoodPickerView.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/4/13.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit
import SwiftyJSON

class CLPopupFoodPickerView: UIView {
    var foodModel: CLPopupFoodPickerModel?
    private var titleAttay = [String]()
    private var buttonArray = [UIButton]()
    private lazy var clipView: UIView = {
        let clipView = UIView()
        clipView.backgroundColor = UIColor.clear
        clipView.clipsToBounds = true
        return clipView
    }()
    private lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = hexColor("#40B5AA")
        return lineView
    }()
    private lazy var showView: UIView = {
        let showView = UIView()
        showView.backgroundColor = UIColor.clear
        return showView
    }()
    private lazy var contentView: UIScrollView = {
        let contentView = UIScrollView()
        contentView.showsHorizontalScrollIndicator = false
        contentView.showsVerticalScrollIndicator = false
        contentView.isPagingEnabled = true
        contentView.delegate = self
        contentView.bounces = false
        if #available(iOS 11.0, *) {
            contentView.contentInsetAdjustmentBehavior = .never
        }
        return contentView
    }()
    private var seleceButton: UIButton!
    private var lastOffsetX: CGFloat = 0.0
    private var lastX: CGFloat = 0.0
    init(frame: CGRect, titleArray :[String]) {
        super.init(frame: frame)
        self.titleAttay = titleArray
        initData()
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLPopupFoodPickerView {
    func initData() {
        DispatchQueue.global().async {
            let path = Bundle.main.path(forResource: "food", ofType: "json")
            let url = URL(fileURLWithPath: path!)
            if let data = try? Data(contentsOf: url), let json = try? JSON(data: data) {
                self.foodModel = CLPopupFoodPickerModel(json: json)
            }
        }
    }
    private func initUI() {
        let width: CGFloat = (frame.width) / 4.0
        let height: CGFloat = 40;
        var lastButton: UIButton?
        for item in titleAttay {
            let button = creatButton(title: item, titleColor: hexColor("#333333"))
            button.addTarget(self, action: #selector(buttonClickAction(_:)), for: .touchUpInside)
            addSubview(button)
            let x: CGFloat = lastButton?.frame.maxX ?? 0
            button.setFrame(CGRect(x: x, y: 0, width: width, height: height))
            lastButton = button
            buttonArray.append(button)
            
            let topButton = creatButton(title: item, titleColor: hexColor("#40B5AA"))
            topButton.isUserInteractionEnabled = false
            topButton.setFrame(button.frame)
            showView.addSubview(topButton)
        }
        
        addSubview(contentView)
        contentView.setFrame(CGRect(x: 0, y: height, width: frame.width, height: frame.height - height))
        contentView.contentSize = CGSize(width: contentView.frame.width * 4.0, height: contentView.frame.height)

        seleceButton(buttonArray.first!)

        addSubview(clipView)
        clipView.setFrame(seleceButton.frame)
        
        clipView.addSubview(showView)
        showView.setFrame(CGRect(x: 0, y: 0, width: frame.width, height: height))
        
        clipView.addSubview(lineView)
        lineView.setFrame(CGRect(x: clipView.frame.width * 0.1, y: clipView.frame.height - 2, width: clipView.frame.width * 0.8, height: 2))
    }
    private func seleceButton(_ button: UIButton) {
        if seleceButton != button {
            seleceButton = button
            let index = buttonArray.firstIndex(of: seleceButton) ?? 0
            contentView.setContentOffset(CGPoint(x: CGFloat(index) * frame.width, y: 0), animated: true)
            if !seleceButton.isSelected {
                let view = CLPopupFoodPickerContentView()
                view.frame = CGRect(x: CGFloat(index) * contentView.frame.width, y: 0, width: contentView.frame.width, height: contentView.frame.height);
                contentView.addSubview(view)
                button.isSelected = true
            }
        }
    }
    private func creatButton(title: String, titleColor: UIColor) -> UIButton {
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.setTitle(title, for: .normal)
        button.setTitle(title, for: .selected)
        button.setTitleColor(titleColor, for: .selected)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = PingFangSCBold(16)
        return button
    }
}
extension CLPopupFoodPickerView {
    @objc private func buttonClickAction(_ button: UIButton) {
        seleceButton(button)
    }
}
extension CLPopupFoodPickerView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = ((scrollView.contentOffset.x - lastOffsetX) / scrollView.frame.width) * clipView.frame.width + lastX
        clipView.setFrame(CGRect(x: min(max(x, 0), scrollView.frame.width - clipView.frame.width), y: clipView.frame.minY, width: clipView.frame.width, height: clipView.frame.height))
        showView.setFrame(CGRect(x: -min(max(x, 0), scrollView.frame.width - clipView.frame.width), y: showView.frame.minY, width: showView.frame.width, height: showView.frame.height))
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.frame.width)
        seleceButton(buttonArray[index])
        lastOffsetX = scrollView.contentOffset.x
        lastX = seleceButton.frame.minX
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
    }
}
