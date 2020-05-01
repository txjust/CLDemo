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
        let view = CLVernierCaliperView(frame: CGRect(x: 5, y: 199, width: self.view.bounds.width - 10, height: 66), tminValue: 0.0, tmaxValue: 23.0, tstep: 0.1, tNum: 10)
        return view
    }()
}
extension CLVernierCaliperController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(vernierCaliperView)
    }
}
