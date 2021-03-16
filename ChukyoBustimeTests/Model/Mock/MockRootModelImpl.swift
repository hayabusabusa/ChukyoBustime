//
//  MockRootModelImpl.swift
//  ChukyoBustimeTests
//
//  Created by Shunya Yamada on 2021/02/08.
//  Copyright © 2021 Shunya Yamada. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
@testable import ChukyoBustime

final class MockRootModelImpl: RootModel {
    
    private let isCompletedRelay: PublishRelay<Void>
    let isCompletedStream: Observable<Void>
    
    init() {
        self.isCompletedRelay = .init()
        isCompletedStream = isCompletedRelay.asObservable()
    }
    
    func fetch() {
        isCompletedRelay.accept(())
    }
}
