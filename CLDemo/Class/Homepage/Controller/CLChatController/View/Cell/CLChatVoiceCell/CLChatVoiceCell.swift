//
//  CLChatVoiceCell.swift
//  Potato
//
//  Created by AUG on 2019/10/14.
//

import UIKit

class CLChatVoiceCell: CLChatCell {
    ///背景
    private lazy var voiceBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .hexColor(with: "0x4A4A6A")
        view.clipsToBounds = true
        view.layer.cornerRadius = 6
        return view
    }()
    ///播放背景
    private lazy var playButton: UIButton = {
        let view = UIButton()
        view.adjustsImageWhenHighlighted = false
//        view.setImage(PTImageSVG.voiceImageNormal, for: .normal)
//        view.setImage(PTImageSVG.voiceImageSelected, for: .selected)
        view.addTarget(self, action: #selector(playOrPause(button:)), for: .touchUpInside)
        return view
    }()
    ///音频
//    private lazy var voiceView: CLVoiceView = {
//        let view = CLVoiceView()
//        view.peakHeight = 21.5
//        return view
//    }()
    ///线条
//    private lazy var lineView: CLLineWave = {
//        let view = CLLineWave()
//        return view
//    }()
    ///时间
    private lazy var timeLabel: UILabel = {
        let view = UILabel()
        view.textColor = .hexColor(with: "0xBABAE2")
        view.font = .systemFont(ofSize: 10)
        return view
    }()
    ///进度
    private lazy var progressView: CLChatImageProgressView = {
        let progressView = CLChatImageProgressView.init(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        return progressView
    }()
    ///下载按钮
    private lazy var downloadFailButton: UIButton = {
        let downloadFailButton = UIButton()
//        downloadFailButton.setImage(PTImageSVG.knockDownloadIcon, for: .normal)
//        downloadFailButton.setImage(PTImageSVG.knockDownloadIcon, for: .selected)
//        downloadFailButton.setImage(PTImageSVG.knockDownloadIcon, for: .highlighted)
        downloadFailButton.addTarget(self, action: #selector(downloadFailButtonAction), for: .touchUpInside)
        return downloadFailButton
    }()
    ///当前时间
    private var currentSeconds: TimeInterval = 0
}
extension CLChatVoiceCell {
    override func initUI() {
        super.initUI()
        contentView.addSubview(voiceBackgroundView)
        voiceBackgroundView.addSubview(playButton)
//        voiceBackgroundView.addSubview(voiceView)
//        voiceBackgroundView.addSubview(lineView)
        voiceBackgroundView.addSubview(timeLabel)
        voiceBackgroundView.addSubview(progressView)
        voiceBackgroundView.addSubview(downloadFailButton)
    }
}
extension CLChatVoiceCell: CLChatCellProtocol {
    func setItem(_ item: CLChatItemProtocol) {
        guard let voiceItem = item as? CLChatVoiceItem else {
            return
        }
        updateUI(item: voiceItem)
        remakeConstraints(isFromMyself: voiceItem.position == .right)
    }
}
extension CLChatVoiceCell {
    private func updateUI(item: CLChatVoiceItem) {
        self.item = nil
        self.item = item

        let progress = max(min(1, item.currentDuration / item.allDuration), 0.0)
//        voiceView.progress = progress
//        lineView.progress = progress
        
//        voiceView.waveData = item.waveData

        let isFromMyself: Bool = item.position == .right
        playButton.isHidden = isFromMyself ? false : item.messageReceiveState != .downloadSucess
        progressView.isHidden = isFromMyself
        downloadFailButton.isHidden = !(!isFromMyself && item.messageReceiveState == .downloadFail)
        if !downloadFailButton.isHidden {
            item.progress = 0.0
            progressView.updateProgress(value: 0.0)
            progressView.isHidden = true
        }else {
            if !isFromMyself {
                progressView.updateProgress(value: item.progress)
            }
        }
        timeLabel.text = durationFromSeconds(item.currentDuration , allDuration: item.allDuration)
        timeLabel.sizeToFit()
        
        playButton.isSelected = item.isPlaying
    }

    private func remakeConstraints(isFromMyself: Bool) {
        voiceBackgroundView.snp.remakeConstraints { (make) in
            make.top.equalTo(10)
            make.bottom.equalTo(-10).priority(.high)
            make.width.equalTo(cl_screenWidth() * 0.5)
            make.height.equalTo(70)
            if isFromMyself {
                make.right.equalTo(-10)
            }else {
                make.left.equalTo(10)
            }
        }
        bottomContentView.snp.remakeConstraints { (make) in
            make.edges.equalTo(voiceBackgroundView)
        }
        playButton.snp.remakeConstraints { (make) in
            make.size.equalTo(CGSize(width: 45, height: 45))
            make.centerY.equalTo(voiceBackgroundView)
            make.left.equalTo(10)
        }
        progressView.snp.remakeConstraints { (make) in
            make.edges.equalTo(playButton)
        }
        downloadFailButton.snp.remakeConstraints { (make) in
            make.edges.equalTo(playButton)
        }
//        timeLabel.snp.remakeConstraints { (make) in
//            make.left.equalTo(playButton.snp.right).offset(10)
//            make.right.equalTo(voiceBackgroundView.snp.right).offset(-10)
//            make.height.equalTo(15)
//            make.top.equalTo(lineView.snp.bottom).offset(5)
//        }
    }
    private func durationFromSeconds(_ seconds: TimeInterval, allDuration: TimeInterval) -> String? {
        currentSeconds = seconds
        return "\(currentSeconds.minuteSecond)/\(allDuration.minuteSecond)"
    }
}
extension CLChatVoiceCell {
    @objc private func playOrPause(button: UIButton) {
        guard let voiceItem = item as? CLChatVoiceItem else {
            return
        }
        if button.isSelected {
//            presenter?.pauseVoiceWithItem(voiceItem)
        }else {
//            presenter?.playVoiceWithItem(voiceItem)
        }
        button.isSelected = !button.isSelected
        voiceItem.isPlaying = button.isSelected
    }
    @objc private func downloadFailButtonAction() {
        guard let voiceItem = item as? CLChatVoiceItem  else {return}
        voiceItem.messageReceiveState = .downloading
        setItem(voiceItem)
//        presenter?.reTryDownloadVoiceWithItem(voiceItem)
    }
}
