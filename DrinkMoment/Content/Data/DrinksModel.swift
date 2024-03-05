//
//  RecordModel.swift
//  DrinkMoment
//
//  Created by Super on 2024/2/20.
//

import Foundation

struct DrinksModel: Codable, Hashable, Equatable {
    var id: String = UUID().uuidString
    var date: Date
    var item: DrinksItem // 列别
    var name: String
    var ml: Int // 毫升
    var goal: Int
}

enum DrinksItem: String, Codable, CaseIterable {
    case water, drinks, coffee, tea, milk, custom
    var title: String{
        return self.rawValue.capitalized
    }
    
    var description: String {
        return "\(title) 200ml"
    }
    
    var icon: String {
        return "record_" + self.rawValue
    }
    
    var bg: String {
        return "record_" + self.rawValue + "_bg"
    }
}
