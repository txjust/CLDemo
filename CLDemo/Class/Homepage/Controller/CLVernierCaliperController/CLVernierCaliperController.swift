//
//  CLVernierCaliperController.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/5/1.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLVernierCaliperController: CLBaseViewController {
    lazy var vernierCaliperView: CLVernierCaliperView = {
        let view = CLVernierCaliperView(frame: CGRect(x: 5, y: 199, width: self.view.bounds.width - 10, height: 66), minValue: 0.0, maxValue: 23.0, minimumUnit: 0.1, unitInterval: 10)
        view.setValue(value: 2.0, animated: true)
        view.indexValueCallback = {(value) in
            print("====== \(value) ======")
        }
        return view
    }()
}
extension CLVernierCaliperController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(vernierCaliperView)
    }
}
