//
//  CLDrawMarqueeController.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2020/11/9.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit
import SnapKit

//MARK: - JmoVxia---类-属性
class CLDrawMarqueeController: CLBaseViewController {
    let array = ["漫漫秋夜长，烈烈北风凉。",
                 "展转不能寐，披衣起彷徨。",
                 "彷徨忽已久，白露沾我裳。",
                 "俯视清水波，仰看明月光。",
                 "天汉回西流，三五正纵横。",
                 "草虫鸣何悲，孤雁独南翔。",
                 "郁郁多悲思，绵绵思故乡。",
                 "愿飞安得翼，欲济河无梁。",
                 "向风长叹息，断绝我中肠。",
                 "西北有浮云，亭亭如车盖。",
                 "惜哉时不遇，适与飘风会。",
                 "吹我东南行，行行至吴会。",
                 "吴会非吾乡，安能久留滞。",
                 "弃置勿复陈，客子常畏人。",]
    private var index: Int = 0
    private lazy var marqueeView: CLDrawMarqueeView = {
        let view = CLDrawMarqueeView(direction: .right)
        view.delegate = self
        view.backgroundColor = UIColor.orange.withAlphaComponent(0.35)
        return view
    }()
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
    }
}
//MARK: - JmoVxia---生命周期
extension CLDrawMarqueeController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        makeConstraints()
        initData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}
//MARK: - JmoVxia---布局
private extension CLDrawMarqueeController {
    func initUI() {
        view.addSubview(marqueeView)
    }
    func makeConstraints() {
        marqueeView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(100)
        }
    }
}
//MARK: - JmoVxia---数据
private extension CLDrawMarqueeController {
    func initData() {
        marqueeView.setText(array.first!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.marqueeView.startAnimation()
        }
    }
}
extension CLDrawMarqueeController: CLDrawMarqueeViewDelegate {
    func drawMarqueeView(view: CLDrawMarqueeView, animationDidStopFinished finished: Bool) {
        if finished {
            index = (index + 1) % array.count
            view.setText(array[index])
        }
    }
}
