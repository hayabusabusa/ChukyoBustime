//
//  Translator.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/31.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import RxSwift

public protocol Translator {
    associatedtype Input
    associatedtype Output
    func translate(_ input: Input) throws -> Output
}

public extension ObservableType {
    func translate<T: Translator>(with translator: T) -> Observable<T.Output> where Self.Element == T.Input {
        return map { try translator.translate($0) }
    }
}

extension Collection {
    public func translate<T: Translator>(with translator: T) throws -> [T.Output] where Self.Iterator.Element == T.Input {
        return try map { try translator.translate($0) }
    }
}
