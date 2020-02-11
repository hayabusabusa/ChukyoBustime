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
    
    // MARK: Initializer
    
    init(firestoreRepository: FirestoreRepository = FirestoreRepositoryImpl()) {
        self.firestoreRepository = firestoreRepository
    }
    
    // MARK: Firestore
    
    func getBusTimes(at date: Date) -> Single<(busDate: BusDate, busTimes: [BusTime])> {
        return firestoreRepository.getBusTimes(at: date, destination: .toCollege)
            .translate(BusDateAndBusTimesTranslator())
    }
}
