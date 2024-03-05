//
//  RootVC.swift
//  DrinkMoment
//
//  Created by Super on 2024/2/20.
//

import UIKit

class RootVC: BaseVC {
    
    lazy var loading: LoadingVC = {
        return LoadingVC()
    }()
    
    lazy var tabbar: TabbarVC = {
        return TabbarVC()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(loading)
        addChild(tabbar)
        addNotification()
    }
    
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(startLoading), name: .startLoading, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(endLoading), name: .endLoading, object: nil)
    }

}

extension RootVC {
    
    override func setupUI() {
        super.setupUI()
        view.addSubview(tabbar.view)
        tabbar.view.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        view.addSubview(loading.view)
        loading.view.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
    
    @objc func startLoading() {
        view.bringSubviewToFront(loading.view)
        loading.startLoading()
    }
    
    @objc func endLoading() {
        view.bringSubviewToFront(tabbar.view)
        loading.stopLoading()
    }
}

extension Notification.Name {
    static let startLoading = Notification.Name(rawValue: "start.loading")
    static let endLoading = Notification.Name(rawValue: "end.loading")
}
