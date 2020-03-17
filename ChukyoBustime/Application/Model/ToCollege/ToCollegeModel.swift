//
//  ToCollegeModel.swift
//  ChukyoBustime
//
//  Created by 山田隼也 on 2020/02/06.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import Infra
import RxSwift

// MARK: - Interface

protocol ToCollegeModel: AnyObject {
    func getBusTimes(at date: Date) -> Single<(busDate: BusDate, busTimes: [BusTime])>
}

// MARK: - Implementation

class ToCollegeModelImpl: ToCollegeModel {
    
    // MARK: Dependency
    
    private let firestoreRepository: FirestoreRepository
    private let localCacheRepository: LocalCacheRepository
    
    // MARK: Initializer
    
    init(firestoreRepository: FirestoreRepository = FirestoreRepositoryImpl(),
         localCacheRepository: LocalCacheRepository = LocalCacheRepositoryImpl()) {
        self.firestoreRepository = firestoreRepository
        self.localCacheRepository = localCacheRepository
    }
    
    // MARK: Firestore
    
    /// 時刻表のデータをキャッシュもしくはFirestoreから取得する.
    /// - Parameter date: 取得するタイミングの`Date`.
    func getBusTimes(at date: Date) -> Single<(busDate: BusDate, busTimes: [BusTime])> {
        return localCacheRepository.checkCache(at: date, destination: .toCollege)
            .flatMap {
                $0 ? self.getBusTimesFromCache(at: date) : self.getBusTimesFromFirestore(at: date)
            }
    }
    
    private func getBusTimesFromCache(at date: Date) -> Single<(busDate: BusDate, busTimes: [BusTime])> {
        return localCacheRepository.loadCache(of: CollegeLocalCache.self)
            .map { (busDate: $0.busDate ?? BusDateEntity(diagram: "UNKNOWN", diagramName: "UNKNOWN"), busTimes: Array($0.busTimes)) }
            .translate(BusDateAndBusTimesTranslator()).debug()
    }
    
    private func getBusTimesFromFirestore(at date: Date) -> Single<(busDate: BusDate, busTimes: [BusTime])> {
        return firestoreRepository.getBusTimes(at: date, destination: .toCollege)
            .flatMap { value -> Single<(busDate: BusDate, busTimes: [BusTime])> in
                // NOTE: キャッシュを保存して完了した後にFirestoreから取得したものを流す.
                return self.localCacheRepository.saveCache(of: .toCollege, date: date, busDate: value.busDate, busTimes: value.busTimes)
                    .andThen(Single.just((busDate: value.busDate, busTimes: value.busTimes)))
                    .translate(BusDateAndBusTimesTranslator())
            }
    }
}
