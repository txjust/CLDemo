//
//  CLChatVoiceItem.swift
//  Potato
//
//  Created by AUG on 2019/10/14.
//

import UIKit

class CLChatVoiceItem: CLChatItem {
    ///当前播放时间
    var currentDuration: TimeInterval = 0
    ///总时长
    var allDuration: TimeInterval = 0.0
    ///播放状态
    var isPlaying: Bool = false
    ///音频路径
    var path: String = ""
    ///文件id
    var fid: String = ""
    ///文件大小
    var fileSize: Int32 = 0
}
extension CLChatVoiceItem: CLChatItemProtocol {
    func tableviewCellClass() -> UITableViewCell.Type {
        return CLChatVoiceCell.self
    }
}
