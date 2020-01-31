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
    func getDiagram(at date: Date) -> Single<BusDiagram>
}

// MARK: - Implementation

class ToStationModelImpl: ToStationModel {
    
    // MARK: Dependency
    
    private let firestoreRepository: FirestoreRepository
    
    // MARK: Initializer
    
    init(firestoreRepository: FirestoreRepository = FirestoreRepositoryImpl()) {
        self.firestoreRepository = firestoreRepository
    }
    
    func getDiagram(at date: Date) -> Single<BusDiagram> {
        return firestoreRepository.getDiagram(at: date)
    }
}
