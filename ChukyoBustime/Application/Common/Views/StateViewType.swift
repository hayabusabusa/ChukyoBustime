//
//  StateViewType.swift
//  ChukyoBustime
//
//  Created by 山田隼也 on 2020/04/18.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit

enum StateViewType {
    case toStation
    case toCollege
    
    var emptyImage: UIImage? {
        switch self {
        case .toStation, .toCollege:
            return UIImage(named: "img_operation_end")
        }
    }
    
    var emptyTitle: String? {
        switch self {
        case .toStation, .toCollege:
            return "本日の運行は終了しました"
        }
    }
    
    var emptyContent: String? {
        switch self {
        case .toStation, .toCollege:
            return "明日の運行カレンダーと時刻表は\n以下から確認できます"
        }
    }
    
    var errorImage: UIImage? {
        switch self {
        case .toStation, .toCollege:
            return nil
        }
    }
    
    var errorTitle: String? {
        switch self {
        case .toStation, .toCollege:
            return "エラーが発生しました"
        }
    }
    
    var errorContent: String? {
        switch self {
        case .toStation, .toCollege:
            return "予期しないエラーが発生しました"
        }
    }
}
