//
//  CLTagsCell.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/4/5.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLTagsCell: UITableViewCell {
    private var viewArray: [UILabel] = [UILabel]()
    var tagsItem: CLTagsItem? {
        didSet {
            reSetTags()
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.layer.borderColor = UIColor.orange.cgColor
        contentView.layer.borderWidth = 1
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CLTagsCell {
        func reSetTags() {
            guard let tagsItem = tagsItem else {
                return
            }
            let count = max(tagsItem.tags.count, viewArray.count)
            for i in 0..<count {
                var label: UILabel!
                if i < viewArray.count {
                    label = viewArray[i]
                }else {
                    label = UILabel()
                    label.textAlignment = .center
                    label.textColor = UIColor.randomColor
                    label.font = tagsItem.font
                    label.backgroundColor = UIColor.white
                    label.layer.borderWidth = 1
                    label.layer.borderColor = UIColor.lightGray.cgColor
                    label.layer.cornerRadius = 4
                    label.layer.masksToBounds = true
                    contentView.addSubview(label)
                    viewArray.append(label)
                }
                if i < tagsItem.tags.count {
                    label.isHidden = false
                    label.text = tagsItem.tags[i]
                    label.frame = tagsItem.tagsFrames[i]
                }else {
                    label.isHidden = true
                }
            }
        }
}


