//
//  BaseVC.swift
//  DrinkMoment
//
//  Created by Super on 2024/2/20.
//

import UIKit
import SnapKit

class BaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        debugPrint("\(self) viewDiLoad ☀️☀️☀️") 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (navigationController?.viewControllers.count ?? 0) > 1 {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(back))
        }
    }
    
    deinit{
        debugPrint("\(self) deinit 🫠🫠🫠")
    }
}

extension BaseVC {
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func setupUI() {
        view.backgroundColor = .white
    }
}
