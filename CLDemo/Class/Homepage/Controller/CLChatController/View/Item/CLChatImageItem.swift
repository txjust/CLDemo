//
//  CLChatImageItem.swift
//  Potato
//
//  Created by AUG on 2019/10/14.
//

import UIKit

class CLChatImageItem: CLChatItem {
    ///图片原始大小
    var imageOriginalSize = CGSize.zero {
        didSet {
            size = calculateScaleFrame(imageSize: imageOriginalSize, maxSize: CGSize(width: 270, height: 270), minSize: CGSize(width: 151.5, height: 151.5))
        }
    }
    ///图片缩放后大小
    private (set) var size = CGSize.zero
    ///图片本地地址
    var imagePath: String?
    ///文件id
    var fid: String = ""
    ///文件大小
    var fileSize: Int32 = 0
}
extension CLChatImageItem: CLChatItemProtocol {
    func tableviewCellClass() -> UITableViewCell.Type {
        return CLChatImageCell.self
    }
}
extension CLChatImageItem {
    private func calculateScaleFrame(imageSize: CGSize, maxSize: CGSize, minSize: CGSize) -> CGSize {
        var width: CGFloat = 0.0
        var height: CGFloat = 0.0
        
        let maxWidth = maxSize.width
        let maxHeight = maxSize.height
        let minWidth = minSize.width
        let minHeight = minSize.height
        
        let imageWidth = imageSize.width
        let imageHeight = imageSize.height
        
        let widthSatisfy: Bool = minWidth <= imageWidth && imageWidth <= maxWidth
        let heightSatisfy: Bool = minHeight <= imageHeight && imageHeight <= maxHeight

        if widthSatisfy && heightSatisfy {
            return imageSize
        }
        
        let widthSpace = fabsf(Float(maxWidth - imageWidth))
        let heightSpace = fabsf(Float(maxHeight - imageHeight))
        
        if (widthSpace >= heightSpace) {
            if (maxWidth > imageWidth) {
                width = imageWidth * (maxHeight / imageHeight)
                height = imageHeight * (maxHeight / imageHeight)
            }else {
                width = imageWidth / (imageWidth / maxWidth)
                height = imageHeight / (imageWidth / maxWidth)
            }
        }else {
            if (maxHeight > imageHeight) {
                width = imageWidth * (maxWidth / imageWidth)
                height = imageHeight * (maxWidth / imageWidth)
            }else {
                width = imageWidth / (imageHeight / maxHeight)
                height = imageHeight / (imageHeight / maxHeight)
            }
        }
        
        var size = CGSize(width: width, height: height)

        if ((maxWidth - width) * 0.5 < 0 || (maxHeight - height) * 0.5 < 0) {
            size = calculateScaleFrame(imageSize: CGSize(width: width, height: height), maxSize: maxSize, minSize: minSize)
        }
        
//        if (size.height > size.width && size.width < minWidth) {
//            let minWidth: CGFloat = minWidth
//            width = imageWidth * (minWidth / imageWidth)
//            height = min(imageHeight * (minWidth / imageWidth), maxHeight)
//            size = CGSize(width: width, height: height)
//        }
//
//        if (size.width > size.height && size.height < minHeight) {
//            let minHeight: CGFloat = minHeight
//            height = imageHeight * (minHeight / imageHeight)
//            width = min(imageWidth * (minHeight / imageHeight), maxWidth)
//            size = CGSize(width: width, height: height)
//        }
//        return CGSize(width: width, height: height)
        return size
    }
}

