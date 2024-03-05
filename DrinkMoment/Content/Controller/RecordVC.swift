//
//  RecordVC.swift
//  DrinkMoment
//
//  Created by Super on 2024/2/20.
//

import UIKit

class RecordVC: BaseVC {
    
    lazy var nameTxf = {
        let nameTxf = UITextField()
        nameTxf.font = .systemFont(ofSize: 19.0, weight: .medium)
        nameTxf.textColor = UIColor.init(hex: 0x020202)
        nameTxf.text = "Water"
        nameTxf.isEnabled = false
        return nameTxf
    }()
    
    lazy var mlTxf = {
        let mlTxf = UITextField()
        mlTxf.font = .systemFont(ofSize: 19.0, weight: .medium)
        mlTxf.textColor = UIColor.init(hex: 0x020202)
        mlTxf.keyboardType = .numbersAndPunctuation
        mlTxf.text = "200"
        return mlTxf
    }()
    
    @FileHelper(.goal, default:  2000)
    var goal: Int
    @FileHelper(.drinks, default: [])
    var drinks: [DrinksModel]
    
    var item: DrinksItem = .water {
        didSet {
            nameTxf.text = item.title
            mlTxf.text = "200"
            if item != .custom {
                nameTxf.isEnabled = false
            } else {
                nameTxf.isEnabled = true
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Record"
    }
    
    @objc func saveButtonTapped() {
        if let ml = Int(mlTxf.text ?? ""), ml > 0 {
            let model = DrinksModel(date: Date(), item: item, name: nameTxf.text ?? "", ml: ml, goal: goal)
            drinks.append(model)
        }
        NotificationCenter.default.post(name: .updateDrinks, object: drinks)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func hiddenKeyboard() {
        view.endEditing(true)
    }
}

extension RecordVC {
    override func setupUI() {
        super.setupUI()
        self.view.backgroundColor = UIColor.init(hex: 0x8DBFFF)
        
        let v = UIView()
        v.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(hiddenKeyboard)))
        view.addSubview(v)
        v.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        let inputView = UIView()
        inputView.layer.cornerRadius = 16
        inputView.layer.masksToBounds = true
        inputView.layer.borderColor = UIColor(hex: 0x020202).cgColor
        inputView.layer.borderWidth = 1
        view.addSubview(inputView)
        inputView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(view.snp.topMargin).offset(40)
            make.height.equalTo(120)
        }
        

        inputView.addSubview(nameTxf)
        nameTxf.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(19)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(hex: 0x020202)
        inputView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(22)
            make.right.equalToSuperview().offset(-22)
            make.height.equalTo(1)
            make.centerY.equalToSuperview()
        }
        
        inputView.addSubview(mlTxf)
        mlTxf.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-18)
        }
        
        let unitLabel = UILabel()
        unitLabel.text = "ml"
        unitLabel.textColor = UIColor(hex: 0xB5B8C5)
        unitLabel.font = .systemFont(ofSize: 16)
        inputView.addSubview(unitLabel)
        unitLabel.snp.makeConstraints { make in
            make.centerY.equalTo(mlTxf)
            make.right.equalToSuperview().offset(-22)
        }
        
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 32
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(inputView.snp.bottom).offset(30)
            make.left.bottom.right.equalToSuperview()
        }
        
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(RecordCell.classForCoder(), forCellWithReuseIdentifier: "RecordCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        let button = UIButton()
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor(hex: 0x3E53CB)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("OK", for: .normal)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        contentView.addSubview(button)
        button.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(64)
            make.top.equalTo(collectionView.snp.bottom).offset(30)
        }
    }
}

extension RecordVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        DrinksItem.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecordCell", for: indexPath)
        if let cell = cell as? RecordCell {
            cell.item = DrinksItem.allCases[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.width
        let w = (width - 40 - 12) / 2.0 - 1
        let h = 110.0
        return CGSize(width: w, height: h)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = DrinksItem.allCases[indexPath.row]
        self.item = item
        view.endEditing(true)
    }
}


class RecordCell: UICollectionViewCell {
    private lazy var icon: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    private lazy var bg: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var item: DrinksItem = .water {
        didSet {
            icon.image = UIImage(named: item.icon)
            title.text = item.description
            bg.image = UIImage(named: item.bg)
        }
    }
    
    func setupUI() {
        contentView.addSubview(bg)
        bg.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        contentView.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.bottom).offset(4)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
    }
}
