//
//  CacheUtil.swift
//  DrinkMoment
//
//  Created by Super on 2024/2/20.
//

import Foundation
import Foundation

class CacheUtil {
    static let  shared = CacheUtil()
    
    @FileHelper(.drinks, default: [])
    var drinks: [DrinksModel]
    
    @FileHelper(.goal, default: 2000)
    var goal: Int
    
    @FileHelper(.reminders, default: ReminderModel.models)
    var reminders: [ReminderModel]
    
    @FileHelper(.week, default: false)
    var weekMode: Bool
}
