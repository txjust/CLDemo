//
//  CLDrawMarqueeView.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2020/11/9.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit
import SnapKit

protocol CLDrawMarqueeViewDelegate {
    func drawMarqueeView(view: CLDrawMarqueeView, animationDidStopFinished finished: Bool)
}
extension CLDrawMarqueeViewDelegate {
    func drawMarqueeView(view: CLDrawMarqueeView, animationDidStopFinished finished: Bool) {
        
    }
}

//MARK: - JmoVxia---枚举
extension CLDrawMarqueeView {
    enum Direction {
        case left
        case right
    }
}
//MARK: - JmoVxia---类-属性
class CLDrawMarqueeView: UIView {
    var delegate: CLDrawMarqueeViewDelegate?
    var speed: CGFloat = 2
    var direction: Direction = .left
    private var stoped: Bool = false
    private var animationViewWidth: CGFloat {
        return label.bounds.width
    }
    private var animationViewHeight: CGFloat {
        return label.bounds.height
    }
    private lazy var label: UILabel = {
        let view = UILabel()
        return view
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
//MARK: - JmoVxia---布局
private extension CLDrawMarqueeView {
    func initUI() {
        layer.masksToBounds = true
        addSubview(label)
    }
    func makeConstraints() {
        label.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(snp.right)
        }
    }
}
//MARK: - JmoVxia---公共方法
extension CLDrawMarqueeView {
    func setText(_ text: String) {
        label.text = text
        label.sizeToFit()
    }
    func startAnimation() {
        label.layer.removeAnimation(forKey: "animationViewPosition")
        stoped = false
        let pointRightCenter = CGPoint(x: bounds.width + animationViewWidth * 0.5, y: animationViewHeight * 0.5)
        let pointLeftCenter = CGPoint(x: -animationViewWidth * 0.5, y: animationViewHeight * 0.5)
        let fromPoint = direction == .left ? pointRightCenter : pointLeftCenter
        let toPoint = direction == .left ? pointLeftCenter  : pointRightCenter
        
        label.center = fromPoint
        
        let movePath = UIBezierPath()
        movePath.move(to: fromPoint)
        movePath.addLine(to: toPoint)
        
        let moveAnimation = CAKeyframeAnimation(keyPath: "position")
        moveAnimation.path = movePath.cgPath
        moveAnimation.isRemovedOnCompletion = true
        moveAnimation.timingFunctions = [CAMediaTimingFunction(name: .linear)]
        moveAnimation.duration = CFTimeInterval(animationViewWidth / 30 * (1 / speed))
        moveAnimation.delegate = self
        label.layer.add(moveAnimation, forKey: "animationViewPosition")
    }
    func stopAnimation() {
        stoped = true
        label.layer.removeAnimation(forKey: "animationViewPosition")
    }
    func pauseAnimation() {
        
    }
    func resumeAnimation() {
        
    }
}
extension CLDrawMarqueeView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        delegate?.drawMarqueeView(view: self, animationDidStopFinished: flag)
        if (flag && !stoped) {
            startAnimation()
        }
    }
}
