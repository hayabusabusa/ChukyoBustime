//
//  BusDateEntity.swift
//  Infra
//
//  Created by Yamada Shunya on 2020/01/29.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import RealmSwift

public final class BusDateEntity: Object, Decodable {
    @objc public dynamic var diagram: String = ""
    @objc public dynamic var diagramName: String = ""
    
    private enum CodingKeys: String, CodingKey {
        case diagram
        case diagramName
    }
    
    public convenience init(diagram: String, diagramName: String) {
        self.init()
        self.diagram = diagram
        self.diagramName = diagramName
    }
    
    public required init() {
        super.init()
    }
}
