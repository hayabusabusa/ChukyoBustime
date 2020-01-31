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
    func getBusDate(at date: Date) -> Single<BusDate>
    func getBusTimes(of diagram: String, seconds: Int) -> Single<[BusTime]>
}

// MARK: - Implementation

class ToStationModelImpl: ToStationModel {
    
    // MARK: Dependency
    
    private let firestoreRepository: FirestoreRepository
    
    // MARK: Initializer
    
    init(firestoreRepository: FirestoreRepository = FirestoreRepositoryImpl()) {
        self.firestoreRepository = firestoreRepository
    }
    
    func getBusDate(at date: Date) -> Single<BusDate> {
        return firestoreRepository.getBusDate(at: date).translate(BusDateTranslator())
    }
    
    func getBusTimes(of diagram: String, seconds: Int) -> Single<[BusTime]> {
        return firestoreRepository.getBusTimes(of: diagram, destination: .toStation, second: seconds).translate(BusTimesTranslator())
    }
}
