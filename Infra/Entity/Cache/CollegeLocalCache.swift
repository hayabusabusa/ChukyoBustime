//
//  CollegeLocalCache.swift
//  Infra
//
//  Created by 山田隼也 on 2020/03/17.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import RealmSwift

public final class CollegeLocalCache: Object, LocalCacheable {
    @objc public dynamic var lastUpdatedDate: String = "" // YYYY-MM-dd
    @objc public dynamic var busDate: BusDateEntity?
    var busTimes = List<BusTimeEntity>()
    
    convenience init(lastUpdatedDate: String, busDate: BusDateEntity, busTimes: [BusTimeEntity]) {
        self.init()
        self.lastUpdatedDate = lastUpdatedDate
        self.busDate = busDate
        self.busTimes = busTimes.reduce(List<BusTimeEntity>()) { $0.append($1); return $0 }
    }
    
    public required init() {
        super.init()
    }
}
