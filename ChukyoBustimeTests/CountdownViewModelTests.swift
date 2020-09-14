//
//  CountdownViewModelTests.swift
//  ChukyoBustimeTests
//
//  Created by 山田隼也 on 2020/09/14.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import XCTest
import RxCocoa
import RxSwift
import RxTest
@testable import ChukyoBustime

class CountdownViewModelTests: XCTestCase {

    // MARK: Properties
    
    private let foregroundRelay             = PublishRelay<Void>()
    private let calendarButtonDidTapRelay   = PublishRelay<Void>()
    private let timeTableButtonDidTapRelay  = PublishRelay<Void>()
    private let settingBarButtonDidTapRelay = PublishRelay<Void>()
    
    // MARK: Setup

    override func setUp() {
        super.setUp()
    }
    
    // MARK: Tests
}
