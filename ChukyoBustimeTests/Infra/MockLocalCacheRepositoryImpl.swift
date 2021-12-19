//
//  MockLocalCacheRepositoryImpl.swift
//  ChukyoBustimeTests
//
//  Created by Shunya Yamada on 2021/12/18.
//  Copyright © 2021 Shunya Yamada. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

@testable import Infra

class MockLocalCacheRepositoryImpl: LocalCacheRepository {
    
    var stationCache: StationLocalCache?
    var collegeCache: CollegeLocalCache?
    
    func saveCache(of destination: BusDestination, date: Date, busDate: BusDateEntity, busTimes: [BusTimeEntity]) -> Completable {
        return Completable.create { [weak self] observer in
            
            switch destination {
            case .toCollege:
                let stationCache = StationLocalCache(lastUpdatedDate: "", busDate: busDate, busTimes: busTimes)
                self?.stationCache = stationCache
            case .toStation:
                let collegeCache = CollegeLocalCache(lastUpdatedDate: "", busDate: busDate, busTimes: busTimes)
                self?.collegeCache = collegeCache
            }
            
            observer(.completed)
            return Disposables.create()
        }
    }
    
    func checkCache(at date: Date, destination: BusDestination) -> Single<Bool> {
        let isStored: Bool
        switch destination {
        case .toCollege:
            isStored = collegeCache != nil
        case .toStation:
            isStored = stationCache != nil
        }
        return Single.just(isStored)
    }
    
    func loadCache<O>(of type: O.Type) -> Single<O> where O : Object, O : LocalCacheable {
        if let stationCache = stationCache as? O {
            return Single.just(stationCache)
        }
        if let collegeCache = collegeCache as? O {
            return Single.just(collegeCache)
        }
        return Single.error(MockError.somethingWentWrong)
    }
}
