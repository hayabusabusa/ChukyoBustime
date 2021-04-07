//
//  MockPDFButtonsModelImpl.swift
//  ChukyoBustimeTests
//
//  Created by Shunya Yamada on 2021/02/24.
//  Copyright © 2021 Shunya Yamada. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
@testable import ChukyoBustime

final class MockPDFButtonsModelImpl: PDFButtonsModel {
    private let pdfURLRelay: PublishRelay<URL>
    let pdfURLStream: Observable<URL>
    
    init() {
        self.pdfURLRelay = .init()
        
        pdfURLStream = pdfURLRelay.asObservable()
    }
    
    func getPDFURL(of type: PDFURLType) {
        switch type {
        case .calendar:
            pdfURLRelay.accept(URL(string: Mock.pdfURLEntity.calendar)!)
        case .timeTable:
            pdfURLRelay.accept(URL(string: Mock.pdfURLEntity.timeTable)!)
        }
    }
}
