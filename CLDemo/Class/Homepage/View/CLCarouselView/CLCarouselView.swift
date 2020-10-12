//
//  CLCarouselView.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2020/10/12.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLCarouselView: UIView {
    /// 当前图片标示
    private var currentIndex : Int = 0
    /// 定时器
    private var timer : Timer?
    /// 图片点击回调
    var blockWithClick : ((Int) -> ())?
    /// 设定自动滚动间隔(默认三秒)
    var autoScrollDeley : TimeInterval = 15{
        didSet{
            self.removeTimer()
            self.setUpTimer()
        }
    }
    /// 装图片URL的数组
    var imageArray = [String]()
    /// 自动轮播，默认三秒
    var isAutoScroll : Bool?{
        didSet{
            if isAutoScroll == true && (imageArray.count) > 1{
                autoScrollDeley = 15
            }
        }
    }
    ///滑动视图
    private lazy var scrollView : UIScrollView = {
       let view = UIScrollView()
        view.isPagingEnabled = true
        view.bounces = false
        view.alwaysBounceVertical = false
        view.alwaysBounceHorizontal = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.delegate = self
        return view
    }()
    ///上一个cell
    private lazy var lastCell : CLCarouselCell = {
        let view = CLCarouselCell()
        return view
    }()
    ///当前cell
    private lazy var currentCell : CLCarouselCell = {
        let view = CLCarouselCell()
        return view
    }()
    ///下一个cell
    private lazy var nextCell : CLCarouselCell = {
        let view = CLCarouselCell()
        return view
    }()

    override init(frame : CGRect){
        super.init(frame: frame)
        initUI()
        makeConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

}
extension CLCarouselView {
    private func initUI(){
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageClick)))
        addSubview(scrollView)
        scrollView.addSubview(lastCell)
        scrollView.addSubview(currentCell)
        scrollView.addSubview(nextCell)
    }
    private func makeConstraints() {
        scrollView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        lastCell.snp.makeConstraints({ (make) in
            make.center.size.equalToSuperview()
        })
        currentCell.snp.makeConstraints({ (make) in
            make.size.centerY.equalToSuperview()
            make.left.equalTo(lastCell.snp.right)
        })
        nextCell.snp.makeConstraints({ (make) in
            make.size.centerY.equalToSuperview()
            make.left.equalTo(currentCell.snp.right)
        })
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.contentSize = CGSize(width: (bounds.width) * 3.0, height: 0)
        changeImage()
    }
}
extension CLCarouselView {
    private func setUpTimer(){
        timer = Timer(timeInterval: 2, target: self, selector: #selector(scrollToLast), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .common)
    }
    private func removeTimer(){
        timer?.invalidate()
        timer = nil
    }
}
extension CLCarouselView {
    @objc private func imageClick(){
        blockWithClick?(currentIndex)
    }
}
extension CLCarouselView {
    @objc func scrollToLast(){
        let offset = CGPoint(x: scrollView.contentOffset.x - bounds.width, y: 0)
        scrollView.setContentOffset(offset, animated: true)
    }
    @objc func scrollToNext(){
        let offset = CGPoint(x: scrollView.contentOffset.x + bounds.width, y: 0)
        scrollView.setContentOffset(offset, animated: true)
    }
}
extension CLCarouselView {
    private func changeImage(){
        if imageArray.count == 1 {
//            middleImageView?.image = UIImage(named: imageArray[0])
        }else {
            let left: Int = (currentIndex - 1 + imageArray.count) % imageArray.count
            let middle: Int = currentIndex
            let right: Int = (currentIndex + 1) % imageArray.count
            //给重用的三个imageView附上图片
//            leftImageView?.image = UIImage(named: imageArray[left])
//            middleImageView?.image = UIImage(named: imageArray[middle])
//            rightImageView?.image = UIImage(named: imageArray[right])
        }
        DispatchQueue.main.async {
            self.scrollView.setContentOffset(CGPoint(x:(self.bounds.width),y:0), animated: false)
        }
    }
}
extension CLCarouselView: UIScrollViewDelegate {
    /// 开始用手滚动时干掉定时器
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeTimer()
    }
    /// 用手滚动结束时重新添加定时器
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if isAutoScroll == true{
            setUpTimer()
        }
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDidEndDecelerating(scrollView)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        if offsetX >= (bounds.width) * 2 {
            currentIndex = (currentIndex + 1) % imageArray.count
            changeImage()
        }else if offsetX <= 0 {
            currentIndex = (currentIndex - 1 + imageArray.count) % imageArray.count
            changeImage()
        }
    }
}
