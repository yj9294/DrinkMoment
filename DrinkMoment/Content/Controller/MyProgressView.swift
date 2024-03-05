//
//  MyProgressView.swift
//  DrinkMoment
//
//  Created by Super on 2024/2/20.
//

import UIKit

class MyProgressView: UIView, UIGestureRecognizerDelegate {
    
    lazy var buttonView: UIView = {
        let view = UIView()
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
//        panGesture.delegate = self
//        view.addGestureRecognizer(panGesture)
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        label.text = "\(Int(progress * 100))%"
        return label
    }()
    
    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor(hex: 0x8427FF).cgColor, UIColor(hex: 0xDC42FF).cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        return layer
    }()
    
    var progress: Double = 0.0 {
        didSet {
            if progress > 1.0 {
                progress = 1.0
            }
            label.text = "\(Int(progress * 100))%"
            buttonView.frame = CGRect(x: progress * (self.bounds.width) - 30 , y: 0, width: 60, height: 36)
            gradientLayer.frame = CGRect(x: 0, y: 0, width: progress * self.bounds.width, height: 14)
        }
    }
    
    init(_ progress: Double = 0.0) {
        super.init(frame: .zero)
        self.progress = progress
        if progress >= 1.0 {
            self.progress = 1.0
        }
        setupUI()
    }
    
    func setupUI() {
        let contentView = UIView()
        contentView.backgroundColor =  UIColor.init(hex: 0x020202)
        contentView.layer.cornerRadius = 7
        contentView.layer.masksToBounds = true
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(14)
        }
        
        contentView.layer.addSublayer(gradientLayer)
        
        addSubview(buttonView)
        
        buttonView.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        buttonView.frame = CGRect(x: progress * (self.bounds.width) - 30 , y: 0, width: 60, height: 36)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: progress * self.bounds.width, height: 14)
    }
    
//    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
//        let translation = gesture.translation(in: self)
//
//        var x = buttonView.center.x + translation.x
//        if x < 30 {
//            x = 30
//        }
//        if x > self.bounds.width - 30 {
//            x = self.bounds.width - 30
//        }
//        // 只更新视图的水平位置
//        buttonView.center = CGPoint(x: x, y: buttonView.center.y)
//
//        // 重置手势的位移，以便在下一次调用时计算相对位移
//        gesture.setTranslation(CGPoint.zero, in: self)
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
