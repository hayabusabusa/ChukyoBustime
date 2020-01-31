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
        return provider.getBusDate(at: date.toFormat("YYYY-MM-dd"))
            .flatMap { busDate -> Single<(busDate: BusDateEntity, busTimes: [BusTimeEntity])> in
                let dateInRegion = DateInRegion(date, region: .current)
                let second = dateInRegion.hour * 3600 + dateInRegion.minute * 60 + dateInRegion.second
                return self.provider.getBusTimes(at: busDate, destination: destination, second: second)
            }
    }
}
