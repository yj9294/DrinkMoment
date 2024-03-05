//
//  ChartsButtonView.swift
//  DrinkMoment
//
//  Created by Super on 2024/2/21.
//

import UIKit

class ChartsButtonView: UIView {

    private var buttons: [UIButton] = []
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    var didSelected: ((ChartsItem)->Void)? = nil
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    
    func setupUI() {
        buttons.forEach({$0.removeFromSuperview()})
        buttons = ChartsItem.allCases.compactMap({getButton($0)})
        buttons.forEach { button in
            addSubview(button)
            let index = buttons.firstIndex(of: button) ?? 0
            let width = self.bounds.width / Double(ChartsItem.allCases.count)
            let height = self.bounds.height
            button.frame = CGRect(x: 0 + width * CGFloat(index), y: 0, width: width, height: height)
        }
        buttons.first?.isSelected = true
    }
    
    func getButton(_ item: ChartsItem) -> UIButton {
        let button = UIButton()
        button.setTitle(item.title, for: .normal)
        button.setTitleColor(UIColor.init(hex: 0xB5B8C5), for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.layer.cornerRadius = 24
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button.setBackgroundImage(imageFromColor(color: UIColor(hex: 0xE53CB)), for: .selected)
        button.setBackgroundImage(imageFromColor(color: UIColor.clear), for: .normal)
        return button
    }
    
    func imageFromColor(color: UIColor, size: CGSize = CGSize(width: 100, height: 100)) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
        return image
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        for button in buttons {
            button.isSelected = button == sender
        }
        let index = buttons.firstIndex(of: sender) ?? 0
        didSelected?(ChartsItem.allCases[index])
    }
}
