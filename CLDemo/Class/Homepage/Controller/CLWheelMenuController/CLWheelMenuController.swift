//
//  CLWheelMenuController.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2020/12/1.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLWheelMenuController: CLBaseViewController {
    private lazy var wheelMenuView: CLWheelMenuView = {
        let view = CLWheelMenuView()
        view.centerButtonCustomImage = UIImage(named: "Menu")
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.orange
        view.addSubview(wheelMenuView)
        wheelMenuView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(200)
        }
        var items = [CLMenuItem]()
        for _ in 0...3 {
            let item = CLMenuItem()
            item.image = UIImage(named: "Group 199")
            item.selectedImage = UIImage(named: "Group 199")
            items.append(item)
        }
        wheelMenuView.items = items
        // Do any additional setup after loading the view.
    }
}
