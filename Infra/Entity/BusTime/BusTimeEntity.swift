//
//  BusTimeEntity.swift
//  Infra
//
//  Created by 山田隼也 on 2020/01/28.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation

public struct BusTimeEntity: Decodable {
    public let hour: Int
    public let minute: Int
    public let isReturn: Bool
    public let isLast: Bool
    
    private enum CodingKeys: String, CodingKey {
        case hour
        case minute
        case isReturn
        case isLast
    }
}
