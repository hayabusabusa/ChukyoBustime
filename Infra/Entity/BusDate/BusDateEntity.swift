//
//  BusDateEntity.swift
//  Infra
//
//  Created by Yamada Shunya on 2020/01/29.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation

public struct BusDateEntity: Decodable {
    public let diagram: String
    public let diagramName: String
    
    private enum CodingKeys: String, CodingKey {
        case diagram
        case diagramName
    }
}
