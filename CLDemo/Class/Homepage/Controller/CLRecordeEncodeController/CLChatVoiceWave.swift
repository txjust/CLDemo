//
//  CLChatVoiceWave.swift
//  Potato
//
//  Created by AUG on 2019/10/15.
//

import UIKit

@objcMembers class CLChatVoiceWave: UIView {
    ///峰值高度
    var peakHeight: CGFloat = 12.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    ///颜色
    var color: UIColor = .orange {
        didSet {
            if oldValue != color {
                setNeedsDisplay()
            }
        }
    }
    ///数据
    var waveData: Data? {
        didSet {
            if oldValue != waveData {
                setNeedsDisplay()
            }
        }
    }
}

extension CLChatVoiceWave {
    override func draw(_ rect: CGRect) {
        let sampleWidth: CGFloat = 1.0
        let halfSampleWidth: CGFloat = 1.0
        let distance: CGFloat = 1.0
        
        let size = bounds.size
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setFillColor(color.cgColor)
        
        if let data = waveData {
            let samples = Array(data)
            let maxReadSamples = samples.count
            let scale: CGFloat = CGFloat(max(samples.max() ?? 0, 1))
            
            let numSamples: Int = Int(floorf(Float(frame.size.width / (sampleWidth + distance))))
            var adjustedSamples: [UInt8] = [UInt8].init(repeating: 0, count: numSamples * 2)
            
            for i in 0..<maxReadSamples {
                let index: Int = i * numSamples / maxReadSamples
                let sample: UInt8 = samples[i]
                
                if (adjustedSamples[index] < sample) {
                    adjustedSamples[index] = sample
                }
            }
            
            for i in 0..<numSamples {
                let offset = CGFloat(i) * (sampleWidth + distance)
                let peakSample = adjustedSamples[i]
                
                var sampleHeight: CGFloat = CGFloat(peakSample) * peakHeight / scale
                if (abs(sampleHeight) > peakHeight) {
                    sampleHeight = peakHeight
                }
                
                let adjustedSampleHeight: CGFloat = sampleHeight - sampleWidth
                if (adjustedSampleHeight <= sampleWidth + CGFloat.ulpOfOne) {
                    context.fillEllipse(in: .init(x: offset, y: size.height - sampleWidth, width: sampleWidth, height: sampleWidth))
                    context.fill(.init(x: offset, y: size.height - halfSampleWidth, width: sampleWidth, height: halfSampleWidth))
                } else {
                    let adjustedRect = CGRect.init(x: offset,
                                                   y: size.height - adjustedSampleHeight,
                                                   width: sampleWidth,
                                                   height: adjustedSampleHeight)
                    context.fill(adjustedRect)
                    context.fillEllipse(in: .init(x: adjustedRect.origin.x,
                                                  y: adjustedRect.origin.y - halfSampleWidth,
                                                  width: sampleWidth,
                                                  height: sampleWidth))
                    context.fillEllipse(in: .init(x: adjustedRect.origin.x,
                                                  y: adjustedRect.origin.y + adjustedRect.size.height - halfSampleWidth,
                                                  width: sampleWidth,
                                                  height: sampleWidth))
                }
            }
            
        }else {
            context.fill(.init(x: halfSampleWidth, y: size.height - sampleWidth, width: size.width - sampleWidth, height: sampleWidth))
            context.fillEllipse(in: .init(x: 0.0, y: size.height - sampleWidth, width: sampleWidth, height: sampleWidth))
            context.fillEllipse(in: .init(x: size.width - sampleWidth, y: size.height - sampleWidth, width: sampleWidth, height: sampleWidth))
        }
    }
}
