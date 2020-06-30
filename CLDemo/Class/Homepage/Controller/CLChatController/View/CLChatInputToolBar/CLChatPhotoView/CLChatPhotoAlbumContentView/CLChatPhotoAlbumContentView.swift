//
//  CLChatAlbumContentView.swift
//  CLDemo
//
//  Created by Emma on 2020/2/11.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit
import Photos

class CLChatPhotoAlbumContentView: UIView {
    ///关闭回调
    var closeCallback: (() -> ())?
    ///数据源
    private var fetchResult: PHFetchResult<PHAsset>?
    private var selectedArray: [IndexPath] = [IndexPath]()
    /// 带缓存的图片管理对象
    private var imageManager: PHCachingImageManager = {
        let manager = PHCachingImageManager()
        manager.stopCachingImagesForAllAssets()
        return manager
    }()
    ///顶部工具条
    private lazy var topToolBar: CLChatPhotoAlbumTopBar = {
        let view = CLChatPhotoAlbumTopBar()
        view.closeCallback = {[weak self] in
            self?.closeCallback?()
        }
        return view
    }()
    ///collectionView
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.register(CLChatPhotoAlbumCell.classForCoder(), forCellWithReuseIdentifier: "CLChatPhotoAlbumCell")
        view.delegate = self
        view.dataSource = self
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    ///底部工具条
    private lazy var bottomToolBar: CLChatPhotoAlbumBottomBar = {
        let view = CLChatPhotoAlbumBottomBar()
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        makeConstraints()
        initData()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLChatPhotoAlbumContentView {
    private func initUI() {
        backgroundColor = hexColor("0x31313F")
        addSubview(topToolBar)
        addSubview(collectionView)
        addSubview(bottomToolBar)
    }
    private func makeConstraints() {
        topToolBar.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(44)
        }
        bottomToolBar.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
        collectionView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(topToolBar.snp.bottom)
            make.bottom.equalTo(bottomToolBar.snp.top)
        }
    }
    private func initData() {
        DispatchQueue.global().async {
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            self.fetchResult = PHAsset.fetchAssets(with: .image, options: options)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    private func calculateSize(with asset: PHAsset?) -> CGSize {
        guard let asset = asset else {
            return .zero
        }
        let scale = CGFloat(asset.pixelWidth) / CGFloat(asset.pixelHeight)
        let height = frame.height - 88
        return CGSize(width: height * scale, height: height)
    }
}
extension CLChatPhotoAlbumContentView {
    ///划到最左边
    func scrollToLeft(animated: Bool = true) {
        collectionView.setContentOffset(.zero, animated: animated)
    }
}
extension CLChatPhotoAlbumContentView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let index = selectedArray.firstIndex(of: indexPath) {
            selectedArray.remove(at: index)
        }else {
            selectedArray.append(indexPath)
        }
        collectionView.reloadItems(at: [indexPath])
        bottomToolBar.isCanSend = selectedArray.count > 0
    }
}
extension CLChatPhotoAlbumContentView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return calculateSize(with: fetchResult?[indexPath.row])
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}
extension CLChatPhotoAlbumContentView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CLChatPhotoAlbumCell", for: indexPath)
        if let photoAlbumCell = cell as? CLChatPhotoAlbumCell {
            photoAlbumCell.lockScollViewCallBack = {[weak self](lock) in
                self?.collectionView.isScrollEnabled = lock
            }
            photoAlbumCell.sendImageCallBack = {[weak self] (image) in
                print("发送图片 \(image)")
            }
            if let index = selectedArray.firstIndex(of: indexPath) {
                photoAlbumCell.seletedNumber = index + 1
            }else {
                photoAlbumCell.seletedNumber = 0
            }
            if let asset = fetchResult?[indexPath.row] {
                let size = calculateSize(with: asset).applying(CGAffineTransform(scaleX: UIScreen.main.scale, y: UIScreen.main.scale))
                imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: nil) { (image, info) in
                    photoAlbumCell.image = image
                }
            }
        }
        return cell
    }
}
