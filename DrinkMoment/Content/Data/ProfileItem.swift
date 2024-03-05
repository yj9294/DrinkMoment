//
//  ProfileItem.swift
//  DrinkMoment
//
//  Created by Super on 2024/2/22.
//

import UIKit

enum ProfileItem {
    case reminder, privacy, rate, tip1, tip2, tip3
    
    var title: String {
        switch self {
        case .reminder:
            return "Reminder Time"
        case .privacy:
            return "Privacy Policy"
        case .rate:
            return "Rate us"
        case .tip1:
            return "The Importance of Water and scientific drinking advice"
        case .tip2:
            return "Cold or warm? Science shows you the right way to drink water"
        case .tip3:
            return "Time to drink water, scientific guidelines to make you healthier"
        }
    }
    
    var bg: String {
        if self == .tip1 {
            return "profile_tip1"
        } else if self == .tip2 {
            return "profile_tip2"
        } else if self == .tip3 {
            return "profile_tip3"
        }
        return ""
    }
    
    var description: String {
        if self == .tip1 {
            return """
Water is the basis for maintaining a healthy life, and drinking enough water has a positive impact on all aspects of the body. Here are some tips to help you drink water scientifically and keep your body hydrated.

Water makes up the vast majority of the human body and is involved in important physiological processes such as temperature regulation, metabolism and the transport of nutrients. To take full advantage of the benefits of water, science recommends that adults drink at least about 8 glasses of water (about 2 liters) per day, but actual needs vary from person to person. The best times to drink water include after waking up, before and after eating, and during exercise. By following these tips, you will better maintain your body's water balance and promote a healthy lifestyle.
"""
        } else if self == .tip2 {
            return """
Water temperature has a certain impact on the process of drinking water, and choosing the right water temperature helps to better absorb water. Here are some suggestions to help you choose your drinking temperature scientifically and rationally.

Cold water and warm water have their own applications. Cold water helps to lower body temperature and is suitable for drinking in hot weather or after exercise. Warm water, on the other hand, is more easily absorbed by the stomach and helps boost metabolism. Under normal circumstances, it is appropriate to choose warm water to help the body absorb water more effectively, but in special circumstances (such as high temperature weather, intense exercise), you can also choose the right amount of cold water. According to personal taste and environmental conditions, the scientific choice of drinking water temperature helps to better enjoy the health benefits of water.
"""
        } else if self == .tip3 {
            return """
The scientific arrangement of drinking time helps to better maintain the body's water balance and promote metabolism. Here are some tips to help you time your water scientifically.

Choosing the right time to drink water at different times of the day has different benefits for the body. After you wake up in the morning, a glass of warm water helps to wake up your body and activate your metabolism. Drinking water before and after meals helps to promote digestion and absorption. During exercise, replenish water to maintain fluid balance. Drinking moderate amounts of water before going to bed at night can help relieve nighttime dehydration. Reasonable arrangement of drinking time helps to better meet the physiological needs of the body and maintain the health of the body.

By following these scientifically sound tips for drinking water, you will better maintain your body's water balance, enjoy the benefits of water, and promote overall health.
"""
        }
        return ""
    }
}
