//
//  MockRootModelImpl.swift
//  ChukyoBustimeTests
//
//  Created by Shunya Yamada on 2021/02/08.
//  Copyright © 2021 Shunya Yamada. All rights reserved.
//

import Foundation
import RxSwift
@testable import ChukyoBustime

final class MockRootModelImpl: RootModel {
    
    func fetchAndActivate() -> Completable {
        return Completable.create { observer in
            observer(.completed)
            return Disposables.create()
        }
    }
}
