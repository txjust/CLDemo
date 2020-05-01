//
//  CLVernierCaliperView.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/5/1.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLVernierCaliperView: UIView {
    var section: Int = 0
    var textFont: UIFont = UIFont.systemFont(ofSize: 14)
    ///间隔值，每两条相隔多少值
    var gap: CGFloat = 12
    var long: CGFloat  = 30.0
    var short: CGFloat = 15.0
    var triangleWidth: CGFloat = 14.0
    var unit:String = ""
    var minValue:CGFloat = 0.0
    var maxValue:CGFloat = 0.0
    ///最小单位
    var minimumUnit: CGFloat = 0.0
    ///单位间隔
    var unitInterval:Int = 0
    var indexValueCallback: ((CGFloat) -> ())?
    lazy var collectionView: UICollectionView = {[unowned self]in
        let flowLayout              = UICollectionViewFlowLayout()
        flowLayout.scrollDirection  = .horizontal
        flowLayout.sectionInset     = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collectionView: UICollectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 6, width: self.bounds.size.width, height: self.bounds.height - 6), collectionViewLayout: flowLayout)
        collectionView.backgroundColor    = UIColor.hexColor(with: "#F7F7F7")
        collectionView.bounces            = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator   = false
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView.register(CLVernierCaliperHeaderCell.self, forCellWithReuseIdentifier: "CLVernierCaliperHeaderCell")
        collectionView.register(CLVernierCaliperFooterCell.self, forCellWithReuseIdentifier: "CLVernierCaliperFooterCell")
        collectionView.register(CLVernierCaliperMiddleCell.self, forCellWithReuseIdentifier: "CLVernierCaliperMiddleCell")
        return collectionView
    }()
    lazy var indexView: CLIndexView = {
        let view = CLIndexView()
        view.frame = CGRect(x: (bounds.width - triangleWidth) * 0.5, y: 0, width: triangleWidth, height: bounds.height)
        view.lineHeight = long + 6
        view.backgroundColor = UIColor.clear
        view.triangleColor = UIColor.hexColor(with: "#2DD178")
        return view
    }()
    init(frame: CGRect, minValue:CGFloat, maxValue:CGFloat, minimumUnit:CGFloat, unitInterval:Int) {
        super.init(frame: frame)
        self.unitInterval  = unitInterval
        self.minValue = minValue
        self.maxValue = maxValue
        self.minimumUnit = minimumUnit
        section = Int((maxValue - minValue) / minimumUnit) / unitInterval
        
        self.backgroundColor = UIColor.white
        self.addSubview(self.collectionView)
        self.addSubview(self.indexView)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLVernierCaliperView {
    private func setRealValue(realValue:CGFloat, animated:Bool) {
        collectionView.setContentOffset(CGPoint.init(x: Int(realValue) * Int(gap), y: 0), animated:  animated)
    }
    func setValue(value:CGFloat, animated:Bool){
        collectionView.setContentOffset(CGPoint.init(x: Int((value - minValue) / minimumUnit) * Int(gap), y: 0), animated: animated)
    }
}
extension CLVernierCaliperView:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2 + self.section
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CLVernierCaliperHeaderCell", for: indexPath)
            if let cell = cell as? CLVernierCaliperHeaderCell {
                cell.backgroundColor = UIColor.clear
                cell.headerMinValue = minValue
                cell.headerUnit = unit
                cell.long = long
                cell.textFont = textFont
            }
            return cell
        }else if indexPath.item == section + 1 {
            let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CLVernierCaliperFooterCell", for: indexPath)
            if let cell = cell as? CLVernierCaliperFooterCell {
                cell.backgroundColor = UIColor.clear
                cell.footerMaxValue = maxValue
                cell.footerUnit = unit
                cell.long = long
                cell.textFont = textFont
            }
            return cell
        }else{
            let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CLVernierCaliperMiddleCell", for: indexPath)
            if let cell = cell as? CLVernierCaliperMiddleCell {
                cell.backgroundColor = UIColor.clear
                cell.step = minimumUnit
                cell.unit = unit
                cell.betweenNumber = unitInterval;
                cell.minValue = minimumUnit * CGFloat((indexPath.item - 1)) * CGFloat(unitInterval) + minValue
                cell.maxValue = minimumUnit * CGFloat(indexPath.item) * CGFloat(unitInterval)
                cell.textFont = textFont
                cell.gap = gap
                cell.long = long
                cell.short = short
                cell.setNeedsDisplay()
            }
            return cell
        }
    }
}
extension CLVernierCaliperView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = Int(scrollView.contentOffset.x / CGFloat(gap))
        let totalValue = CGFloat(value) * minimumUnit + minValue
        indexValueCallback?(totalValue)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.setRealValue(realValue: (scrollView.contentOffset.x) / (gap),  animated: true)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.setRealValue(realValue: (scrollView.contentOffset.x) / (gap),  animated: true)
    }
}
extension CLVernierCaliperView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 || indexPath.item == section + 1 {
            return CGSize(width: self.frame.width * 0.5, height: collectionView.frame.height)
        }
        return CGSize(width: gap * CGFloat(unitInterval), height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
