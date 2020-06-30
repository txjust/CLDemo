//
//  UIImageView+Chat.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/6/30.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

extension UIImageView: CLNamespaceWrappable {}

extension CLTypeWrapperProtocol where CLWrappedType: UIImageView {
    /// 下采样设置图片
    /// - Parameters:
    ///   - path: 图片路径
    ///   - size: 采样大小
    func setImage(at path: String, for size: CGSize) {
        weak var imageView = CLWrappedValue
        CLChatImageCache.image(at: path, for: size) { (image, url) in
            if path == url {
                imageView?.image = image
            }
        }
    }
}
