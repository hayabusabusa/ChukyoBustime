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
    func getDiagram(at date: Date) -> Single<BusDiagram>
    func getBusTimes(of diagram: BusDiagram, destination: BusDestination, second: Int) -> Single<[BusTimeEntity]>
    func getBusTimes(at date: Date, destination: BusDestination) -> Single<[BusTimeEntity]>
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
    
    public func getDiagram(at date: Date) -> Single<BusDiagram> {
        return provider.getDiagram(at: date.toFormat("YYYY-MM-dd"))
    }
    
    public func getBusTimes(of diagram: BusDiagram, destination: BusDestination, second: Int) -> Single<[BusTimeEntity]> {
        return provider.getBusTimes(of: diagram, destination: destination, second: second)
    }
    
    public func getBusTimes(at date: Date, destination: BusDestination) -> Single<[BusTimeEntity]> {
        return provider.getDiagram(at: date.toFormat("YYYY-MM-dd"))
            .flatMap { diagram -> Single<[BusTimeEntity]> in
                let dateInRegion = DateInRegion(date, region: .current)
                let second = dateInRegion.hour * 3600 + dateInRegion.minute * 60 + dateInRegion.second
                return self.provider.getBusTimes(of: diagram, destination: destination, second: second)
            }
    }
}
