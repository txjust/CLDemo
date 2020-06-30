//
//  CLChatImageCache.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/6/30.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLChatImageCache: NSObject {
    static let shared: CLChatImageCache = CLChatImageCache()
    ///图片队列
    private var imageQueue: DispatchQueue = DispatchQueue(label: "CLChatImageCache-imageQueue", attributes: .concurrent)
    ///缓存
    private let cache = NSCache<AnyObject, AnyObject>().then { (cache) in
        cache.countLimit = 120
    }
    private override init() {
        super.init()
    }
    ///异步获取图片
    class func image(at url: String, for size: CGSize, callBack: @escaping((UIImage?, String) -> ())) {
        let md5Key = url + NSCoder.string(for: size).md5ForUpper32Bate
        shared.imageQueue.async {
            if let cacheImage = shared.cache.object(forKey: md5Key as AnyObject) as? UIImage {
                DispatchQueue.main.async {
                    callBack(cacheImage, url)
                }
            }else {
                let scaleFactor = UIScreen.main.scale
                let scale = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
                let scaleSize = size.applying(scale)
                let image = ImageIO.resizedImageWithHintingAndSubsampling(at: URL.init(fileURLWithPath: url), for: scaleSize)
                shared.cache.setObject(image as AnyObject, forKey: md5Key as AnyObject)
                DispatchQueue.main.async {
                    callBack(image, url)
                }
            }
        }
    }
    ///同步获取图片
    class func image(at url: String, for size: CGSize) -> UIImage? {
        let md5Key = url + NSCoder.string(for: size).md5ForUpper32Bate
        if let cacheImage = shared.cache.object(forKey: md5Key as AnyObject) as? UIImage {
            return cacheImage
        }else {
            let scaleFactor = UIScreen.main.scale
            let scale = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
            let scaleSize = size.applying(scale)
            let image = ImageIO.resizedImageWithHintingAndSubsampling(at: URL.init(fileURLWithPath: url), for: scaleSize)
            shared.cache.setObject(image as AnyObject, forKey: md5Key as AnyObject)
            return image
        }
    }
}
