//
//  RCPdfUrlEntity.swift
//  Infra
//
//  Created by 山田隼也 on 2020/02/10.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation

public struct RCPdfUrlEntity: RemoteConfigType {
    public let calendar: String
    public let timeTable: String
    
    private enum CodingKeys: String, CodingKey {
        case calendar
        case timeTable = "time_table"
    }
}
