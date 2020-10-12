//
//  CLBroadcastViewController.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2020/10/12.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLBroadcastViewController: CLBaseViewController {
    private lazy var arrayDS: [String] = {
        var array = [String]()
        array.append("我是第一个")
        array.append("我是第二个")
        array.append("我是第三个")
        array.append("我是第四个")
        array.append("我是第五个")
        array.append("我是第六个")
        array.append("我是第七个")
        return array
    }()
    private lazy var broadcastView: CLBroadcastView = {
        let view = CLBroadcastView()
        view.register(CLBroadcastMainCell.self, forCellReuseIdentifier: "CLBroadcastMainCell")
        view.delegate = self
        view.dataSource = self
        view.tag = 0
        return view
    }()
    private lazy var broadcastView1: CLBroadcastView = {
        let view = CLBroadcastView()
        view.register(CLBroadcastMainCell.self, forCellReuseIdentifier: "CLBroadcastMainCell")
        view.delegate = self
        view.dataSource = self
        view.tag = 1
        return view
    }()
    private lazy var broadcastView2: CLBroadcastView = {
        let view = CLBroadcastView()
        view.register(CLBroadcastMainCell.self, forCellReuseIdentifier: "CLBroadcastMainCell")
        view.delegate = self
        view.dataSource = self
        view.tag = 2
        return view
    }()
    private lazy var timer: CLGCDTimer = {
        let gcdTimer = CLGCDTimer(interval: 3, delaySecs: 3) {[weak self] (_) in
            self?.scrollToNext()
        }
        return gcdTimer
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        makeConstraints()
        reloadData()
    }
}
extension CLBroadcastViewController {
    func initUI() {
        view.addSubview(broadcastView)
        view.addSubview(broadcastView1)
        view.addSubview(broadcastView2)
    }
    func makeConstraints() {
        broadcastView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        broadcastView1.snp.makeConstraints { (make) in
            make.top.equalTo(broadcastView.snp.bottom)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        broadcastView2.snp.makeConstraints { (make) in
            make.top.equalTo(broadcastView1.snp.bottom)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
    }
    func reloadData() {
        broadcastView.reloadData()
        broadcastView1.reloadData()
        broadcastView2.reloadData()
        timer.start()
    }
    func scrollToNext() {
        broadcastView.scrollToNext()
        broadcastView1.scrollToNext()
        broadcastView2.scrollToNext()
    }
}
extension CLBroadcastViewController: CLBroadcastViewDelegate {
    func broadcastView(_ broadcast: CLBroadcastView, didSelect index: Int) {
        print("点击\(index)")
    }
}
extension CLBroadcastViewController: CLBroadcastViewDataSource {
    func broadcastViewRows(_ broadcast: CLBroadcastView) -> Int {
        return arrayDS.count
    }
    func broadcastView(_ broadcast: CLBroadcastView, cellForRowAt index: Int) -> CLBroadcastCell {
        let cell = broadcast.dequeueReusableCell(withIdentifier: "CLBroadcastMainCell")
        cell.backgroundColor = UIColor.red.withAlphaComponent(0.35)
        let currentIndex = (index + broadcast.tag) % self.arrayDS.count
        (cell as? CLBroadcastMainCell)?.adText = arrayDS[currentIndex]
        return cell
    }
}
