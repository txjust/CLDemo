//
//  CLDrawMarqueeCollectionView.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2020/11/10.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit
import SnapKit

protocol CLDrawMarqueeCollectionViewDataSource {
    func cellForItemAtIndexPath(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
    func numberOfItems(_ collectionView: UICollectionView) -> Int
}
protocol CLDrawMarqueeCollectionViewDelegate {
    func didSelectCellAtIndexPath(_ collectionView: UICollectionView, indexPath: IndexPath)
}

class CLDrawMarqueeCollectionView: UICollectionView {
    var infiniteDataSource: CLDrawMarqueeCollectionViewDataSource?
    var infiniteDelegate: CLDrawMarqueeCollectionViewDelegate?
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        dataSource = self
        delegate = self
        backgroundColor = .white
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        decelerationRate = .fast
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLDrawMarqueeCollectionView {
    func horizontalScroll(_ offset: CGFloat) {
        guard (collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection == .horizontal else {
            return
        }
        contentOffset.x += offset
    }
    func verticalScroll(_ offset: CGFloat) {
        guard (collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection == .vertical else {
            return
        }
        contentOffset.y += offset
    }
}
extension CLDrawMarqueeCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return infiniteDataSource?.numberOfItems(self) ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return infiniteDataSource!.cellForItemAtIndexPath(self, indexPath: indexPath)
    }
}
extension CLDrawMarqueeCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        infiniteDelegate?.didSelectCellAtIndexPath(collectionView, indexPath: indexPath)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection == .horizontal {
            let contentOffsetX = scrollView.contentOffset.x
            let framWidth = bounds.width
            let sectionLength = contentSize.width / 3.0
            let contentLength = contentSize.width
            if contentOffsetX <= 0 {
                contentOffset.x = sectionLength - contentOffsetX
            } else if contentOffsetX >= contentLength - framWidth {
                contentOffset.x = contentLength - sectionLength - framWidth
            }
        }else {
            let contentOffsetY = scrollView.contentOffset.y
            let framHeight = bounds.height
            let sectionLength = contentSize.height / 3.0
            let contentLength = contentSize.height
            if contentOffsetY <= 0 {
                contentOffset.y = sectionLength - contentOffsetY
            } else if contentOffsetY >= contentLength - framHeight {
                contentOffset.y = contentLength - framHeight - sectionLength
            }
        }
    }
}

