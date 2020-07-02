//
//  CLChatVoiceCell.swift
//  Potato
//
//  Created by AUG on 2019/10/14.
//

import UIKit

class CLChatVoiceCell: CLChatCell {
    ///背景气泡
       var bubbleImageView = UIImageView()
       ///左侧气泡
       private lazy var leftBubbleImage: UIImage = {
           var image = UIImage.init(named: "icon_message_l_bg")!
           image = image.resizableImage(withCapInsets: UIEdgeInsets.init(top: image.size.height * 0.5, left: image.size.width * 0.5, bottom: image.size.height * 0.5, right: image.size.width * 0.5))
           return image
       }()
       ///右侧气泡
       private lazy var rightBubbleImage: UIImage = {
           var image = UIImage.init(named: "icon_message_r_bg")!
           image = image.resizableImage(withCapInsets: UIEdgeInsets.init(top: image.size.height * 0.5, left: image.size.width * 0.5, bottom: image.size.height * 0.5, right: image.size.width * 0.5))
           return image
       }()
}
extension CLChatVoiceCell {
    override func initUI() {
        super.initUI()
        contentView.addSubview(bubbleImageView)
    }
}
extension CLChatVoiceCell {
    private func remakeConstraints(isFromMyself: Bool) {
        bubbleImageView.snp.remakeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(10)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10).priority(.high)
            if isFromMyself {
                make.right.equalTo(contentView.snp.right).offset(-10)
            }else {
                make.left.equalTo(contentView.snp.left).offset(10)
            }
            make.height.equalTo(40)
            make.width.equalTo(0)
        }
        bottomContentView.snp.remakeConstraints { (make) in
            make.edges.equalTo(bubbleImageView)
        }
    }
}
extension CLChatVoiceCell: CLChatCellProtocol {
    func setItem(_ item: CLChatItemProtocol) {
        guard let item = item as? CLChatVoiceItem else {
            return
        }
        self.item = item
        let isFromMyself: Bool = item.position == .right
        bubbleImageView.image = isFromMyself ? rightBubbleImage : leftBubbleImage
        remakeConstraints(isFromMyself: isFromMyself)
        var width: CGFloat = 5
        width = CGFloat(floor(Double(item.duration))) * width + 55
        width = max(min(width, cl_screenWidth() * 0.45), 60)
        bubbleImageView.snp.updateConstraints { (make) in
            make.width.equalTo(width)
        }
    }
}
