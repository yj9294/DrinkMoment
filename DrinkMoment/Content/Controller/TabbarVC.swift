//
//  TabbarVC.swift
//  DrinkMoment
//
//  Created by Super on 2024/2/20.
//

import UIKit
import AppTrackingTransparency

class TabbarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = TabbarItem.allCases.map({getChildVC($0)})
        tabBar.tintColor = UIColor.init(hex: 0x3E53CB)
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            ATTrackingManager.requestTrackingAuthorization { _ in
            }
        }
    }
    
    func getChildVC(_ item: TabbarItem) -> UINavigationController {
        let vc = item.viewController
        let navigation = UINavigationController(rootViewController: vc)
        navigation.tabBarItem = UITabBarItem(title: item.title, image: UIImage(named: item.disableIcon), selectedImage: UIImage(named: item.icon))
        return navigation
    }

}
