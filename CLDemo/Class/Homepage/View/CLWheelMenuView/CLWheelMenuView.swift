//
//  CLWheelMenuView.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2020/12/1.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

protocol CLWheelMenuViewDelegate: NSObjectProtocol {
    func wheelMenuView(_ view: CLWheelMenuView, didSelectItem: CLMenuItem)
}

class CLWheelMenuView: UIView {
    var centerButtonRadius: CGFloat = 32 {
        didSet {
            updateCenterButton()
        }
    }
    var menuBackGroundColor: UIColor = .red {
        didSet {
            menuLayers.forEach { $0.fillColor = menuBackGroundColor.cgColor }
        }
    }
    var boarderColor: UIColor = UIColor(white: 1.0, alpha: 1) {
        didSet {
            menuLayers.forEach { $0.strokeColor = boarderColor.cgColor }
        }
    }
    var animationDuration: CGFloat = 0.35
    weak var delegate: CLWheelMenuViewDelegate?
    fileprivate(set) var openMenu: Bool = true
    fileprivate(set) var selectedIndex = 0
    fileprivate var startPoint = CGPoint.zero
    fileprivate var menuLayers = [CLMenuLayer]()
    fileprivate var currentAngle: CGFloat {
        let angle = 2 * CGFloat(Double.pi) / CGFloat(menuLayers.count)
        return CGFloat(menuLayers.count - selectedIndex) * angle
    }
    var centerButtonCustomImage: UIImage? {
        didSet {
            updateCenterButton()
        }
    }
    private lazy var centerButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .white
        view.addTarget(self, action: #selector(centerButtonAction), for: .touchUpInside)
        return view
    }()
    var items = [CLMenuItem]() {
        didSet {
            creatMenu()
        }
    }
    private lazy var menuBaseView: UIView = {
        let view = UIView()
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        view.addGestureRecognizer(pan)
        view.addGestureRecognizer(tap)
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(menuBaseView)
        addSubview(centerButton)
        menuBaseView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        centerButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(centerButtonRadius * 2)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func creatMenu() {
        setNeedsLayout()
        layoutIfNeeded()
        menuLayers.forEach{ $0.removeFromSuperlayer() }
        let angle = 2 * CGFloat(Double.pi) / CGFloat(items.count)
        for (index, item) in items.enumerated() {
            let startAngle = CGFloat(index) * angle - angle / 2 - CGFloat(Double.pi / 2)
            let endAngle   = CGFloat(index + 1)  * angle - angle / 2 - CGFloat(Double.pi / 2) + 0.005
            let center     = CGPoint(x: bounds.width/2, y: bounds.height/2)
            
            var transform = CATransform3DMakeRotation(angle * CGFloat(index), 0, 0, 1)
            transform = CATransform3DTranslate(transform, 0, -bounds.width/3, 0)
            let menuLayer = CLMenuLayer(center: center, radius: bounds.width/2, startAngle: startAngle, endAngle: endAngle, item: item, bounds: bounds, contentsTransform: transform, selectedImage: item.selectedImage, image: item.image)
            
            menuLayer.strokeColor = boarderColor.cgColor
            menuLayer.fillColor   = item.fillColor.cgColor
            menuLayer.selected    = index == selectedIndex
            menuBaseView.layer.addSublayer(menuLayer)
            createHoleIn(view : menuBaseView, radius: centerButtonRadius + 10)
            menuLayers.append(menuLayer)
        }
    }
    func createHoleIn(view : UIView, radius: CGFloat)   {
        let path = CGMutablePath()
        path.addArc(center: view.center, radius: radius, startAngle: 0.0, endAngle: 2.0 * .pi, clockwise: false)
        path.addRect(CGRect(origin: .zero, size: view.frame.size))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path
        maskLayer.fillRule = .evenOdd
        view.layer.mask = maskLayer
        view.clipsToBounds = true
    }
}
extension CLWheelMenuView {
    func updateCenterButton() {
        centerButton.layer.cornerRadius = centerButtonRadius
        centerButton.setImage(centerButtonCustomImage, for: .normal)
    }
    @objc func centerButtonAction() {
        openMenu ? closeMenuView() : openMenuView()
    }
    func openMenuView() {
        openMenu = true
        UIView.animate(withDuration: TimeInterval(animationDuration),
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 5.0,
            options: [],
            animations: {
                self.centerButton.transform = .identity
                self.centerButton.setImage(UIImage(named: "Vector"), for: .normal)
                self.menuBaseView.transform = CGAffineTransform(scaleX: 1, y: 1).rotated(by: self.currentAngle)
            },
            completion: nil
        )
    }
    func closeMenuView() {
        openMenu = false
        let scale = (centerButtonRadius * 2) / bounds.width
        UIView.animate(withDuration: TimeInterval(animationDuration),
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 5.0,
            options: [],
            animations: {
                self.centerButton.transform = CGAffineTransform(rotationAngle: .pi * 0.5)
                self.centerButton.setImage(UIImage(named: "Menu"), for: .normal)
                self.menuBaseView.transform = CGAffineTransform(scaleX: scale, y: scale).rotated(by: self.currentAngle)
            },
            completion: nil
        )
    }
    @objc func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        let location = sender.location(in: self)
        switch sender.state {
        case .began:
            startPoint = location
        case .changed:
            let radian1 = -atan2(
                startPoint.x - menuBaseView.center.x,
                startPoint.y - menuBaseView.center.y)
            let radian2 = -atan2(
                location.x - menuBaseView.center.x,
                location.y - menuBaseView.center.y)
            menuBaseView.transform = menuBaseView.transform.rotated(by: radian2 - radian1)
            startPoint = location
        default:
            let angle         = 2 * CGFloat(Double.pi) / CGFloat(menuLayers.count)
            var menuViewAngle = atan2(menuBaseView.transform.b, menuBaseView.transform.a)
            
            if menuViewAngle < 0 {
                menuViewAngle += CGFloat(2 * Double.pi)
            }
            
            var index = menuLayers.count - Int((menuViewAngle + CGFloat(Double.pi / 4)) / angle)
            if index == menuLayers.count {
                index = 0
            }
            setSelectedIndex(index, animated: true)
            delegate?.wheelMenuView(self, didSelectItem: items[index])
        }
    }
    @objc func handleTapGesture(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: menuBaseView)
        for (index, menuLayer) in menuLayers.enumerated() {
            let touchInLayer = menuLayer.path?.contains(location) ?? false
            if touchInLayer {
                setSelectedIndex(index, animated: true)
                delegate?.wheelMenuView(self, didSelectItem: items[index])
                return
            }
        }
    }

    public func setSelectedIndex(_ index: Int, animated: Bool) {
        selectedIndex = index
        let duration  = animated ? TimeInterval(animationDuration) : 0
        UIView.animate(withDuration: TimeInterval(duration),
            animations: {
                self.menuBaseView.transform =
                    CGAffineTransform(rotationAngle: self.currentAngle)
            },
            completion: { _ in
                self.menuLayers.enumerated().forEach {
                    $0.element.selected = $0.offset == index
                }
            }
        )
    }

}
