//
//  CLInfiniteCollectionView.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2020/11/4.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit
import SnapKit

protocol CLInfiniteCollectionViewDataSource {
    func cellForItemAtIndexPath(_ collectionView: UICollectionView, dequeueIndexPath: IndexPath, index: Int) -> UICollectionViewCell
    func numberOfItems(_ collectionView: UICollectionView) -> Int
}
protocol CLInfiniteCollectionViewDelegate {
    func didSelectCellAtIndexPath(_ collectionView: UICollectionView, index: Int)
}

class CLInfiniteCollectionView: UICollectionView {
    var infiniteDataSource: CLInfiniteCollectionViewDataSource?
    var infiniteDelegate: CLInfiniteCollectionViewDelegate?
    
    var isHorizontalScroll: Bool = true
    private var indexOffset: Int = 0
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
extension CLInfiniteCollectionView {
    func scrollToLeftItem() {
        guard isHorizontalScroll, let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let centerOffsetX = contentOffset.x - (layout.itemSize.width + layout.minimumLineSpacing)
        setContentOffset(CGPoint(x: centerOffsetX, y: 0), animated: true)
    }
    func scrollToRightItem() {
        guard isHorizontalScroll, let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let centerOffsetX = contentOffset.x + (layout.itemSize.width + layout.minimumLineSpacing)
        setContentOffset(CGPoint(x: centerOffsetX, y: 0), animated: true)
    }
    func scrollToTopItem() {
        guard !isHorizontalScroll, let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let centerOffsetY = contentOffset.y + (layout.itemSize.height + layout.minimumLineSpacing)
        setContentOffset(CGPoint(x: 0, y: centerOffsetY), animated: true)
    }
    func scrollToBottomItem() {
        guard !isHorizontalScroll, let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let centerOffsetY = contentOffset.y - (layout.itemSize.height + layout.minimumLineSpacing)
        setContentOffset(CGPoint(x: 0, y: centerOffsetY), animated: true)
    }
}
extension CLInfiniteCollectionView {
    private func centreIfNeeded() {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let currentOffset = contentOffset
        let contentWidth = getTotalContentWidth()
        let centerOffsetX: CGFloat = (3 * contentWidth - bounds.size.width) * 0.5
        let distFromCentre = centerOffsetX - currentOffset.x
        if abs(distFromCentre) > (contentWidth * 0.25) {
            let cellcount = distFromCentre / (layout.itemSize.width + layout.minimumLineSpacing)
            let shiftCells = Int((cellcount > 0) ? floor(cellcount) : ceil(cellcount))
            let offsetCorrection = abs(cellcount).truncatingRemainder(dividingBy: 1) * (layout.itemSize.width + layout.minimumLineSpacing)
            if contentOffset.x < centerOffsetX {
                contentOffset = CGPoint(x: centerOffsetX - offsetCorrection, y: currentOffset.y)
            }else if contentOffset.x > centerOffsetX {
                contentOffset = CGPoint(x: centerOffsetX + offsetCorrection, y: currentOffset.y)
            }
            shiftContentArray(getCorrectedIndex(shiftCells))
            reloadData()
        }
    }
    private func centreVerticallyIfNeeded() {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let currentOffset = contentOffset
        let contentHeight = getTotalContentHeight()
        let centerOffsetY: CGFloat = (3 * contentHeight  - bounds.size.height) * 0.5
        let distFromCentre = centerOffsetY - currentOffset.y
        if abs(distFromCentre) > (contentHeight * 0.25) {
            let cellcount = distFromCentre / (layout.itemSize.height + layout.minimumLineSpacing)
            let shiftCells = Int((cellcount > 0) ? floor(cellcount) : ceil(cellcount))
            let offsetCorrection = abs(cellcount).truncatingRemainder(dividingBy: 1) * (layout.itemSize.height + layout.minimumLineSpacing)
            if contentOffset.y < centerOffsetY {
                contentOffset = CGPoint(x: currentOffset.x, y: centerOffsetY - offsetCorrection)
            }else if contentOffset.y > centerOffsetY {
                contentOffset = CGPoint(x: currentOffset.x, y: centerOffsetY + offsetCorrection)
            }
            shiftContentArray(getCorrectedIndex(shiftCells))
            reloadData()
        }
    }
    private func shiftContentArray(_ offset: Int) {
        indexOffset += offset
    }
    private func getTotalContentWidth() -> CGFloat {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout, let numberOfCells = infiniteDataSource?.numberOfItems(self) else { return 0 }
        return CGFloat(numberOfCells) * (layout.itemSize.width + layout.minimumLineSpacing)
    }
    private func getTotalContentHeight() -> CGFloat {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout, let numberOfCells = infiniteDataSource?.numberOfItems(self) else { return 0 }
        return (CGFloat(numberOfCells) * (layout.itemSize.height + layout.minimumLineSpacing))
    }
    private func getCorrectedIndex(_ indexToCorrect: Int) -> Int {
        guard let numberOfCells = infiniteDataSource?.numberOfItems(self) else { return 0 }
        if (indexToCorrect < numberOfCells && indexToCorrect >= 0) {
            return indexToCorrect
        }else {
            let countInIndex = Float(indexToCorrect) / Float(numberOfCells)
            let flooredValue = Int(floor(countInIndex))
            let offset = numberOfCells * flooredValue
            return indexToCorrect - offset
        }
    }
}
extension CLInfiniteCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems = infiniteDataSource?.numberOfItems(self) ?? 0
        return  3 * numberOfItems
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return infiniteDataSource!.cellForItemAtIndexPath(self, dequeueIndexPath: indexPath, index: getCorrectedIndex(indexPath.row - indexOffset))
    }
}
extension CLInfiniteCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        infiniteDelegate?.didSelectCellAtIndexPath(self, index: getCorrectedIndex(indexPath.row - indexOffset))
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        isHorizontalScroll ? centreIfNeeded() : centreVerticallyIfNeeded()
    }
}
