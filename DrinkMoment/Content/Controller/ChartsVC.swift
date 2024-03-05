//
//  ChartsVC.swift
//  DrinkMoment
//
//  Created by Super on 2024/2/20.
//

import UIKit

class ChartsVC: BaseVC {
    
    lazy var collectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ChartsCell.classForCoder(), forCellWithReuseIdentifier: "ChartsCell")
        return collectionView
    }()
    
    var item: ChartsItem = .day
    var selectIndex: Int = 0
    let mls = [3000, 2500, 2000, 1500, 1000, 500, 0]
    private var unitDatasource: [String] {
        switch item {
        case .day:
            return ["06:00", "12:00", "18:00", "24:00"]
        case .week:
            return ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        case .month:
            var days: [String] = []
            for index in 0..<30 {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd"
                let date = Date(timeIntervalSinceNow: TimeInterval(index * 24 * 60 * 60 * -1))
                let day = formatter.string(from: date)
                days.insert(day, at: 0)
            }
            return days
        case .year:
            var months: [String] = []
            for index in 0..<12 {
                let d = Calendar.current.date(byAdding: .month, value: -index, to: Date()) ?? Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM"
                let day = formatter.string(from: d)
                months.insert(day, at: 0)
            }
            return months
        }
    }
    
    private var datasource: [ChartsModel] {
        var max: Int = mls.max() ?? 1
        switch item {
        case .day:
            return unitDatasource.map({ time in
                let total = drinks.filter { model in
                    if let t = time.components(separatedBy: ":").first, let max = Int(t), model.date.isToday {
                        let min = max - 6
                        if model.date.hour >= min, model.date.hour <= max {
                            return true
                        }
                    }
                    return false
                }.map({
                    $0.ml
                }).reduce(0, +)
                return ChartsModel(progress: Double(total)  / Double(max) , ml: total, unit: time)
            })
        case .week:
            return unitDatasource.map { weeks in
                // 当前搜索目的周几 需要从周日开始作为下标0开始的 所以 unit数组必须是7123456
                let week = unitDatasource.firstIndex(of: weeks) ?? 0
                
                // 当前日期 用于确定当前周
                let weekDay = Calendar.current.component(.weekday, from: Date())
                let firstCalendar = Calendar.current.date(byAdding: .day, value: 1-weekDay, to: Date()) ?? Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                // 目标日期
                let target = Calendar.current.date(byAdding: .day, value: week, to: firstCalendar) ?? Date()
                let targetString = dateFormatter.string(from: target)
                
                
                let total: Int = drinks.filter {$0.date.date == targetString}.map({ $0.ml}).reduce(0, +)
                return ChartsModel(progress: Double(total)  / Double(max), ml: total, unit: weeks)
            }
        case .month:
            return unitDatasource.reversed().map { date in
                let year = Calendar.current.component(.year, from: Date())
                
                let month = date.components(separatedBy: "/").first ?? "01"
                let day = date.components(separatedBy: "/").last ?? "01"
                
                let total = drinks.filter { $0.date.date == "\(year)-\(month)-\(day)"}.map({ $0.ml }).reduce(0, +)
                
                return ChartsModel(progress: Double(total)  / Double(max), ml: total, unit: date)
                
            }
        case .year:
            max *= 30
            return  unitDatasource.reversed().map { month in
                let total = drinks.filter { model in
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    let date = formatter.date(from: model.date.date)
                    formatter.dateFormat = "MMM"
                    let m = formatter.string(from: date!)
                    return m == month
                }.map({ $0.ml }).reduce(0, +)
                return ChartsModel(progress: Double(total)  / Double(max), ml: total, unit: month)
            }
        }
    }
    @FileHelper(.drinks, default: [])
    var drinks: [DrinksModel]

    override func viewDidLoad() {
        super.viewDidLoad()
        addNotification()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "charts_title")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "record_history")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(toHistoryVC))
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
    
    @objc func toHistoryVC() {
        let vc = HistoryVC()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ChartsVC {
    override func setupUI() {
        super.setupUI()
        let buttonView = ChartsButtonView()
        buttonView.backgroundColor = UIColor.init(hex: 0xF5F6FB)
        buttonView.layer.cornerRadius = 24
        buttonView.layer.masksToBounds = true
        buttonView.didSelected = { item in
            self.item = item
            self.selectIndex = 0
            self.collectionView.reloadData()
        }
        view.addSubview(buttonView)
        buttonView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin).offset(16)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(48)
        }
        
        let contentView = UIView()
        contentView.backgroundColor = UIColor.init(hex: 0xF8F8FA)
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(buttonView.snp.bottom).offset(32)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(296)
        }

        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
}

extension ChartsVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        unitDatasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChartsCell", for: indexPath)
        if let cell = cell as? ChartsCell {
            cell.model = datasource[indexPath.row]
            cell.isSelected = self.selectIndex == indexPath.row
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 296)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.01
    }
}

class ChartsCell: UICollectionViewCell {
    
    lazy var view = {
        let view = UIView()
        return view
    }()
    
    lazy var progressView = {
        let progressView = UIView()
        progressView.backgroundColor = UIColor.init(hex: 0x3E53CB)
        return progressView
    }()
    
    lazy var  mlLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .black
        label.font = .systemFont(ofSize: 10.0)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    lazy var unitLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(hex: 0xCACBD0)
        label.font = .systemFont(ofSize: 12.0)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    func setupUI() {

        addSubview(view)
        view.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(254)
            make.width.equalTo(6)
            make.centerX.equalToSuperview()
        }
        
        addSubview(mlLabel)
        mlLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(22)
        }

        var progress = model?.progress ?? 0.0
        if progress >= 0.92 {
            progress = 0.92
        }
        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.height.equalTo(view.snp.height).multipliedBy(progress)
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(mlLabel.snp.bottom).offset(2)
        }
        
        addSubview(unitLabel)
        unitLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    var model: ChartsModel? = nil {
        didSet {
            var progress = model?.progress ?? 0.0
            if progress >= 0.92 {
                progress = 0.92
            }
            progressView.snp.remakeConstraints { make in
                make.height.equalTo(view.snp.height).multipliedBy(progress)
                make.left.right.bottom.equalToSuperview()
                make.top.equalTo(mlLabel.snp.bottom).offset(2)
            }
            
            unitLabel.text = model?.unit
            mlLabel.text = "\(model?.ml ?? 0) ml"
        }
    }
    
    override var isSelected: Bool {
        didSet{
            progressView.backgroundColor = isSelected ? .black : UIColor.init(hex: 0x3E53CB)
            mlLabel.isHidden = !isSelected
            if let ml = model?.ml, ml == 0 {
                mlLabel.isHidden = true
            }
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
