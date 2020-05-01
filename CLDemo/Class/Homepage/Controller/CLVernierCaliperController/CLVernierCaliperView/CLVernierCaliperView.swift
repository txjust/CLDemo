//
//  CLVernierCaliperView.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/5/1.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLVernierCaliperView: UIView {
    //分多少个大区
    var stepNum = 0
    var textFont: UIFont = UIFont.systemFont(ofSize: 14)
    var gap: CGFloat = 12
    var long: CGFloat  = 30.0
    var short: CGFloat = 15.0
    var triangleWidth: CGFloat = 14.0
    var unit:String = ""
    var minValue:CGFloat = 0.0
    var maxValue:CGFloat = 0.0
    //间隔值，每两条相隔多少值
    var step: CGFloat = 0.0
    var betweenNum:Int = 0
    var indexValueCallback: ((CGFloat) -> ())?
    private var fileRealValue: CGFloat = 0.0
    init(frame: CGRect, tminValue:CGFloat, tmaxValue:CGFloat, tstep:CGFloat, tNum:Int) {
        super.init(frame: frame)
        minValue    = tminValue
        maxValue    = tmaxValue
        betweenNum  = tNum
        step        = tstep
        stepNum     = Int((tmaxValue - tminValue)/step)/betweenNum
        
        self.backgroundColor    = UIColor.white
        self.addSubview(self.collectionView)
        self.addSubview(self.indexView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var valueLable: UILabel = {
        let view = UILabel()
        view.textColor = .white
        return view
    }()
    lazy var collectionView: UICollectionView = {[unowned self]in
        let flowLayout              = UICollectionViewFlowLayout()
        flowLayout.scrollDirection  = .horizontal
        flowLayout.sectionInset     = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collectionView: UICollectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.height), collectionViewLayout: flowLayout)
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
        view.frame = CGRect(x: 0, y: 0, width: triangleWidth, height: bounds.height)
        view.lineHeight = CGFloat(long)
        view.backgroundColor = UIColor.clear
        view.triangleColor = UIColor.hexColor(with: "#2DD178")
        return view
    }()
    
    
    func setRealValueAndAnimated(realValue:CGFloat,animated:Bool){
        fileRealValue = realValue
        valueLable.text = String.init(format: "%.2f", fileRealValue*step+minValue)
        collectionView.setContentOffset(CGPoint.init(x: Int(realValue)*Int(gap), y: 0), animated: animated)
    }
    
    func setDefaultValueAndAnimated(defaultValue:CGFloat,animated:Bool){
        fileRealValue = defaultValue
        valueLable.text = String.init(format: "%.2f", defaultValue)
        collectionView.setContentOffset(CGPoint.init(x: Int((defaultValue-minValue)/step) * Int(gap), y: 0), animated: animated)
    }
}

extension CLVernierCaliperView:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2 + stepNum
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CLVernierCaliperHeaderCell", for: indexPath)
            if let cell = cell as? CLVernierCaliperHeaderCell {
                cell.backgroundColor  = UIColor.clear
                cell.headerMinValue   = minValue
                cell.headerUnit       = unit
                cell.textFont = textFont
            }
            return cell
        }else if indexPath.item == stepNum+1 {
            let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CLVernierCaliperFooterCell", for: indexPath)
            if let cell = cell as? CLVernierCaliperFooterCell {
                cell.backgroundColor  = UIColor.clear
                cell.footerMaxValue   = maxValue
                cell.footerUnit       = unit
                cell.textFont = textFont
            }
            return cell
        }else{
            let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CLVernierCaliperMiddleCell", for: indexPath)
            if let cell = cell as? CLVernierCaliperMiddleCell {
                cell.backgroundColor   = UIColor.clear
                cell.step              = step
                cell.unit              = unit
                cell.betweenNumber     = betweenNum;
                cell.minValue = step * CGFloat((indexPath.item - 1)) * CGFloat(betweenNum) + minValue
                cell.maxValue = step * CGFloat(indexPath.item) * CGFloat(betweenNum)
                cell.textFont = textFont
                cell.setNeedsDisplay()
            }
            return cell
        }
    }
}
extension CLVernierCaliperView:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = Int(scrollView.contentOffset.x / CGFloat(gap))
        let totalValue = CGFloat(value) * step + minValue
        indexValueCallback?(totalValue)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.setRealValueAndAnimated(realValue: (scrollView.contentOffset.x) / (gap), animated: true)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.setRealValueAndAnimated(realValue: (scrollView.contentOffset.x) / (gap), animated: true)
    }
}
extension CLVernierCaliperView:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 || indexPath.item == stepNum + 1 {
            return CGSize(width: self.frame.size.width * 0.5, height: bounds.height)
        }
        return CGSize(width: gap * CGFloat(betweenNum), height: bounds.height)
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
