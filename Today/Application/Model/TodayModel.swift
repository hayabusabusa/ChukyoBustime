//
//  TodayModel.swift
//  Today
//
//  Created by 山田隼也 on 2020/03/17.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import Infra
import RxSwift
import SwiftDate

// MARK: - Interface

protocol TodayModel {
    func loadCache(at date: Date) -> Single<(college: String?, station: String?)>
}

// MARK: - Implementation

struct TodayModelImpl: TodayModel {
    
    // MARK: Dependency
    
    private let repository: LocalCacheRepository
    
    // MARK: Initializer
    
    init(repository: LocalCacheRepository = LocalCacheRepositoryImpl()) {
        self.repository = repository
    }
    
    // MARK: Cache
    
    func loadCache(at date: Date) -> Single<(college: String?, station: String?)> {
        return Single.zip(repository.loadCache(of: CollegeLocalCache.self), repository.loadCache(of: StationLocalCache.self))
            .map { caches in
                let now = DateInRegion(date, region: .current)
                let second = now.hour * 3600 + now.minute * 60 + now.second
                
                let college: String?
                let station: String?
                
                if let filteredCollege = caches.0.busTimes.first(where: { $0.second > second })?.second {
                    college = String(format: "%02i:%02i", filteredCollege / 60 % 60, filteredCollege % 60)
                } else {
                    college = nil
                }
                if let filteredStation = caches.1.busTimes.first(where: { $0.second > second })?.second {
                    station = String(format: "%02i:%02i", filteredStation / 60 % 60, filteredStation % 60)
                } else {
                    station = nil
                }
                
                return (college: college, station: station)
            }
    }
}
