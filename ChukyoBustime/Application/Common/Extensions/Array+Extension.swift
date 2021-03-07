//
//  Array+Extension.swift
//  ChukyoBustime
//
//  Created by Shunya Yamada on 2021/03/07.
//  Copyright © 2021 Shunya Yamada. All rights reserved.
//

import Foundation

extension Array {
    
    /// 空配列でも実行可能な `removeFirst()`
    /// - Returns: 削除した要素 ( `@discardableResult` 指定 )
    @discardableResult mutating func popFirst() -> Element? {
        guard !self.isEmpty else {
            return nil
        }
        return self.removeFirst()
    }
}
