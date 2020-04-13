//
//  CLPopupFoodPickerHeaderView.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/4/13.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLPopupFoodPickerHeaderView: UIView {
    var dataArray: [String] = [String]() {
        didSet {
            collectionView.reloadData()
        }
    }
    var index: Int = 0 {
        didSet {
            animation(row: index)
        }
    }
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(CLPopupFoodPickerHeaderCell.self, forCellWithReuseIdentifier: "CLPopupFoodPickerHeaderCell")
        return collectionView
    }()
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = hexColor("#40B5AA")
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        makeConstraints()
        index = 0
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLPopupFoodPickerHeaderView {
    private func initUI() {
        addSubview(collectionView)
    }
    private func makeConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
extension CLPopupFoodPickerHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CLPopupFoodPickerHeaderCell", for: indexPath)
        if let cell = cell as? CLPopupFoodPickerHeaderCell {
            cell.titleLabel.text = dataArray[indexPath.row]
        }
        return cell
    }
}
extension CLPopupFoodPickerHeaderView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        animation(row: indexPath.row)
    }
}

extension CLPopupFoodPickerHeaderView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let string = dataArray[indexPath.row]
        let width = string.boundingRect(with: CGSize(width: 0, height: 50), options: .usesLineFragmentOrigin, attributes: [
            NSAttributedString.Key.font: PingFangSCBold(16)
        ], context: nil).size.width
        return CGSize(width: width + 20, height: 50)
    }
}
extension CLPopupFoodPickerHeaderView {
    func animation(row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        guard let cell = collectionView.cellForItem(at: indexPath) as? CLPopupFoodPickerHeaderCell else {
            return
        }
        let frame = cell.titleLabel.convert(cell.titleLabel.bounds, to: self)
        if lineView.superview != nil {
            lineView.snp.remakeConstraints { (make) in
                make.bottom.equalToSuperview()
                make.height.equalTo(2)
                make.left.equalTo(frame.minX)
                make.width.equalTo(frame.width)
            }
            UIView.animate(withDuration: 0.35) {
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
        }else {
            addSubview(lineView)
            lineView.snp.makeConstraints { (make) in
                make.bottom.equalToSuperview()
                make.height.equalTo(2)
                make.left.equalTo(frame.minX)
                make.width.equalTo(frame.width)
            }
        }
    }
}
