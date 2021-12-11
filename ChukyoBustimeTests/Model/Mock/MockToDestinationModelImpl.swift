//
//  MockToDestinationModelImpl.swift
//  ChukyoBustimeTests
//
//  Created by Shunya Yamada on 2021/12/11.
//  Copyright © 2021 Shunya Yamada. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

@testable import ChukyoBustime

final class MockToDestinationModelImpl: ToDestinationModel {
    let busDate: BusDate
    let busTimes: [BusTime]
    let isErrorOccured: Bool
    
    private let isLoadingRelay: BehaviorRelay<Bool>
    private let errorRelay: PublishRelay<Error>
    private let diagramRelay: BehaviorRelay<String>
    private let busTimesRelay: BehaviorRelay<[BusTime]>
    private let calendarPDFURLRelay: PublishRelay<String>
    private let timeTablePDFURLRelay: PublishRelay<String>
    
    let isLoadingStream: Observable<Bool>
    let errorStream: Observable<Error>
    let countupRelay: PublishRelay<Void>
    let diagramStream: Observable<String>
    let busTimesStream: Observable<[BusTime]>
    let pdfURLStream: Observable<String>
    
    init(busDate: BusDate,
         busTimes: [BusTime],
         isErrorOccured: Bool = false) {
        self.busDate = busDate
        self.busTimes = busTimes
        self.isErrorOccured = isErrorOccured
        
        self.isLoadingRelay = .init(value: true)
        self.isLoadingStream = isLoadingRelay.asObservable()
        self.errorRelay = .init()
        self.errorStream = errorRelay.asObservable()
        self.countupRelay = .init()
        self.diagramRelay = .init(value: "")
        self.diagramStream = diagramRelay.asObservable()
        self.busTimesRelay = .init(value: [])
        self.busTimesStream = busTimesRelay.asObservable()
        self.calendarPDFURLRelay = .init()
        self.timeTablePDFURLRelay = .init()
        self.pdfURLStream = Observable.merge([calendarPDFURLRelay.asObservable(),
                                              timeTablePDFURLRelay.asObservable()])
    }
    
    func getBusTimes(at date: Date) {
        if isErrorOccured {
            errorRelay.accept(MockError.somethingWentWrong)
        } else {
            diagramRelay.accept(busDate.diagramName)
            busTimesRelay.accept(busTimes)
        }
        
    }
    
    func updateBusTimes() {
        if isErrorOccured {
            errorRelay.accept(MockError.somethingWentWrong)
        } else {
            busTimesRelay.accept(busTimes)
        }
    }
    
    func getPDFURL(for type: PDFURLType) {
        switch type {
        case .calendar:
            calendarPDFURLRelay.accept(Stub.pdfURL.calendar)
        case .timeTable:
            timeTablePDFURLRelay.accept(Stub.pdfURL.timeTable)
        }
    }
}
