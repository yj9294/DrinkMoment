//
//  RewardVC.swift
//  DrinkMoment
//
//  Created by Super on 2024/2/20.
//

import UIKit

class RewardVC: BaseVC {
    
    lazy var collectionView: UICollectionView = {
        let collectionFlowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionFlowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        collectionView.register(RewardCell.classForCoder(), forCellWithReuseIdentifier: "RewardCell")
        collectionView.register(RewardHeader.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RewardHeader")
        return collectionView
    }()
    
    var datasource: [[any RewardItem]] = [RewardKeepItem.allCases, RewardArchmentItem.allCases]
    var sections: [String] = ["Keep drinking water", "Drinking Water Achievement"]

    @FileHelper(.drinks, default: [])
    var drinks: [DrinksModel]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "reward_title")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: nil)
        drinks = FileHelper.getValueFor(.drinks, defaultValue: [])
        collectionView.reloadData()
    }
    
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateDrinks), name: .updateDrinks, object: nil)
    }
    
    @objc func updateDrinks(noti: Notification) {
        if let obj = noti.object as? [DrinksModel] {
            drinks = obj
            self.collectionView.reloadData()
        }
    }

}

extension RewardVC {
    override func setupUI() {
        super.setupUI()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(view.snp.topMargin)
        }
    }
}

extension RewardVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RewardCell", for: indexPath)
        if let cell = cell as? RewardCell {
            cell.item = datasource[indexPath.section][indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 200, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RewardHeader", for: indexPath)
        if let view = view as? RewardHeader {
            view.title = sections[indexPath.section]
        }
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.width
        let w = (width - 40 - 15 * 2) / 3.0 - 1
        return CGSize(width: w, height: w)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        15.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        15.0
    }
}

class RewardCell: UICollectionViewCell {
    lazy var icon: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(icon)
        icon.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    var item: (any RewardItem)? = nil {
        didSet {
            icon.image = UIImage(named: item?.icon ?? "")
        }
    }
}

class RewardHeader: UICollectionReusableView {
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(hex: 0x030002)
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setupUI() {
        addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    var title: String = "" {
        didSet {
            label.text = title
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
