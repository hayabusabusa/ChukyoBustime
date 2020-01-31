//
//  ViewableTranslator.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/31.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import RxCocoa

public protocol ViewableTranslator {
    associatedtype Input
    associatedtype Output
    func translate(_ input: Input) -> Output
}

extension SharedSequenceConvertibleType {
    func translate<T: ViewableTranslator>(with translator: T) -> SharedSequence<Self.SharingStrategy, T.Output> where Self.Element == T.Input {
        return map { translator.translate($0) }
    }
}
