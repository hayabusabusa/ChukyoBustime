//
//  FirestoreRepository.swift
//  Infra
//
//  Created by Yamada Shunya on 2020/01/30.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import RxSwift
import SwiftDate

// MARK: - Interface

public protocol FirestoreRepository {
    func getBusTimes(at date: Date, destination: BusDestination) -> Single<(busDate: BusDateEntity, busTimes: [BusTimeEntity])>
}

// MARK: - Implementation

public struct FirestoreRepositoryImpl: FirestoreRepository {
    
    // MARK: Dependency
    
    private let provider: FirestoreProvider
    
    // MARK: Initializer
    
    public init(provider: FirestoreProvider = FirestoreProvider.shared) {
        self.provider = provider
    }
    
    // MARK: Firestore
    
    public func getBusTimes(at date: Date, destination: BusDestination) -> Single<(busDate: BusDateEntity, busTimes: [BusTimeEntity])> {
        // NOTE: デフォルトの `Date` は GMT で設定されているため、9時間ずれる.
        // SwiftDate の `DateInRegion` で日本の日付にした上で YYYY-MM-dd のフォーマットにする.
        let dateInRegion = DateInRegion(date, region: .current)
        return provider.getBusDate(at: dateInRegion.toFormat("YYYY-MM-dd"))
            .flatMap { busDate -> Single<(busDate: BusDateEntity, busTimes: [BusTimeEntity])> in
                let second = dateInRegion.hour * 3600 + dateInRegion.minute * 60 + dateInRegion.second
                return self.provider.getBusTimes(at: busDate, destination: destination, second: second)
            }
    }
}
