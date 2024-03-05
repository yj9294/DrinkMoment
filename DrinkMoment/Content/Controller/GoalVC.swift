//
//  GoalVC.swift
//  DrinkMoment
//
//  Created by Super on 2024/2/20.
//

import UIKit

class GoalVC: BaseVC {
    
    lazy var sliderView = {
        let sliderView = UISlider()
        sliderView.setThumbImage(UIImage(named: "goal_point"), for: .normal)
        sliderView.maximumTrackTintColor = UIColor.init(hex: 0x020202)
        sliderView.tintColor = UIColor(hex: 0x3E53CB)
        sliderView.layer.cornerRadius = 7
        sliderView.layer.masksToBounds = true
        sliderView.addTarget(self, action: #selector(updateGoal), for: .valueChanged)
        return sliderView
    }()
    
    lazy var goalLabel = {
        let goalLabel = UILabel()
        goalLabel.textColor = .black
        goalLabel.text = "\(goal)"
        goalLabel.font = .systemFont(ofSize: 28)
        return goalLabel
    }()
    
    var goal: Int = FileHelper.getValueFor(.goal, defaultValue: 2000) {
        didSet {
            sliderView.value = Float(goal) / 4000.0
            goalLabel.text = "\(goal)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Drinking water setting"
        sliderView.value = Float(goal) / 4000.0
    }
    
}

extension GoalVC {
    override func setupUI() {
        super.setupUI()
        
        let contentBackgroundView = UIImageView(image: UIImage(named: "goal_bg"))
        contentBackgroundView.contentMode = .scaleAspectFill
        view.addSubview(contentBackgroundView)
        contentBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin).offset(30)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        let goalView = UIView()
        goalView.backgroundColor = .white
        goalView.layer.cornerRadius = 14
        goalView.layer.masksToBounds = true
        goalView.layer.borderColor = UIColor(hex: 0x020202).cgColor
        goalView.layer.borderWidth = 2
        view.addSubview(goalView)
        goalView.snp.makeConstraints { make in
            make.bottom.equalTo(contentBackgroundView).offset(-20)
            make.left.equalToSuperview().offset(42)
            make.right.equalToSuperview().offset(-42)
            make.height.equalTo(64)
        }
        
        goalView.addSubview(goalLabel)
        goalLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        let unitLabel = UILabel()
        unitLabel.text = "ml"
        unitLabel.textColor = UIColor(hex: 0xB5B8C5)
        unitLabel.font = .systemFont(ofSize: 16)
        goalView.addSubview(unitLabel)
        unitLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
        }
        
        let substrctButton = UIButton()
        substrctButton.setImage(UIImage(named: "goal_-"), for: .normal)
        substrctButton.addTarget(self, action: #selector(substrct), for: .touchUpInside)
        view.addSubview(substrctButton)
        substrctButton.snp.makeConstraints { make in
            make.top.equalTo(contentBackgroundView.snp.bottom).offset(28)
            make.left.equalToSuperview().offset(20)
        }
        
        let addButton = UIButton()
        addButton.setImage(UIImage(named: "goal_+"), for: .normal)
        addButton.addTarget(self, action: #selector(add), for: .touchUpInside)
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.centerY.equalTo(substrctButton)
            make.right.equalToSuperview().offset(-20)
        }
        
        
        view.addSubview(sliderView)
        sliderView.snp.makeConstraints { make in
            make.centerY.equalTo(substrctButton)
            make.left.equalTo(substrctButton.snp.right).offset(10)
            make.right.equalTo(addButton.snp.left).offset(-10)
        }
        
        let button = UIButton()
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor(hex: 0x3E53CB)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("OK", for: .normal)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-100)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(64)
        }
        
    }
    
    @objc func substrct() {
        goal -= 100
        if goal < 100 {
            goal = 100
        }
    }
    
    @objc func add() {
        goal += 100
        if goal > 4000 {
            goal = 4000
        }
    }
    
    @objc func updateGoal() {
        let p = Int(sliderView.value * 4000) / 100 * 100
        if p == 0 {
            goal = 100
            return
        }
        goal = p
    }
    
    @objc func saveButtonTapped() {
        FileHelper.setValueFor(.goal, value: goal)
        NotificationCenter.default.post(name: .updateGoal, object: goal)
        navigationController?.popViewController(animated: true)
    }
}
