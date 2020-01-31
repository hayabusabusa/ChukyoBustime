//
//  ToStationModel.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/31.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import Infra
import RxSwift

// MARK: - Interface

protocol ToStationModel: AnyObject {
    func getBusTimes(at date: Date) -> Single<(busDate: BusDate, busTimes: [BusTime])>
}

// MARK: - Implementation

class ToStationModelImpl: ToStationModel {
    
    // MARK: Dependency
    
    private let firestoreRepository: FirestoreRepository
    
    // MARK: Initializer
    
    init(firestoreRepository: FirestoreRepository = FirestoreRepositoryImpl()) {
        self.firestoreRepository = firestoreRepository
    }
    
    func getBusTimes(at date: Date) -> Single<(busDate: BusDate, busTimes: [BusTime])> {
        return firestoreRepository.getBusTimes(at: date, destination: .toStation)
            .translate(BusDateAndBusTimesTranslator())
    }
}
