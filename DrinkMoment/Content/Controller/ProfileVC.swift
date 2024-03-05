//
//  ProfileVC.swift
//  DrinkMoment
//
//  Created by Super on 2024/2/20.
//

import UIKit

class ProfileVC: BaseVC {
    
    var datasource: [[ProfileItem]] = [[.reminder, .privacy, .rate], [.tip1, .tip2, .tip3]]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "profile_title")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: nil)
    }
}

extension ProfileVC {
    override func setupUI() {
        super.setupUI()
        
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(ProfileCell.classForCoder(), forCellReuseIdentifier: "ProfileCell")
        tableView.register(TipCell.classForCoder(), forCellReuseIdentifier: "TipCell")
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
        }
    }
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        datasource.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        datasource[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath)
            if let cell = cell as? ProfileCell {
                cell.item = datasource[indexPath.section][indexPath.row]
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "TipCell", for: indexPath)
        if let cell = cell as? TipCell {
            cell.item = datasource[indexPath.section][indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let vc = ReminderVC()
                vc.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.row == 1 {
                let vc = PrivacyVC()
                vc.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc, animated: true)
            } else {
                if let url = URL(string: "itms-apps://itunes.apple.com/cn/app/6478917939") {
                    UIApplication.shared.open(url)
                }
            }
        } else {
            let vc = TipVC(datasource[indexPath.section][indexPath.row])
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

class ProfileCell: UITableViewCell {
    lazy var title: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(hex: 0x030002)
        label.font = .systemFont(ofSize: 16)
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
        self.selectionStyle = .none

        let centerView = UIView()
        centerView.backgroundColor = UIColor.init(hex: 0xF8F8FA)
        centerView.layer.cornerRadius = 12
        centerView.layer.masksToBounds = true
        addSubview(centerView)
        centerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-6)
        }
        
        addSubview(title)
        title.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        let arrow = UIImageView(image: UIImage(named: "arrow_down"))
        addSubview(arrow)
        arrow.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
        }
    }
    
    var item: ProfileItem = .reminder {
        didSet {
            title.text = item.title
        }
    }
}

class TipCell: UITableViewCell {
    
    lazy var bg: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(hex: 0x030002)
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
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
        self.selectionStyle = .none
        
        addSubview(bg)
        bg.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().offset(-6)
            make.center.equalToSuperview()
        }
        
        addSubview(title)
        title.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-103)
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(24)
            make.bottom.equalToSuperview().offset(-24)
        }
    }
    
    var item: ProfileItem = .tip1 {
        didSet{
            title.text = item.title
            bg.image = UIImage(named: item.bg)
        }
    }
}
