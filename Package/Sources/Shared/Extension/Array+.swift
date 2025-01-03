//
//  Array+.swift
//  
//
//  Created by Shunya Yamada on 2022/11/05.
//

import Foundation

public extension Array {
    /// 空配列でも実行可能な `removeFirst()`
    /// - Returns: 削除した要素 ( `@discardableResult` 指定 )
    @discardableResult mutating func popFirst() -> Element? {
        guard !self.isEmpty else {
            return nil
        }
        return self.removeFirst()
    }
}

