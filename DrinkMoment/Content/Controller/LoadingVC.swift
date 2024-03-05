//
//  LoadingVC.swift
//  DrinkMoment
//
//  Created by Super on 2024/2/20.
//

import UIKit

class LoadingVC: BaseVC {
    
    lazy var progressView = {
        let progressView = UIProgressView()
        progressView.tintColor = UIColor.init(hex: 0x4963FF)
        progressView.backgroundColor = UIColor.init(hex: 0xf6f6f8)
        progressView.layer.masksToBounds = true
        progressView.layer.cornerRadius = 2.5
        return progressView
    }()
    
    var timer: Timer? = nil

    var duration = 3.5
    var progress = 0.0 {
        didSet {
            progressView.progress = Float(progress)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        startLoading()
    }

    func startLoading() {
        timer?.invalidate()
        self.progress = 0.0
        self.duration = 2.8
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [weak self] timer in
            guard let self = self else { return }
            let progress = self.progress + 0.01 / self.duration
            if progress > 1.0 {
                self.progress = 1.0
                timer.invalidate()
                NotificationCenter.default.post(name: .endLoading, object: true)
            } else {
                self.progress = progress
            }
        })
    }
    
    func stopLoading()  {
        timer?.invalidate()
    }
}

extension LoadingVC {
    override func setupUI() {
        super.setupUI()
        
        let icon = UIImageView(image: UIImage(named: "loading_icon"))
        view.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.snp.topMargin).offset(160)
        }
        
        let title = UIImageView(image: UIImage(named: "loading_title"))
        view.addSubview(title)
        title.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(48)
            make.right.equalToSuperview().offset(-48)
            make.height.equalTo(5)
            make.bottom.equalTo(view.snp.bottom).offset(-40)
        }
        
    }
}
