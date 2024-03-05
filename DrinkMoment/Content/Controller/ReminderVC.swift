//
//  ReminderVC.swift
//  DrinkMoment
//
//  Created by Super on 2024/2/22.
//

import UIKit

class ReminderVC: BaseVC {
    lazy var tableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(ReminderCell.classForCoder(), forCellReuseIdentifier: "ReminderCell")
        tableView.register(ReminderWeekCell.classForCoder(), forCellReuseIdentifier: "ReminderWeekCell")
        return tableView
    }()
    
    lazy var timerView: ReminderTimeView = {
        let view = ReminderTimeView(hour: Date().hour, min: Date().minute)
        view.isHidden = true
        view.dismissHandle = { [weak self] in
            view.isHidden = true
        }
        view.okHandle = { hour, min in
            view.isHidden = true
            self.appendReminder(hour: hour, min: min)
        }
        return view
    }()
    
    var datasource: [ReminderModel] = CacheUtil.shared.reminders

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationUtil.shared.register()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Reminder List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "reminder_add")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(addReminder))
        datasource.forEach({NotificationUtil.shared.appendReminder($0)})
    }
    
}

extension ReminderVC {

    override func setupUI() {
        super.setupUI()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin).offset(16)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        view.addSubview(timerView)
        timerView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
    
    func updateWeekMode(isOn: Bool) {
        CacheUtil.shared.weekMode = isOn
        datasource.forEach({NotificationUtil.shared.appendReminder($0)})
    }
    
    func deleteReminder(reminder: ReminderModel) {
        datasource = CacheUtil.shared.reminders.filter({$0 != reminder})
        CacheUtil.shared.reminders = datasource
        tableView.reloadData()
        NotificationUtil.shared.deleteNotifications(reminder)
    }
    
    func appendReminder(hour: Int, min: Int) {
        let model = ReminderModel(hour: hour, minute: min)
        datasource.append(model)
        datasource.sort { l1, l2 in
            return l1.title < l2.title
        }
        CacheUtil.shared.reminders = datasource
        NotificationUtil.shared.appendReminder(model)
        tableView.reloadData()
    }
    
    @objc func addReminder() {
        timerView.isHidden = false
    }
}

extension ReminderVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderWeekCell", for: indexPath)
            if let cell = cell as? ReminderWeekCell {
                cell.isOn = CacheUtil.shared.weekMode
                cell.weekModelHandle = { [weak self] isOn in
                    self?.updateWeekMode(isOn: isOn)
                }
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath)
        if let cell = cell as? ReminderCell {
            cell.item = datasource[indexPath.row]
            cell.deleteHandle = { [weak self] item in
                self?.deleteReminder(reminder: item)
            }
        }
        return cell
    }
    
}

class ReminderWeekCell: UITableViewCell {
    
    lazy var switchBar = {
        let switchBar = UISwitch()
        switchBar.addTarget(self, action: #selector(weekMode), for: .valueChanged)
        switchBar.tintColor = UIColor.init(hex: 0x3e3bc0)
        return switchBar
    }()
    
    var weekModelHandle: ((Bool)->Void)? = nil
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        selectionStyle = .none
        let view = UIView()
        view.backgroundColor = UIColor.init(hex: 0xF8F8FA)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().offset(-6)
            make.left.right.equalToSuperview()
        }
        
        let titleLabel = UILabel()
        titleLabel.text = "Weekend mode"
        titleLabel.textColor = UIColor.init(hex: 0x030002)
        titleLabel.font = .systemFont(ofSize: 16)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(23)
            make.left.equalToSuperview().offset(20)
        }
        

        view.addSubview(switchBar)
        switchBar.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.right.equalTo(-20)
        }
        
        let subTitle = UILabel()
        subTitle.text = "IAfter opening, you won't receive any messages on weekends"
        subTitle.font = .systemFont(ofSize: 14)
        subTitle.textColor = UIColor.init(hex: 0xB5B8C5)
        subTitle.numberOfLines = 0
        view.addSubview(subTitle)
        subTitle.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    var isOn: Bool = false {
        didSet {
            switchBar.setOn(isOn, animated: true)
        }
    }
    
    @objc func weekMode() {
        weekModelHandle?(switchBar.isOn)
    }
}

class ReminderCell: UITableViewCell {
    
    var deleteHandle: ((ReminderModel)->Void)? = nil
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = UIColor.init(hex: 0x030002)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        selectionStyle = .none
        let view = UIView()
        view.backgroundColor = UIColor.init(hex: 0xF8F8FA)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().offset(-6)
            make.left.right.equalToSuperview()
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(17)
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-17)
        }
        
        let deleteButton = UIButton()
        deleteButton.setImage(UIImage(named: "reminder_delete"), for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        view.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
        }
    }
    
    @objc func deleteAction() {
        if let item = item {
            deleteHandle?(item)
        }
    }
    
    var item: ReminderModel? = nil {
        didSet {
            titleLabel.text = item?.title
        }
    }
}

class ReminderTimeView: UIView {
    init(hour: Int, min: Int) {
        super.init(frame: .zero)
        self.hour = hour
        self.min = min
        self.setupUI()
    }
    
    var dismissHandle: (()->Void)? = nil
    var okHandle: ((Int, Int)->Void)? = nil
    
    var hour: Int = 0
    var min: Int = 0
    
    var datasource: [[Int]] = [Array(0...23), Array(0...59)]
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let dismissButton = UIButton()
        dismissButton.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        addSubview(dismissButton)
        dismissButton.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottomMargin).offset(-40)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = "Reminder time"
        titleLabel.textColor = UIColor.init(hex: 0x2F2D35)
        titleLabel.font = .systemFont(ofSize: 18)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
        }
        
        let closeButton = UIButton()
        closeButton.setImage(UIImage(named: "reminder_close"), for: .normal)
        closeButton.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        contentView.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        contentView.addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(32 * 4 + 48)
        }
        
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "reminder_button"), for: .normal)
        button.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        contentView.addSubview(button)
        button.snp.makeConstraints { make in
            make.top.equalTo(pickerView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            pickerView.selectRow(self.hour, inComponent: 0, animated: false)
            pickerView.selectRow(self.min, inComponent: 1, animated: false)
        }
    }
}

extension ReminderTimeView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        datasource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        datasource[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if let view = view as? UILabel {
            let isSelected = component == 0 ? hour == row : min == row
            view.textColor = isSelected ? UIColor.init(hex: 0x2F2D35) : UIColor.init(hex: 0x8E919B)
            view.font = isSelected ? .systemFont(ofSize: 24) : .systemFont(ofSize: 16)
            view.text = String(format: "%02d", row)
            return view
        }
        let view = UILabel()
        view.textAlignment = .center
        let isSelected = component == 0 ? hour == row : min == row
        view.textColor = isSelected ? UIColor.init(hex: 0x2F2D35) : UIColor.init(hex: 0x8E919B)
        view.font = isSelected ? .systemFont(ofSize: 24) : .systemFont(ofSize: 16)
        view.text = String(format: "%02d", row)
        return view
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 150
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            hour = row
        } else {
            min = row
        }
        pickerView.reloadAllComponents()
    }
    
    @objc func dismissAction() {
        dismissHandle?()
    }
    
    @objc func okButtonTapped() {
        okHandle?(hour, min)
    }
}
