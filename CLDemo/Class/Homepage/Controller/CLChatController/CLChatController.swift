//
//  CLChatController.swift
//  CLDemo
//
//  Created by JmoVxia on 2019/12/23.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

import UIKit
import Photos

class CLChatController: CLBaseViewController {
    ///图片上传路径
    private let imageUploadPath: String = pathDocuments + "/CLChatImageUpload"

    private var dataSource = [CLChatItemProtocol]()
    ///渐变色
    private lazy var gradientLayerView: CLGradientLayerView = {
        let gradientLayerView = CLGradientLayerView()
        gradientLayerView.colors = [hexColor("0x373747").cgColor, hexColor("0x22222D").cgColor]
        gradientLayerView.startPoint = CGPoint(x: 0, y: 0)
        gradientLayerView.endPoint = CGPoint(x: 0, y: 1)
        return gradientLayerView
    }()
    private lazy var tableView: CLIntrinsicTableView = {
        let tableView = CLIntrinsicTableView()
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        let panGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        panGestureRecognizer.delegate = self
        tableView.addGestureRecognizer(panGestureRecognizer)
        return tableView
    }()
    ///输入工具条
    private lazy var inputToolBar: CLChatInputToolBar = {
        let inputToolBar = CLChatInputToolBar()
        inputToolBar.delegate = self
        inputToolBar.textFont = UIFont.systemFont(ofSize: 15)
        inputToolBar.placeholder = "请输入文字..."
        return inputToolBar
    }()
}
extension CLChatController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.tintColor = UIColor.black
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        makeConstraints()
        addTipsMessage("欢迎来到本Demo")
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        inputToolBar.viewWillTransition(to: size, with: coordinator)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
extension CLChatController {
    private func initUI() {
        view.addSubview(gradientLayerView)
        view.addSubview(tableView)
        view.addSubview(inputToolBar)
    }
    private func makeConstraints() {
        gradientLayerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        inputToolBar.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
        }
        tableView.snp.makeConstraints { (make) in
            make.height.equalToSuperview().offset(-(navigationController?.navigationBar.frame.height ?? 0.0) - cl_statusBarHeight() - inputToolBar.toolBarDefaultHeight)
            make.left.right.equalTo(view)
            make.bottom.equalTo(inputToolBar.snp.top)
        }
    }
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            if self.dataSource.count >= 1 {
                let item = max(self.dataSource.count - 1, 0)
                self.tableView.scrollToRow(at: IndexPath(item: item, section: 0), at: .bottom, animated: false)
            }
        }
    }
}
extension CLChatController {
    private func addTipsMessage(_ text: String) {
        let item = CLChatTipsItem()
        item.text = text
        dataSource.append(item)
        reloadData()
    }
    private func addTextMessage(_ text: String) {
        let item = CLChatTextItem()
        item.position = .right
        item.text = text
        dataSource.append(item)
        reloadData()
    }
    private func addImageMessage(_ previewImage: UIImage, asset: PHAsset) {
        guard let previewImageData = previewImage.pngData() else {
            return
        }
        let imageItem = CLChatImageItem.init()
        imageItem.imagePath = saveUploadImage(imageData: previewImageData, messageId: (imageItem.messageId + "previewImage"))
        imageItem.imageOriginalSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
        imageItem.position = .right
        dataSource.append(imageItem)
        reloadData()
    }
}
extension CLChatController {
    func saveUploadImage(imageData: Data, messageId: String) -> String? {
        let path = imageUploadPath + "/\(messageId)"
        if !FileManager.default.fileExists(atPath: imageUploadPath) {
            try? FileManager.default.createDirectory(atPath: imageUploadPath, withIntermediateDirectories: true, attributes: nil)
        }
        if (imageData as NSData).write(toFile: path, atomically: true) {
            return path
        }
        return nil
    }
}
extension CLChatController {
    @objc func dismissKeyboard() {
        inputToolBar.dismissKeyboard()
    }
}
extension CLChatController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataSource[indexPath.row]
        let cell = item.dequeueReusableCell(tableView: tableView)
        if let tableViewCell = cell as? CLChatCellProtocol {
            tableViewCell.setItem(item)
        }
        return cell
    }
}
extension CLChatController: CLChatInputToolBarDelegate {
    func inputBarWillSendText(text: String) {
        addTextMessage(text)
    }
    func inputBarWillSendImage(image: UIImage, asset: PHAsset) {
        addImageMessage(image, asset: asset)
    }
}
extension CLChatController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let touchView = touch.view else {
            return false
        }
        let touchFrame = view.convert(touchView.frame, from: touchView.superview)
        if inputToolBar.frame.contains(touchFrame) {
            return false
        }
        return true
    }
}
