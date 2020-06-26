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
            .map { (collegeLocalCache, stationLocalCache) in
                let now = DateInRegion(date, region: .current)
                let second = now.hour * 3600 + now.minute * 60 + now.second
                
                let college: String?
                let station: String?
                
                // NOTE: 最新のキャッシュが今日のキャッシュかどうかを確認した後にキャッシュを取り出し.
                if collegeLocalCache.lastUpdatedDate == now.toFormat("YYYY-MM-dd"),
                    let filteredCollege = collegeLocalCache.busTimes.first(where: { $0.second > second }){
                    college = String(format: "%02i:%02i", filteredCollege.hour, filteredCollege.minute)
                } else {
                    college = nil
                }
                // NOTE: 最新のキャッシュが今日のキャッシュかどうかを確認した後にキャッシュを取り出し.
                if stationLocalCache.lastUpdatedDate == now.toFormat("YYYY-MM-dd"),
                    let filteredStation = stationLocalCache.busTimes.first(where: { $0.second > second }) {
                    station = String(format: "%02i:%02i", filteredStation.hour, filteredStation.minute)
                } else {
                    station = nil
                }
                
                return (college: college, station: station)
            }
    }
}
