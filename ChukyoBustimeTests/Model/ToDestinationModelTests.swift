//
//  ToDestinationModelTests.swift
//  ChukyoBustimeTests
//
//  Created by Shunya Yamada on 2021/12/18.
//  Copyright © 2021 Shunya Yamada. All rights reserved.
//

import Infra
import RxSwift
import RxTest
import XCTest

@testable import ChukyoBustime

class ToDestinationModelTests: XCTestCase {
    
    func test_初期状態が正しいことを確認() {
        let disposeBag = DisposeBag()
        
        let busDate = BusDateEntity(diagram: "TEST", diagramName: "TEST")
        let firestoreRepository = MockFirestoreRepositoryImpl(busDate: busDate, busTimes: [])
        let localCacheRepository = MockLocalCacheRepositoryImpl()
        let remoteConfigProvider = MockRemoteConfigProvider()
        let model = ToDestinationModelImpl(for: .toStation,
                                           firestoreRepository: firestoreRepository,
                                           localCacheRepository: localCacheRepository,
                                           remoteConfigProvider: remoteConfigProvider)
        
        XCTContext.runActivity(named: "ロード中のフラグは True、エラーは nil で、データには空配列が流れてくること") { _ in
            let scheduler = TestScheduler(initialClock: 0)
            let isLoadingTestableObserver = scheduler.createObserver(Bool.self)
            let busTimesTestableObserver = scheduler.createObserver(Int.self)
            let errorTestableObserver = scheduler.createObserver(NSError?.self)
            
            model.isLoadingStream
                .subscribe(isLoadingTestableObserver)
                .disposed(by: disposeBag)
            model.busTimesStream
                .map { $0.count }
                .subscribe(busTimesTestableObserver)
                .disposed(by: disposeBag)
            model.errorStream
                .map { $0 != nil ? $0! as NSError : nil }
                .subscribe(errorTestableObserver)
                .disposed(by: disposeBag)
            
            scheduler.start()
            
            let expectedIsLoadingEvents = Recorded.events([
                .next(0, true)
            ])
            let expectedBusTimesEvents = Recorded.events([
                .next(0, 0)
            ])
            let expectedErrorEvents: [Recorded<Event<NSError?>>] = Recorded.events([
                .next(0, nil)
            ])
            
            XCTAssertEqual(isLoadingTestableObserver.events, expectedIsLoadingEvents)
            XCTAssertEqual(busTimesTestableObserver.events, expectedBusTimesEvents)
            XCTAssertEqual(errorTestableObserver.events, expectedErrorEvents)
        }
    }
}
