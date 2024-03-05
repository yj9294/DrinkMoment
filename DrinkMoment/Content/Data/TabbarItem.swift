//
//  TabbarItem.swift
//  DrinkMoment
//
//  Created by Super on 2024/2/20.
//

import UIKit

enum TabbarItem: String, CaseIterable {
    case drink, charts, reward, profile
    
    var icon: String {
        return "tabbar_" + self.rawValue
    }
    var disableIcon: String {
        icon + "_1"
    }
    
    var title: String {
        switch self {
        case .drink:
            return "Home"
        case .charts:
            return "Statistics"
        case .reward:
            return "Rewards"
        case .profile:
            return "Setting"
        }
    }
    
    var viewController: BaseVC {
        switch self {
        case .drink:
            return DrinkVC()
        case .charts:
            return ChartsVC()
        case .reward:
            return RewardVC()
        case .profile:
            return ProfileVC()
        }
    }
}
