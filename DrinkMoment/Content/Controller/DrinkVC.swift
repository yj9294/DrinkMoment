//
//  DrinkVC.swift
//  DrinkMoment
//
//  Created by Super on 2024/2/20.
//

import UIKit

class DrinkVC: BaseVC {

    lazy var progressView: MyProgressView = {
        let progressView = MyProgressView(Double(todayDrinks) / Double(goal))
        return progressView
    }()
    
    lazy var goalLabel = {
        let goalLabel = UILabel()
        goalLabel.text = "Daily Goal \(goal)ml"
        goalLabel.textColor = .black
        goalLabel.font = .systemFont(ofSize: 16)
        return goalLabel
    }()
    
    @FileHelper(.drinks, default: [])
    var drinks: [DrinksModel]
    
    @FileHelper(.goal, default: 2000)
    var goal: Int
    
    var todayDrinks: Int {
        drinks.filter({$0.date.isToday}).map({$0.ml}).reduce(0, +)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNotification()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "drink_title")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: nil)
    }
    
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateDrinks), name: .updateDrinks, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateGoal), name: .updateGoal, object: nil)
    }
    
    @objc func updateGoal(noti: Notification) {
        if let obj = noti.object as? Int {
            goal = obj
            goalLabel.text = "Daily Goal \(goal)ml"
            progressView.progress = Double(todayDrinks) / Double(goal)
        }
    }
    
    @objc func updateDrinks(noti: Notification) {
        if let obj = noti.object as? [DrinksModel] {
            drinks = obj
            progressView.progress = Double(todayDrinks) / Double(goal)
        }
    }
}

extension DrinkVC {
    override func setupUI() {
        super.setupUI()
        
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.init(hex: 0xC7C9D3)
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.text = "Drinking water on time is a good habit"
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.left.equalToSuperview().offset(21)
        }
        
        let contentBackground = UIImageView(image: UIImage(named: "drink_bg"))
        contentBackground.contentMode = .scaleAspectFill
        view.addSubview(contentBackground)
        contentBackground.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.bottom.equalTo(contentBackground.snp.bottom).offset(-30)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(36)
        }
        
        let goalView = UIView()
        goalView.backgroundColor = UIColor(hex: 0xEDF0FF)
        goalView.layer.cornerRadius = 12
        goalView.layer.masksToBounds = true
        view.addSubview(goalView)
        goalView.snp.makeConstraints { make in
            make.top.equalTo(contentBackground.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(64)
        }
        
        let recordView = UIView()
        recordView.backgroundColor = UIColor(hex: 0x3E53CB)
        recordView.layer.cornerRadius = 12
        recordView.layer.masksToBounds = true
        view.addSubview(recordView)
        recordView.snp.makeConstraints { make in
            make.top.equalTo(goalView)
            make.left.equalTo(goalView.snp.right).offset(8)
            make.height.equalTo(64)
            make.width.equalTo(124)
            make.right.equalToSuperview().offset(-20)
        }
        
        let goal = UIView()
        goalView.addSubview(goal)
        goal.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        goal.addSubview(goalLabel)
        goalLabel.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
        }
        
        let goalIcon = UIImageView(image: UIImage(named: "drink_edit"))
        goal.addSubview(goalIcon)
        goalIcon.snp.makeConstraints { make in
            make.left.equalTo(goalLabel.snp.right).offset(8)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        let record = UIView()
        recordView.addSubview(record)
        record.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        let recordLabel = UILabel()
        recordLabel.text = "Add to"
        recordLabel.textColor = .white
        recordLabel.font = .systemFont(ofSize: 16)
        record.addSubview(recordLabel)
        recordLabel.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
        }
        
        let recordIcon = UIImageView(image: UIImage(named: "drink_add"))
        record.addSubview(recordIcon)
        recordIcon.snp.makeConstraints { make in
            make.centerY.right.equalToSuperview()
            make.left.equalTo(recordLabel.snp.right).offset(8)
        }
        
        let recordButton = UIButton()
        recordButton.addTarget(self, action: #selector(toRecordVC), for: .touchUpInside)
        recordView.addSubview(recordButton)
        recordButton.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        let goalButton = UIButton()
        goalButton.addTarget(self, action: #selector(toGoalVC), for: .touchUpInside)
        goalView.addSubview(goalButton)
        goalButton.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
}

extension DrinkVC {
    
    @objc func toGoalVC() {
        let vc = GoalVC()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func toRecordVC() {
        let vc = RecordVC()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension Notification.Name {
    static let updateDrinks = Notification.Name(rawValue: "update.drinks")
    static let updateGoal = Notification.Name(rawValue: "update.goal")
}
