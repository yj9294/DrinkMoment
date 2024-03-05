//
//  RewardModel.swift
//  DrinkMoment
//
//  Created by Super on 2024/2/22.
//

import UIKit

protocol RewardItem: CaseIterable, Equatable {
    var numbers: [Int] { get }
    var number: Int { get }
    var icon: String { get }
}

extension RewardItem {
    var number: Int {
        let index = Self.allCases.firstIndex(of: self)
        return numbers[index as! Int]
    }
}

enum RewardKeepItem: String, RewardItem {
    case days, week, month, months, halfyear, year
    var numbers: [Int] {
        [3, 7, 30, 90, 180, 365]
    }

    var icon: String {
        let drinks = CacheUtil.shared.drinks
        return hasConsecutiveDates(drinks, number) ? enableIcon : disableIcon
    }
    
    private var enableIcon: String {
        return "reward_keep_\(self.rawValue)"
    }
    
    private var disableIcon: String {
        enableIcon + "_1"
    }
    
    func hasConsecutiveDates(_ drinks: [DrinksModel], _ n: Int) -> Bool {
        let dateModels: [[DrinksModel]] =  drinks.reduce([[]]) { partialResult, model in
            var result = partialResult
            if var p = result.first {
                if let f = p.first, f.date.date == model.date.date  {
                    p.insert(model, at: 0)
                    result[0] = p
                    return result
                }
                result.insert([model], at: 0)
                return result
            }
            result = [[model]]
            return result
        }
        
        let dates = dateModels.compactMap{$0.first}.map { $0.date }.sorted { l1, l2 in
            return l1 < l2
        }
        
        guard n > 1, dates.count >= n else {
            // 如果 n 不大于 1 或者日期数组长度小于 n，则直接返回 false
            return false
        }

        for i in 0...(dates.count - n) {
            let startDate = dates[i]
            let endDate = dates[i + n - 1]

            // 计算当前日期范围内的日期数量
            let currentDates = dates.filter { $0 >= startDate && $0 <= endDate }

            if currentDates.count == n {
                // 找到了 n 个连续的日期
                return true
            }
        }

        // 未找到 n 个连续的日期
        return false
    }
}

enum RewardArchmentItem: String, RewardItem {
    var numbers: [Int] {
        [1, 10, 30, 100, 200, 300]
    }
    
    case one, ten, ten3, houndred, houndred2, houndred3
    var icon: String {
        let drinks = CacheUtil.shared.drinks
        return hasKeepGoal(drinks, number) ? enableIcon : disableIcon
    }
    
    var enableIcon: String {
        return "reward_archment_\(self.rawValue)"
    }
    
    var disableIcon: String {
        enableIcon + "_1"
    }
    
    func hasKeepGoal(_ models: [DrinksModel], _ n: Int) -> Bool {
        let dateModels: [[DrinksModel]] =  models.reduce([[]]) { partialResult, model in
            var result = partialResult
            if var p = result.first {
                if let f = p.first, f.date.date == model.date.date  {
                    p.insert(model, at: 0)
                    result[0] = p
                    return result
                }
                result.insert([model], at: 0)
                return result
            }
            result = [[model]]
            return result
        }
        
        let goals = dateModels.map { dateModels in
            let ml = dateModels.map({$0.ml}).reduce(0, +)
            let goal = dateModels.first?.goal ?? 2000
            return MedalGoalModel(ml: ml, goal: goal)
        }
        
        return goals.filter({$0.ml >= $0.goal}).count >= n
    }

}

struct MedalGoalModel {
    var ml: Int
    var goal: Int
}

