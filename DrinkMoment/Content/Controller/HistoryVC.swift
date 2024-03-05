//
//  HistoryVC.swift
//  DrinkMoment
//
//  Created by Super on 2024/2/21.
//

import UIKit

class HistoryVC: BaseVC {
    
    @FileHelper(.drinks, default: [])
    var drinks: [DrinksModel]
    
    private var datasource: [[DrinksModel]] {
        return drinks.reduce([]) { (result, item) -> [[DrinksModel]] in
            var result = result
            if result.count == 0 {
                result.append([item])
            } else {
                if var arr = result.last, let lasItem = arr.last, lasItem.date.date == item.date.date  {
                    arr.append(item)
                    result[result.count - 1] = arr
                } else {
                    result.append([item])
                }
            }
           return result
        }.reversed()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension HistoryVC {
    override func setupUI() {
        super.setupUI()
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        collectionView.register(HistoryCell.classForCoder(), forCellWithReuseIdentifier: "HistoryCell")
        collectionView.register(HistoryHeaderView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HistoryHeaderView")
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

extension HistoryVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryCell", for: indexPath)
        if let cell = cell as? HistoryCell {
            cell.model = datasource[indexPath.section][indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HistoryHeaderView", for: indexPath)
        if let view = view as?  HistoryHeaderView {
            if let date = datasource[indexPath.section].first?.date {
                view.date = date.date
            }
        }
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 100, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.bounds.width
        let w = (width - 20 * 2 - 12 * 2) / 3.0 - 1
        let h = 118.0
        return CGSize(width: w, height: h)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        12.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        12.0
    }

}

class HistoryHeaderView: UICollectionReusableView {
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        label.textColor = UIColor.init(hex: 0xB5B8C5)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview()
        }
    }
    
    var date: String = ""{
        didSet {
            dateLabel.text = date
        }
    }
}

class HistoryCell: UICollectionViewCell {
    lazy var icon: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    lazy var ml: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor(hex: 0xB5B8C5)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.backgroundColor = UIColor.init(hex: 0xF8F8FA)
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.width.height.equalTo(56)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(ml)
        ml.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
        }
    }
    
    var model: DrinksModel? = nil {
        didSet {
            guard let model = model else {return}
            icon.image = UIImage(named: model.item.icon)
            ml.text = "\(model.ml)ml"
            title.text = model.item.title
        }
    }
}
