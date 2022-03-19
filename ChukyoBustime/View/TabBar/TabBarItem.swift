//
//  TabBarItem.swift
//  ChukyoBustime
//
//  Created by 山田隼也 on 2020/04/22.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit

enum TabBarItem: Int, CaseIterable {
    case toStation
    case toCollege
    
    var title: String {
        switch self {
        case .toStation: return "浄水駅行き"
        case .toCollege: return "大学行き"
        }
    }
    
    var icon: String? {
        switch self {
        case .toStation: return "ic_train"
        case .toCollege: return "ic_school"
        }
    }
}
